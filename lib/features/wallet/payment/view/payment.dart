import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skydive/core/utils/extensions.dart';
import 'dart:convert';

import '../../../../core/utils/app_theme.dart';
import '../../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../../../../core/widgets/wallet/mastercard_widget.dart';
import '../../../../core/widgets/wallet/visa_card_widget.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  List<Map<String, dynamic>> cards = [];

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cardsJson = prefs.getString('cards');
    if (cardsJson != null) {
      setState(() {
        cards = List<Map<String, dynamic>>.from(jsonDecode(cardsJson));
      });
    }
  }

  Future<void> _saveCard(Map<String, dynamic> card) async {
    final prefs = await SharedPreferences.getInstance();
    cards.add(card);
    await prefs.setString('cards', jsonEncode(cards));
    setState(() {});
  }

  void _showCardTypeBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppThemes.whiteColor.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "اختر نوع البطاقة",
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: "Tajawal",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppThemes.greenColor.color,
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showCardFormBottomSheet('Visa');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.greenColor.color,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "فيزا",
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showCardFormBottomSheet('MasterCard');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.greenColor.color,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "ماستركارد",
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCardFormBottomSheet(String cardType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => CardFormBottomSheet(
        cardType: cardType,
        onSave: (cardData) {
          _saveCard({
            'type': cardType,
            'name': cardData['name'],
            'cardNumber': cardData['cardNumber'],
            'validDate': cardData['validDate'],
            'cvv': cardData['cvv'],
            'isSelected': false,
          });
        },
      ),
    );
  }

  void _deleteCard(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      cards.removeAt(index);
    });
    await prefs.setString('cards', jsonEncode(cards));
  }

  void _toggleCardSelection(int index, bool? value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var i = 0; i < cards.length; i++) {
        cards[i]['isSelected'] = i == index ? value : false;
      }
    });
    await prefs.setString('cards', jsonEncode(cards));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "الدفع",
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: cards.isEmpty
                  ? Center(
                child: Text(
                  "لا توجد بطاقات مضافة",
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontSize: 18,
                    color: AppThemes.greenColor.color,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: card['type'] == 'Visa'
                        ? VisaCardWidget(
                      name: card['name'],
                      cardNumber: card['cardNumber'],
                      validDate: card['validDate'],
                      isSelected: card['isSelected'],
                      onDelete: () => _deleteCard(index),
                      onToggleSelect: (value) => _toggleCardSelection(index, value),
                    )
                        : MasterCardWidget(
                      name: card['name'],
                      cardNumber: card['cardNumber'],
                      validDate: card['validDate'],
                      isSelected: card['isSelected'],
                      onDelete: () => _deleteCard(index),
                      onToggleSelect: (value) => _toggleCardSelection(index, value),
                    ),
                  );
                },
              ),
            ),
            DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(16),
              color: AppThemes.greenColor.color,
              strokeWidth: 2,
              dashPattern: const [6, 3],
              child: ElevatedButton(
                onPressed: _showCardTypeBottomSheet,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemes.whiteColor.color,
                  foregroundColor: AppThemes.greenColor.color,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide.none,
                  ),
                ),
                child: Center(
                  child: Text(
                    "إضافة بطاقة",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Tajawal",
                      color: AppThemes.greenColor.color,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class CardFormBottomSheet extends StatefulWidget {
  final String cardType;
  final Function(Map<String, dynamic>) onSave;

  const CardFormBottomSheet({
    super.key,
    required this.cardType,
    required this.onSave,
  });

  @override
  State<CardFormBottomSheet> createState() => _CardFormBottomSheetState();
}

class _CardFormBottomSheetState extends State<CardFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _validDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _cardNumberController.dispose();
    _validDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            decoration: BoxDecoration(
              color: AppThemes.whiteColor.color,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "إضافة بيانات ${widget.cardType}",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppThemes.greenColor.color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // 🟢 اسم حامل البطاقة
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "اسم حامل البطاقة",
                        floatingLabelStyle: TextStyle(
                          color: AppThemes.greenColor.color,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppThemes.lightGrey.color, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppThemes.greenColor.color, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال اسم حامل البطاقة';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 🟢 رقم البطاقة
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "رقم البطاقة",
                        floatingLabelStyle: TextStyle(
                          color: AppThemes.greenColor.color,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppThemes.lightGrey.color, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(color: AppThemes.greenColor.color, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال رقم البطاقة';
                        }
                        if (!RegExp(r'^\d{16}$').hasMatch(value)) {
                          return 'رقم البطاقة يجب أن يكون 16 رقمًا';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 🟢 تاريخ + CVV
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _validDateController,
                          decoration: InputDecoration(
                            labelText: "MM/YY",
                            floatingLabelStyle: TextStyle(
                              color: AppThemes.greenColor.color,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppThemes.lightGrey.color, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppThemes.greenColor.color, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال تاريخ الصلاحية';
                            }
                            if (!RegExp(r'^(0[1-9]|1[0-2])\/[0-9]{2}$').hasMatch(value)) {
                              return 'صيغة التاريخ غير صحيحة (MM/YY)';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "CVV",
                            floatingLabelStyle: TextStyle(
                              color: AppThemes.greenColor.color,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppThemes.lightGrey.color, width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: AppThemes.greenColor.color, width: 2),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'يرجى إدخال CVV';
                            }
                            if (!RegExp(r'^\d{3,4}$').hasMatch(value)) {
                              return 'CVV يجب أن يكون 3 أو 4 أرقام';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // 🟢 زر الحفظ
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppThemes.greenColor.color,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          widget.onSave({
                            'name': _nameController.text,
                            'cardNumber': _cardNumberController.text,
                            'validDate': _validDateController.text,
                            'cvv': _cvvController.text,
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        "حفظ",
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}