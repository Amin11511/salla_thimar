import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';
import 'package:skydive/core/widgets/app_btn.dart';

import '../../../core/utils/app_theme.dart';
import '../../../core/widgets/app_field.dart';
import '../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../cubit/sug_and_comp_cubit.dart';
import '../cubit/sug_and_comp_state.dart';
import '../repo/sug_and_comp_service.dart';

class SugAndComp extends StatelessWidget {
  const SugAndComp({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    return BlocProvider(
      create: (context) => SugAndCompCubit(context.read<SugAndCompService>()),
      child: ScaffoldMessenger(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "الشكاوي والإقتراحات",
            onBackPressed: () {
              print('Back pressed from SugAndComp screen');
              Navigator.pop(context);
            },
          ),
          body: BlocConsumer<SugAndCompCubit, SugAndCompState>(
            listener: (context, state) {
              print('SugAndCompCubit State: $state');
              if (state is SugAndCompSuccess) {
                print('SugAndCompSuccess: ${state.message}');
                // showCustomMessageDialog(
                //   context,
                //   state.message,
                //   autoDismissDuration: const Duration(seconds: 2),
                // );
                nameController.clear();
                phoneController.clear();
                titleController.clear();
                contentController.clear();
              } else if (state is SugAndCompError) {
                print('SugAndCompError: ${state.message}');
                // showCustomMessageDialog(
                //   context,
                //   state.message,
                //   autoDismissDuration: const Duration(seconds: 2),
                // );
              }
            },
            builder: (context, state) {
              print('Building UI for state: $state');
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    AppField(hintText: "الإسم", controller: nameController),
                    AppField(hintText: "رقم الموبايل", controller: phoneController),
                    AppField(hintText: "عنوان الشكوى أو الاقتراح", controller: titleController),
                    AppField(hintText: "نص الشكوى أو الاقتراح", controller: contentController),
                    state is SugAndCompLoading
                        ? Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color))
                        : AppBtn(
                      title: "إرسال",
                      backgroundColor: AppThemes.greenColor.color,
                      onPressed: () {
                        if (nameController.text.isNotEmpty &&
                            phoneController.text.isNotEmpty &&
                            titleController.text.isNotEmpty &&
                            contentController.text.isNotEmpty) {
                          context.read<SugAndCompCubit>().sendSuggestionOrComplaint(
                            fullname: nameController.text,
                            phone: phoneController.text,
                            title: titleController.text,
                            content: contentController.text,
                          );
                        } else {
                          // showCustomMessageDialog(
                          //   context,
                          //   "يرجى ملء جميع الحقول",
                          //   autoDismissDuration: const Duration(seconds: 2),
                          // );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}