import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart'; // إضافة المكتبة
import 'package:skydive/features/intro/register/cubit/register_state.dart';
import '../../shared_repo/auth_repository.dart';
import '../model/register_model.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthRepository authRepository;
  final Logger _logger = Logger();

  RegisterCubit(this.authRepository) : super(RegisterInitial());

  Future<void> checkLocationPermission() async {
    // الكود الحالي بدون تغيير
    try {
      _logger.d("Checking location permission status...");
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _logger.w("Location services are disabled");
        emit(LocationError("خدمات الموقع غير مفعلة. يرجى تفعيل خدمات الموقع من إعدادات الجهاز."));
        return;
      }

      var status = await Permission.location.status;
      _logger.d("Current permission status: $status");

      if (status.isGranted) {
        _logger.d("Location permission already granted");
        await _getCurrentLocation();
      } else if (status.isDenied || status.isLimited) {
        _logger.d("Requesting location permission...");
        status = await Permission.location.request();
        _logger.d("Permission request result: $status");
        if (status.isGranted) {
          await _getCurrentLocation();
        } else if (status.isDenied || status.isLimited) {
          _logger.w("Location permission denied");
          emit(LocationPermissionDenied());
        } else if (status.isPermanentlyDenied) {
          _logger.w("Location permission permanently denied");
          emit(LocationPermissionPermanentlyDenied());
        }
      } else if (status.isPermanentlyDenied) {
        _logger.w("Location permission permanently denied (status checked)");
        emit(LocationPermissionPermanentlyDenied());
      }
    } catch (e) {
      _logger.e("Error checking location permission: $e");
      emit(LocationError("خطأ في طلب إذن الموقع: $e"));
    }
  }

  Future<void> _getCurrentLocation() async {
    // الكود الحالي بدون تغيير
    try {
      emit(LocationLoading());
      _logger.d("Attempting to get current location...");
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      ).timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception("Timed out while fetching location");
      });
      _logger.d("Current location: lat=${position.latitude}, lng=${position.longitude}");
      emit(LocationPermissionGranted(position.latitude, position.longitude));
    } catch (e) {
      _logger.e("Error getting current location: $e");
      emit(LocationError("فشل جلب الموقع الحالي: $e"));
    }
  }

  Future<void> setDefaultLocation() async {
    // الكود الحالي بدون تغيير
    _logger.d("Setting default location (Riyadh)");
    emit(LocationPermissionGranted(24.7136, 46.6753)); // Riyadh coordinates
  }

  Future<void> registerWithLocation({
    required String fullname,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String city,
    double? latitude,
    double? longitude,
    required String countryCode, // إضافة رمز الدولة كمعامل
  }) async {
    emit(RegisterLoading());
    try {
      // فصل رمز الدولة عن رقم الهاتف
      String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), ''); // إزالة أي أحرف غير أرقام
      String apiPhone = cleanPhone.startsWith('0') ? cleanPhone.substring(1) : cleanPhone;
      _logger.d("Formatted phone number to API: $apiPhone, countryCode: $countryCode");

      // تحقق من طول رقم الهاتف
      if (apiPhone.length < 9) {
        _logger.w("Invalid phone length: $apiPhone (length: ${apiPhone.length})");
        emit(RegisterError("رقم الجوال غير صحيح، يجب أن يكون 9 أرقام على الأقل"));
        return;
      }

      // حفظ رمز الدولة في SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('country_code', countryCode);
      _logger.d("Country code $countryCode saved to SharedPreferences");

      // إذا لم يكن الموقع متاحًا، جلب الموقع
      if (latitude == null || longitude == null) {
        _logger.d("Location not available, fetching location...");
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          _logger.w("Location services are disabled");
          emit(LocationError("خدمات الموقع غير مفعلة. يرجى تفعيل خدمات الموقع."));
          return;
        }

        var status = await Permission.location.status;
        if (!status.isGranted) {
          status = await Permission.location.request();
          if (!status.isGranted) {
            _logger.w("Location permission not granted");
            emit(LocationError("يرجى السماح بإذن الموقع لإتمام التسجيل."));
            return;
          }
        }

        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(const Duration(seconds: 10), onTimeout: () {
          throw Exception("Timed out while fetching location");
        });
        latitude = position.latitude;
        longitude = position.longitude;
        _logger.d("Location fetched: lat=$latitude, lng=$longitude");
      }

      // إرسال طلب التسجيل إلى الـ API
      _logger.d('Sending register request: fullname=$fullname, phone=$apiPhone, lat=$latitude, lng=$longitude');
      final response = await authRepository.register(
        fullname: fullname,
        phone: apiPhone, // إرسال رقم الهاتف بدون رمز الدولة
        password: password,
        passwordConfirmation: passwordConfirmation,
        city: city,
        latitude: latitude,
        longitude: longitude,
      );

      _logger.d("API response: status=${response.statusCode}, data=${response.data}");

      if (response.success) {
        final responseData = response.data as Map<String, dynamic>;
        _logger.d('Register response data: $responseData');

        final registerModel = RegisterModel.fromJson(responseData);
        if (registerModel.status == 'success') {
          emit(RegisterSuccess(
            registerModel.message ?? 'تم التسجيل بنجاح',
            registerModel.devMessage ?? 0,
          ));
        } else {
          emit(RegisterError(registerModel.message ?? 'حدث خطأ أثناء التسجيل'));
        }
      } else {
        final responseData = response.data as Map<String, dynamic>?;
        final errorMessage = responseData?['message']?.toString() ?? 'فشل الاتصال بالسيرفر';
        _logger.e("API error: $errorMessage, fullResponse=${response.data}");
        emit(RegisterError(errorMessage));
      }
    } catch (e) {
      _logger.e('Register error: $e');
      emit(RegisterError('خطأ: ${e.toString()}'));
    }
  }

  // ميثود لاسترجاع رمز الدولة من SharedPreferences
  Future<String?> getCountryCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('country_code');
  }
}