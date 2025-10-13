import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/routes/app_routes_fun.dart';
import '../../gen/assets.gen.dart';
import '../utils/extensions.dart';
import 'custom_image.dart';

enum MessageType { success, fail, warning }

class FlashHelper {
  static Future<void> showToast(String msg, {int duration = 2, MessageType type = MessageType.fail}) async {
    if (msg.isEmpty) return;
    return showFlash(
      context: navigator.currentContext!,
      builder: (context, controller) {
        return FlashBar(
          controller: controller,
          position: FlashPosition.bottom,
          backgroundColor: Colors.transparent,
          elevation: 0,
          content: Container(
            padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(9.r), color: _getBgColor(type)),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 11.h),
                  decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  child: Center(
                    child: CustomImage(
                      Assets.images.logo.path,
                      fit: BoxFit.scaleDown,
                      height: 19.h,
                      width: 24.h,
                      // color: _getBgColor(type),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    msg,
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    softWrap: true,
                    style: context.regularText.copyWith(fontSize: 16, color: context.primaryColorLight),
                  ),
                ),
                // Container(
                //   height: 24.h,
                //   width: 24.h,
                //   padding: EdgeInsets.all(5.r),
                //   decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                //   child: CustomImage(
                //     _getToastIcon(type),
                //     height: 19.h,
                //     width: 24.h,
                //     color: _getBgColor(type),
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
      duration: const Duration(milliseconds: 3000),
    );
    // if (msg.isNotEmpty) {
    //   ScaffoldMessenger.of(navigator.currentContext!).clearSnackBars();
    //   ScaffoldMessenger.of(navigator.currentContext!).showSnackBar(
    //     SnackBar(
    //       behavior: SnackBarBehavior.floating,
    //       padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
    //       margin: EdgeInsets.fromLTRB(20.w, 0, 20.w, 652.h),
    //       elevation: 0,
    //       backgroundColor: _getBgColor(type),
    //       clipBehavior: Clip.antiAlias,
    //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9.r)),
    //       content: Row(
    //         children: [
    //           Container(
    //             padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 11.h),
    //             decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    //             child: Center(
    //               child: CustomImage(
    //                 Assets.svg.logo,
    //                 fit: BoxFit.scaleDown,
    //                 height: 19.h,
    //                 width: 24.h,
    //                 color: _getBgColor(type),
    //               ),
    //             ),
    //           ),
    //           SizedBox(width: 10.w),
    //           Expanded(
    //             child: Text(msg,
    //                 maxLines: 5,
    //                 overflow: TextOverflow.ellipsis,
    //                 textAlign: TextAlign.start,
    //                 softWrap: true,
    //                 style: TextStyle(fontSize: 16.sp, color: Colors.white)),
    //           ),
    //           Container(
    //             height: 24.h,
    //             width: 24.h,
    //             padding: EdgeInsets.all(5.r),
    //             decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    //             child: CustomImage(
    //               _getToastIcon(type),
    //               // fit: BoxFit.scaleDown,
    //               height: 19.h,
    //               width: 24.h,
    //               color: _getBgColor(type),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
  }

  static Color _getBgColor(MessageType msgType) {
    switch (msgType) {
      case MessageType.success:
        return "#53A653".color;
      case MessageType.warning:
        return "#FFCC00".color;
      default:
        return "#EF233C".color;
    }
  }

  // static String _getToastIcon(MessageType msgType) {
  //   return 'Assets.svg.logo';
  //   // switch (msgType) {
  //   //   case MessageType.success:
  //   //     return Assets.svg.success;

  //   //   case MessageType.warning:
  //   //     return Assets.svg.warning;

  //   //   default:
  //   //     return Assets.svg.error;
  //   // }
  // }
}
