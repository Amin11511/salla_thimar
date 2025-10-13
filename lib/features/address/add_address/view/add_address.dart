import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:logger/logger.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../../core/utils/app_theme.dart';
import '../../../../core/widgets/app_btn.dart';
import '../../../../core/widgets/app_field.dart';
import '../../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../../address/cubit/address_cubit.dart';
import '../cubit/add_address_cubit.dart';
import '../cubit/add_address_state.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({super.key});

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  late GoogleMapController mapController;
  LatLng _center = const LatLng(31.032407, 31.385416);
  Set<Marker> _markers = {};
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _addressType = 'home';
  String _location = "يرجى اختيار موقع على الخريطة";
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermission();
    });
  }

  Future<void> _checkLocationPermission() async {
    try {
      var status = await Permission.location.status;
      _logger.d("Location permission status: $status");
      if (status.isGranted) {
        _logger.d("Location permission already granted");
        await _getCurrentLocation();
      } else if (status.isDenied || status.isRestricted) {
        _logger.d("Requesting location permission");
        var newStatus = await Permission.location.request();
        if (newStatus.isGranted) {
          _logger.d("Location permission granted after request");
          await _getCurrentLocation();
        } else if (newStatus.isPermanentlyDenied) {
          _logger.w("Location permission permanently denied");
          _showPermissionPermanentlyDeniedDialog();
        } else {
          _logger.w("Location permission denied");
          // showCustomMessageDialog(
          //   context,
          //   "يرجى السماح بالوصول إلى الموقع لتحديد العنوان",
          //   autoDismissDuration: const Duration(seconds: 2),
          // );
        }
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
      await _fetchAddressFromCoordinates(_center.latitude, _center.longitude);
      _logger.d("Current location: lat=${_center.latitude}, lng=${_center.longitude}, address=$_location");
    } catch (e) {
      _logger.e("Error getting current location: $e");
      // showCustomMessageDialog(
      //   context,
      //   "فشل جلب الموقع الحالي",
      //   autoDismissDuration: const Duration(seconds: 2),
      // );
    }
  }

  Future<void> _fetchAddressFromCoordinates(double lat, double lng) async {
    try {
      if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
        _logger.w("Invalid coordinates: lat=$lat, lng=$lng");
        setState(() {
          _location = "إحداثيات غير صالحة";
        });
        return;
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        String street = placemark.street ?? "غير معروف";
        String city = placemark.locality ?? "غير معروف";
        setState(() {
          _location = "$street - $city";
        });
      } else {
        _logger.w("No placemarks found for coordinates: lat=$lat, lng=$lng");
        setState(() {
          _location = "لم يتم العثور على عنوان";
        });
      }
    } catch (e, stackTrace) {
      _logger.e("Error fetching address: $e\nStackTrace: $stackTrace");
      setState(() {
        _location = "فشل جلب العنوان، تحقق من الاتصال بالإنترنت";
      });
      // showCustomMessageDialog(
      //   context,
      //   "فشل جلب العنوان، تحقق من الاتصال بالإنترنت",
      //   autoDismissDuration: const Duration(seconds: 2),
      // );
    }
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
    return BlocConsumer<AddressCubit, AddressState>(
      listener: (context, state) {
        if (state is AddressSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          context.read<CurrentAddressesCubit>().fetchAddresses();
          Navigator.pop(context);
        } else if (state is AddressError) {
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
            title: "إضافة عنوان",
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
                      _fetchAddressFromCoordinates(position.latitude, position.longitude);
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
                        hintText: "رقم الجوال",
                        controller: _phoneController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال رقم الجوال';
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
                      state is AddressLoading
                          ? Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color))
                          : AppBtn(
                        title: "إضافة العنوان",
                        onPressed: () {
                          if (_phoneController.text.isEmpty || _descriptionController.text.isEmpty) {
                            // showCustomMessageDialog(
                            //   context,
                            //   "يرجى ملء جميع الحقول",
                            //   autoDismissDuration: const Duration(seconds: 2),
                            // );
                            return;
                          }
                          context.read<AddressCubit>().addAddress(
                            type: _addressType,
                            phone: _phoneController.text,
                            description: _descriptionController.text,
                            location: _location,
                            lat: _center.latitude,
                            lng: _center.longitude,
                            isDefault: 1,
                          );
                        },
                      ),
                      SizedBox(height: 20),
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
    mapController.dispose();
    super.dispose();
  }
}