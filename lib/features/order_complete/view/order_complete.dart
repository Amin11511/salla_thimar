import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skydive/core/routes/app_routes_fun.dart';
import 'package:skydive/core/services/server_gate.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../core/routes/routes.dart';
import '../../../core/utils/app_theme.dart';
import '../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../../../core/widgets/custom_message_dialog.dart';
import '../../../core/widgets/order_complete/payment_option.dart';
import '../../../core/widgets/wallet/mastercard_widget.dart';
import '../../../core/widgets/wallet/visa_card_widget.dart';
import '../../../gen/assets.gen.dart';
import '../../../models/user_model.dart';
import '../../address/address/cubit/address_cubit.dart';
import '../../address/address/cubit/address_state.dart';
import '../../address/address/model/address_model.dart';
import '../../address/address/repo/address_service.dart';
import '../../intro/verify_phone/model/verify_phone_model.dart';
import '../../wallet/payment/view/payment.dart';
import '../cubit/order_complete_cubit.dart';
import '../cubit/order_complete_state.dart';
import '../repo/order_complete_service.dart';

class OrderComplete extends StatefulWidget {
  final Map<String, dynamic> cartData;

  const OrderComplete({super.key, required this.cartData});

  @override
  State<OrderComplete> createState() => _OrderCompleteState();
}

class _OrderCompleteState extends State<OrderComplete> {
  String selectedMethod = "visa";
  String? selectedDate;
  String? selectedTime;
  int? selectedAddressId;
  Map<String, dynamic>? selectedCard;
  final TextEditingController notesController = TextEditingController();
  final Map<int, String> addressDisplayCache = {};
  late OrderCubit orderCubit;
  late CurrentAddressesCubit addressesCubit;

  @override
  void initState() {
    super.initState();
    orderCubit = OrderCubit(OrderService(ServerGate.i));
    addressesCubit = CurrentAddressesCubit(CurrentAddressesService(ServerGate.i));
    addressesCubit.fetchAddresses();
  }

  @override
  void dispose() {
    orderCubit.close();
    addressesCubit.close();
    notesController.dispose();
    super.dispose();
  }

  Future<String> _getAddressDisplayString(CurrentAddressesModel address) async {
    if (addressDisplayCache.containsKey(address.id)) {
      return addressDisplayCache[address.id]!;
    }

    final Map<String, String> cityTranslations = {
      'Riyadh': 'الرياض',
      'Jeddah': 'جدة',
      'Mecca': 'مكة',
      'Medina': 'المدينة',
      'Dammam': 'الدمام',
    };

    if (address.location != null && address.location!.isNotEmpty) {
      String displayString = address.location!;
      addressDisplayCache[address.id] = displayString;
      return displayString;
    }

    if (address.lat != null && address.lng != null && address.lat!.isFinite && address.lng!.isFinite) {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(address.lat!, address.lng!);
        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          String street = placemark.street ?? 'غير معروف';
          String city = placemark.locality ?? placemark.administrativeArea ?? 'غير معروف';

          if (RegExp(r'[a-zA-Z]').hasMatch(city)) {
            city = cityTranslations[city] ?? placemark.administrativeArea ?? 'غير معروف';
          }
          if (RegExp(r'[a-zA-Z]').hasMatch(street)) {
            street = 'شارع غير معروف';
          }

          String displayString = '$street, $city';
          addressDisplayCache[address.id] = displayString;
          return displayString;
        }
      } catch (e) {
        print('Error fetching address from coordinates: $e');
      }
    }

    String fallback = 'عنوان غير معروف';
    addressDisplayCache[address.id] = fallback;
    return fallback;
  }

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppThemes.greenColor.color,
              onPrimary: Colors.white,
              onSurface: AppThemes.greenColor.color,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppThemes.greenColor.color,
              ),
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        selectedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppThemes.greenColor.color,
              onPrimary: Colors.white,
              onSurface: AppThemes.greenColor.color,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppThemes.greenColor.color,
              ),
            ),
            dialogBackgroundColor: Colors.white,
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.selected) ? AppThemes.greenColor.color : AppThemes.lightLightGrey.color,
              ),
              hourMinuteTextColor: MaterialStateColor.resolveWith(
                    (states) => states.contains(MaterialState.selected) ? Colors.white : AppThemes.greenColor.color,
              ),
              dialHandColor: AppThemes.greenColor.color,
              dialBackgroundColor: AppThemes.whiteColor.color,
              entryModeIconColor: AppThemes.greenColor.color,
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() {
        selectedTime = "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<List<Map<String, dynamic>>> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString('cards');
    if (cardsJson != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(cardsJson));
    }
    return [];
  }

  Future<void> _saveCard(Map<String, dynamic> card) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> cards = await _loadCards();
    cards.add(card);
    await prefs.setString('cards', jsonEncode(cards));
  }

  void _showCardSelectionBottomSheet(String cardType) async {
    final cards = await _loadCards();
    final filteredCards = cards.where((card) => card['type'] == cardType).toList();

    if (filteredCards.isEmpty) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (bottomSheetContext) {
          return StatefulBuilder(
            builder: (context, setBottomSheetState) {
              return CardFormBottomSheet(
                cardType: cardType,
                onSave: (cardData) async {
                  final newCard = {
                    'type': cardType,
                    'name': cardData['name'],
                    'cardNumber': cardData['cardNumber'],
                    'validDate': cardData['validDate'],
                    'cvv': cardData['cvv'],
                    'isSelected': true,
                  };
                  await _saveCard(newCard);
                  setState(() {
                    selectedCard = newCard;
                    selectedMethod = cardType.toLowerCase();
                  });
                  showCustomMessageDialog(context, 'تم إضافة البطاقة بنجاح',);
                },
              );
            },
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (bottomSheetContext) {
          return StatefulBuilder(
            builder: (context, setBottomSheetState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "اختر بطاقة $cardType",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.greenColor.color,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: filteredCards.length,
                        itemBuilder: (context, index) {
                          final card = filteredCards[index];
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: SizedBox(
                              width: 300,
                              child: card['type'] == 'Visa'
                                  ? VisaCardWidget(
                                name: card['name'],
                                cardNumber: card['cardNumber'],
                                validDate: card['validDate'],
                                isSelected: selectedCard == card,
                                onDelete: null,
                                onToggleSelect: (value) {
                                  setState(() {
                                    selectedCard = value == true ? card : null;
                                    selectedMethod = cardType.toLowerCase();
                                  });
                                  if (value == true) {
                                    showCustomMessageDialog(context, 'تم اختيار البطاقة بنجاح',);
                                  }
                                },
                              )
                                  : MasterCardWidget(
                                name: card['name'],
                                cardNumber: card['cardNumber'],
                                validDate: card['validDate'],
                                isSelected: selectedCard == card,
                                onDelete: null,
                                onToggleSelect: (value) {
                                  setState(() {
                                    selectedCard = value == true ? card : null;
                                    selectedMethod = cardType.toLowerCase();
                                  });
                                  if (value == true) {
                                    showCustomMessageDialog(context, 'تم اختيار البطاقة بنجاح', );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _showAddCardBottomSheet(cardType, bottomSheetContext);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppThemes.greenColor.color,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "إضافة بطاقة جديدة",
                          style: TextStyle(
                            fontFamily: "Tajawal",
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          );
        },
      );
    }
  }

  void _showAddCardBottomSheet(String cardType, BuildContext previousBottomContext) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return StatefulBuilder(
          builder: (context, setBottomSheetState) {
            return CardFormBottomSheet(
              cardType: cardType,
              onSave: (cardData) async {
                final newCard = {
                  'type': cardType,
                  'name': cardData['name'],
                  'cardNumber': cardData['cardNumber'],
                  'validDate': cardData['validDate'],
                  'cvv': cardData['cvv'],
                  'isSelected': true,
                };
                await _saveCard(newCard);
                setState(() {
                  selectedCard = newCard;
                  selectedMethod = cardType.toLowerCase();
                });
                Navigator.of(bottomSheetContext).pop();
                showCustomMessageDialog(context, 'تم إضافة البطاقة بنجاح',);
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> cartData =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final double total = cartData['total'] ?? 0.0;
    final double discount = cartData['discount'] ?? 0.0;
    final bool isCashDisabled = total > 150;

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: orderCubit),
        BlocProvider.value(value: addressesCubit),
      ],
      child: BlocListener<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderSuccess) {
            showCustomMessageDialog(context, 'تم إنشاء الطلب بنجاح',);
          } else if (state is OrderError) {
            showCustomMessageDialog(context, state.message,);
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: "إتمام الطلب",
            onBackPressed: () {
              pushBack();
            },
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "الإسم: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "Tajawal",
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          UserModel.i.fullname,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "Tajawal",
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "الجوال: ",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "Tajawal",
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          UserModel.i.phone,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "Tajawal",
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "عنوان التوصيل",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "Tajawal",
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            push(NamedRoutes.addAddress).then((_) {
                              addressesCubit.fetchAddresses();
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppThemes.lightLightGrey.color,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Icon(Icons.add, color: AppThemes.greenColor.color),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<CurrentAddressesCubit, CurrentAddressesState>(
                      builder: (context, state) {
                        if (state is CurrentAddressesLoading) {
                          return Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color));
                        } else if (state is CurrentAddressesSuccess ||
                            state is DeleteAddressSuccess ||
                            state is UpdateAddressSuccess) {
                          final addresses = state is CurrentAddressesSuccess
                              ? state.addresses
                              : state is DeleteAddressSuccess
                              ? state.addresses
                              : (state as UpdateAddressSuccess).addresses;

                          if (addresses.isEmpty) {
                            return Text(
                              "لا توجد عناوين متاحة",
                              style: TextStyle(
                                fontFamily: "Tajawal",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppThemes.lightGrey.color,
                              ),
                            );
                          }

                          if (selectedAddressId == null && addresses.isNotEmpty) {
                            final defaultAddress = addresses.firstWhere(
                                  (address) => address.isDefault,
                              orElse: () => addresses.first,
                            );
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              setState(() {
                                selectedAddressId = defaultAddress.id;
                              });
                            });
                          }

                          return DropdownButtonFormField<int>(
                            value: selectedAddressId,
                            isDense: true,
                            itemHeight: 48,
                            dropdownColor: Colors.white,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppThemes.greenColor.color, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppThemes.greenColor.color, width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: AppThemes.greenColor.color, width: 2),
                              ),
                            ),
                            items: addresses.map((address) {
                              return DropdownMenuItem<int>(
                                value: address.id,
                                child: ClipRect(
                                  child: Container(
                                    constraints: BoxConstraints.tightFor(
                                      width: MediaQuery.of(context).size.width - 100,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Flexible(
                                          child: FutureBuilder<String>(
                                            future: _getAddressDisplayString(address),
                                            builder: (context, snapshot) {
                                              String displayText = 'جاري التحميل...';
                                              Color textColor = AppThemes.greenColor.color;
                                              if (snapshot.hasError) {
                                                displayText = 'خطأ في جلب العنوان';
                                                textColor = Colors.red;
                                              } else if (snapshot.hasData && snapshot.data != null) {
                                                displayText = snapshot.data!;
                                              } else {
                                                displayText = 'عنوان غير معروف';
                                              }
                                              return Text(
                                                displayText,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontFamily: "Tajawal",
                                                  color: textColor,
                                                ),
                                                textDirection: TextDirection.rtl,
                                                textAlign: TextAlign.right,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: false,
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedAddressId = value;
                              });
                            },
                          );
                        } else if (state is CurrentAddressesError) {
                          return Column(
                            children: [
                              Text(
                                state.message,
                                style: TextStyle(
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  addressesCubit.fetchAddresses();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppThemes.greenColor.color,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  "إعادة المحاولة",
                                  style: TextStyle(
                                    fontFamily: "Tajawal",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppThemes.whiteColor.color,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                        return const Text(
                          "حدث خطأ غير متوقع",
                          style: TextStyle(
                            fontFamily: "Tajawal",
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                              "تحديد وقت التوصيل",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: "Tajawal",
                                color: AppThemes.greenColor.color,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickTime,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppThemes.lightGrey.color,
                                  width: 1,
                                ),
                              ),
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Assets.images.time.path,
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      selectedTime ?? "اختر الوقت",
                                      style: TextStyle(
                                        fontFamily: "Tajawal",
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppThemes.greenColor.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppThemes.lightGrey.color,
                                  width: 1,
                                ),
                              ),
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      Assets.images.calender.path,
                                      width: 24,
                                      height: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      selectedDate ?? "اختر اليوم والتاريخ",
                                      style: TextStyle(
                                        fontFamily: "Tajawal",
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppThemes.greenColor.color,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "ملاحظات وتعليمات",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "Tajawal",
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: notesController,
                      textInputAction: TextInputAction.done,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textAlign: TextAlign.right,
                      maxLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppThemes.whiteColor.color,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppThemes.lightLightGrey.color,
                            width: 1.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppThemes.lightLightGrey.color,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: AppThemes.lightLightGrey.color,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.red, width: 2),
                        ),
                      ),
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04,
                        fontWeight: FontWeight.normal,
                        color: AppThemes.blackColor.color,
                        fontFamily: "Tajawal",
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "طريقة الدفع",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "Tajawal",
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        PaymentOption(
                          isSelected: selectedMethod == "cash",
                          onTap: isCashDisabled
                              ? null
                              : () {
                            setState(() {
                              selectedMethod = "cash";
                              selectedCard = null;
                            });
                          },
                          child: Image.asset(
                            Assets.images.money.path,
                            width: 24,
                            height: 24,
                            color: isCashDisabled ? Colors.grey : null,
                          ),
                        ),
                        const SizedBox(width: 20),
                        PaymentOption(
                          isSelected: selectedMethod == "visa",
                          onTap: () {
                            _showCardSelectionBottomSheet("Visa");
                          },
                          child: Image.asset(
                            Assets.images.visa.path,
                            width: 24,
                            height: 24,
                          ),
                        ),
                        const SizedBox(width: 20),
                        PaymentOption(
                          isSelected: selectedMethod == "mastercard",
                          onTap: () {
                            _showCardSelectionBottomSheet("MasterCard");
                          },
                          child: Image.asset(
                            Assets.images.master.path,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ],
                    ),
                    if (selectedCard != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        "البطاقة المختارة: ${selectedCard!['cardNumber'].substring(selectedCard!['cardNumber'].length - 4)}",
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 16,
                          color: AppThemes.greenColor.color,
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "ملخص الطلب",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: "Tajawal",
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: AppThemes.lightLightGrey.color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: BlocBuilder<OrderCubit, OrderState>(
                              builder: (context, state) {
                                return ElevatedButton(
                                  onPressed: () {
                                    if (selectedDate == null || selectedTime == null || selectedAddressId == null) {
                                      showCustomMessageDialog(context, 'يرجى اختيار التاريخ، الوقت، والعنوان', );
                                      return;
                                    }
                                    if (selectedMethod != "cash" && selectedCard == null) {
                                      showCustomMessageDialog(context, 'يرجى اختيار بطاقة دفع', );
                                      return;
                                    }
                                    orderCubit.createOrder(
                                      addressId: selectedAddressId!,
                                      date: selectedDate!,
                                      time: selectedTime!,
                                      payType: selectedMethod,
                                      notes: notesController.text,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppThemes.greenColor.color,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(
                                        color: AppThemes.greenColor.color,
                                        width: 2,
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: state is OrderLoading
                                      ? CircularProgressIndicator(
                                    color: AppThemes.whiteColor.color,
                                  )
                                      : Text(
                                    "إنهاء الطلب",
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: AppThemes.whiteColor.color,
                                      fontFamily: "Tajawal",
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "الخصم",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: "Tajawal",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: AppThemes.greenColor.color,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "-${discount.toStringAsFixed(2)} ر.س",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: "Tajawal",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: AppThemes.greenColor.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  "المجموع",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: "Tajawal",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: AppThemes.greenColor.color,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "${total.toStringAsFixed(2)} ر.س",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: "Tajawal",
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                    color: AppThemes.greenColor.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}