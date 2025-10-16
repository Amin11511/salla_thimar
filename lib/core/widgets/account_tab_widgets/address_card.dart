import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../features/address/address/cubit/address_cubit.dart';
import '../../../features/address/address/model/address_model.dart';
import '../../routes/routes.dart';
import '../../utils/app_theme.dart';

class AddressCard extends StatelessWidget {
  final CurrentAddressesModel address;
  final BuildContext parentContext;

  const AddressCard({super.key, required this.address, required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppThemes.lightGrey.color, width: 2),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            child: Row(
              children: [
                Text(
                  address.type == 'home' ? 'المنزل' : 'العمل',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppThemes.greenColor.color,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("تأكيد الحذف"),
                        content: const Text("هل أنت متأكد من حذف هذا العنوان؟"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("إلغاء"),
                          ),
                          TextButton(
                            onPressed: () {
                              parentContext.read<CurrentAddressesCubit>().deleteAddress(address.id, address.type);
                              Navigator.pop(context);
                            },
                            child: const Text("حذف"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppThemes.lightRed.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.delete, color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      NamedRoutes.editAddress,
                      arguments: address,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppThemes.lightRed.color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.edit, color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Text(
                  "العنوان: ",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppThemes.lightGrey.color,
                  ),
                ),
                Expanded(
                  child: Text(
                    address.location,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppThemes.greenColor.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Text(
                  "الوصف: ",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppThemes.lightGrey.color,
                  ),
                ),
                Expanded(
                  child: Text(
                    address.description,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppThemes.greenColor.color,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Text(
                  "رقم الجوال: ",
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppThemes.lightGrey.color,
                  ),
                ),
                Text(
                  address.phone,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppThemes.greenColor.color,
                  ),
                ),
              ],
            ),
          ),
          if (address.isDefault)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Text(
                    "الحالة: ",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppThemes.lightGrey.color,
                    ),
                  ),
                  Text(
                    "افتراضي",
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppThemes.greenColor.color,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}