import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../../core/utils/app_theme.dart';
import '../../../../core/widgets/app_btn.dart';
import '../../../../core/widgets/app_field.dart';
import '../../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../../address/cubit/address_cubit.dart';
import '../../address/cubit/address_state.dart';
import '../../address/model/address_model.dart';

class EditAddress extends StatefulWidget {
  final CurrentAddressesModel address;

  const EditAddress({super.key, required this.address});

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  late GoogleMapController mapController;
  late LatLng _center;
  Set<Marker> _markers = {};
  late TextEditingController _phoneController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late String _addressType;
  late bool _isDefault;
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    _center = LatLng(widget.address.lat, widget.address.lng);
    _addressType = widget.address.type;
    _isDefault = widget.address.isDefault;
    _phoneController = TextEditingController(text: widget.address.phone);
    _descriptionController = TextEditingController(text: widget.address.description);
    _locationController = TextEditingController(text: widget.address.location);
    _markers = {
      Marker(
        markerId: const MarkerId('selected_location'),
        position: _center,
      ),
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  Future<void> _checkLocationPermission() async {
    try {
      var status = await Permission.location.status;
      if (status.isGranted) {
        _logger.d("Location permission already granted");
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _center, zoom: 14.0),
          ),
        );
      } else if (status.isDenied || status.isRestricted) {
        _showLocationPermissionDialog();
      } else if (status.isPermanentlyDenied) {
        _logger.w("Location permission permanently denied");
        _showPermissionPermanentlyDeniedDialog();
      }
    } catch (e) {
      _logger.e("Error checking location permission: $e");
      // showCustomMessageDialog(
      //   context,
      //   "خطأ في التحقق من إذن الموقع",
      //   autoDismissDuration: const Duration(seconds: 2),
      // );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _center = LatLng(position.latitude, position.longitude);
        _markers = {
          Marker(
            markerId: const MarkerId('selected_location'),
            position: _center,
          ),
        };
      });
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _center, zoom: 14.0),
        ),
      );
      _logger.d("Current location: lat=${_center.latitude}, lng=${_center.longitude}");
    } catch (e) {
      _logger.e("Error getting current location: $e");
      // showCustomMessageDialog(
      //   context,
      //   "فشل جلب الموقع الحالي",
      //   autoDismissDuration: const Duration(seconds: 2),
      // );
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إذن الموقع"),
        content: const Text("هذا التطبيق يحتاج إلى إذن الموقع لتحديد موقع العنوان. هل تريد السماح؟"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              var status = await Permission.location.request();
              if (status.isGranted) {
                _logger.d("Location permission granted");
                await _getCurrentLocation();
              } else if (status.isDenied) {
                _logger.w("Location permission denied");
                _showPermissionDeniedDialog();
              } else if (status.isPermanentlyDenied) {
                _logger.w("Location permission permanently denied");
                _showPermissionPermanentlyDeniedDialog();
              }
            },
            child: const Text("السماح"),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إذن الموقع مرفوض"),
        content: const Text("هذا التطبيق يحتاج إلى إذن الموقع لتحديد العنوان. هل تريد إعادة المحاولة؟"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _checkLocationPermission();
            },
            child: const Text("إعادة المحاولة"),
          ),
        ],
      ),
    );
  }

  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إذن الموقع مرفوض نهائيًا"),
        content: const Text("تم رفض إذن الموقع بشكل دائم. يرجى تفعيل الإذن من إعدادات الجهاز."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text("فتح الإعدادات"),
          ),
        ],
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentAddressesCubit, CurrentAddressesState>(
      listener: (context, state) {
        if (state is UpdateAddressSuccess) {
          // showCustomMessageDialog(
          //   context,
          //   "تم تعديل العنوان بنجاح",
          //   autoDismissDuration: const Duration(seconds: 2),
          // );
          Navigator.pop(context);
        } else if (state is UpdateAddressError) {
          // showCustomMessageDialog(
          //   context,
          //   state.message,
          //   autoDismissDuration: const Duration(seconds: 2),
          // );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: "تعديل العنوان",
            onBackPressed: () {
              Navigator.pop(context);
            },
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.57,
                  width: double.infinity,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _center,
                      zoom: 14.0,
                    ),
                    myLocationEnabled: true,
                    zoomControlsEnabled: true,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    minMaxZoomPreference: const MinMaxZoomPreference(10.0, 18.0),
                    markers: _markers,
                    onTap: (LatLng position) {
                      setState(() {
                        _center = position;
                        _markers = {
                          Marker(
                            markerId: const MarkerId('selected_location'),
                            position: _center,
                          ),
                        };
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _addressType = 'work';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppThemes.lightGrey.color, width: 2),
                                color: _addressType == 'work' ? AppThemes.greenColor.color : AppThemes.whiteColor.color,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "العمل",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: "Tajawal",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: _addressType == 'work' ? AppThemes.whiteColor.color : AppThemes.greenColor.color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _addressType = 'home';
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppThemes.greenColor.color, width: 2),
                                color: _addressType == 'home' ? AppThemes.greenColor.color : AppThemes.whiteColor.color,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "المنزل",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: "Tajawal",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: _addressType == 'home' ? AppThemes.whiteColor.color : AppThemes.greenColor.color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            "نوع العنوان",
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: AppThemes.lightGrey.color,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      AppField(
                        hintText: "العنوان",
                        controller: _locationController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال العنوان';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      AppField(
                        hintText: "رقم الجوال",
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال رقم الجوال';
                          }
                          if (!RegExp(r'^\+?\d{10,}$').hasMatch(value)) {
                            return 'الرجاء إدخال رقم جوال صالح';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      AppField(
                        hintText: "الوصف",
                        controller: _descriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال وصف العنوان';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: _isDefault,
                            onChanged: (value) {
                              setState(() {
                                _isDefault = value!;
                              });
                            },
                          ),
                          Text(
                            "تعيين كعنوان افتراضي",
                            style: TextStyle(
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppThemes.greenColor.color,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      state is UpdateAddressLoading
                          ? Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color))
                          : AppBtn(
                        title: "حفظ التعديلات",
                        backgroundColor: AppThemes.greenColor.color,
                        onPressed: () {
                          if (_phoneController.text.isEmpty ||
                              _descriptionController.text.isEmpty ||
                              _locationController.text.isEmpty) {
                            // showCustomMessageDialog(
                            //   context,
                            //   "يرجى ملء جميع الحقول",
                            //   autoDismissDuration: const Duration(seconds: 2),
                            // );
                            return;
                          }
                          context.read<CurrentAddressesCubit>().updateAddress(
                            id: widget.address.id,
                            type: _addressType,
                            phone: _phoneController.text,
                            description: _descriptionController.text,
                            location: _locationController.text,
                            lat: _center.latitude,
                            lng: _center.longitude,
                            isDefault: _isDefault,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    mapController.dispose();
    super.dispose();
  }
}