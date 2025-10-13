import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import 'extensions.dart';

class AppThemes {
  static const mainColor = '#1B184B';
  static const lightText = '#9E968F';
  static const scaffoldBackgroundColor = '#FFFFFF';
  static const lightColor = '#FFFFFF';
  static const mainBorder = '#E6E7E9';
  static const blackColor = '#060A1E';
  static const rateColor = '#F4BD5B';
  static const secondaryColor = '#9B9DA5';
  static const whiteColor = '#FFFFFF';
  static const errorColor = '#F43F3F';
  static const greenColor = '#4C8613';
  static const lightBlue = '#E1F7FF';
  static const lightPink = '#FAEEE2';
  static const darkPink = '#FFE5DE';
  static const greyColor = '#707070';
  static const lightGrey = '#B1B1B1';
  static const lightLightGrey = '#F3F3F3';
  static const cartGrey = '#E8EFE0';
  static const lightGreen = '#6AA431';
  static const lightRed = '#FFE3E3';
  static const semiLightRed = '#F3F8EE';

  static ThemeData get lightTheme => ThemeData(
    indicatorColor: rateColor.color,
    primaryColor: mainColor.color,
    scaffoldBackgroundColor: scaffoldBackgroundColor.color,
    textTheme: arabicTextTheme,
    hoverColor: lightColor.color,
    fontFamily: FontFamily.tajawal,
    hintColor: lightText.color,
    primaryColorLight: Colors.white,
    primaryColorDark: blackColor.color,
    disabledColor: lightText.color,
    // secondaryHeaderColor: secondaryHeaderColor.color,
    // canvasColor: canvasColor.color,
    // cardColor: cardColor.color,
    // shadowColor: shadowColor.color,
    splashColor: Colors.transparent, // Removes splash effect
    highlightColor: Colors.transparent, // Removes highlight when holding
    dividerColor: mainBorder.color,
    appBarTheme: AppBarTheme(
      backgroundColor: scaffoldBackgroundColor.color,
      elevation: 0,
      centerTitle: false,
      surfaceTintColor: whiteColor.color,
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        fontFamily: FontFamily.tajawal,
        color: blackColor.color,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: scaffoldBackgroundColor.color,
      selectedItemColor: mainColor.color,
      showUnselectedLabels: true,
      showSelectedLabels: true,
      // selectedLabelStyle: const TextStyle(color: Colors.white),
      // unselectedLabelStyle: TextStyle(color: "#AED489".color),
      type: BottomNavigationBarType.fixed,
      selectedIconTheme: const IconThemeData(color: Colors.white),
      unselectedIconTheme: IconThemeData(color: "#CBD1DB".color),
      unselectedItemColor: "#CBD1DB".color,
      enableFeedback: true,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return mainColor.color;
        } else {
          return mainBorder.color;
        }
      }),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.circular(1000),
        borderSide: BorderSide.none,
      ),
      iconSize: 24.h,
      backgroundColor: mainColor.color,
      elevation: 1,
    ),
    colorScheme: ColorScheme.light(
      primaryContainer: lightColor.color,
      secondary: secondaryColor.color,
      primary: mainColor.color,
      error: errorColor.color,
    ),
    timePickerTheme: TimePickerThemeData(
      elevation: 0,
      dialHandColor: mainColor.color,
      dialTextColor: Colors.black,
      backgroundColor: Colors.white,
      hourMinuteColor: scaffoldBackgroundColor.color,
      dayPeriodTextColor: Colors.black,
      entryModeIconColor: Colors.transparent,
      dialBackgroundColor: scaffoldBackgroundColor.color,
      hourMinuteTextColor: Colors.black,
      dayPeriodBorderSide: BorderSide(color: mainColor.color),
    ),
    dividerTheme: DividerThemeData(color: mainBorder.color),
    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: const TextStyle(
        fontFamily: FontFamily.tajawal,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      inputDecorationTheme: InputDecorationTheme(
        suffixIconColor: mainColor.color,
        fillColor: scaffoldBackgroundColor.color,
        filled: true,
        contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: lightText.color),
        ),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: TextStyle(
        fontSize: 14,
        fontFamily: FontFamily.tajawal,
        color: lightText.color,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: TextStyle(
        fontSize: 12,
        fontFamily: FontFamily.tajawal,
        color: lightText.color,
        fontWeight: FontWeight.w400,
      ),
      fillColor: scaffoldBackgroundColor.color,
      filled: true,
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor.color),
        borderRadius: BorderRadius.circular(14.r),
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: mainBorder.color),
        borderRadius: BorderRadius.circular(14.r),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: mainBorder.color),
        borderRadius: BorderRadius.circular(14.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: mainColor.color),
        borderRadius: BorderRadius.circular(14.r),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: mainBorder.color),
        borderRadius: BorderRadius.circular(14.r),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      modalBackgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      shape: OutlineInputBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
        borderSide: BorderSide.none,
      ),
    ),
  );

  static TextTheme get arabicTextTheme => const TextTheme(
    labelLarge: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    headlineSmall: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w300,
    ),
  );
}
