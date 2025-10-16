import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../core/services/server_gate.dart';
import '../../../core/utils/app_theme.dart';
import '../../../core/widgets/app_btn.dart';
import '../../../core/widgets/app_field.dart';
import '../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../../../core/widgets/custom_message_dialog.dart';
import '../../../gen/assets.gen.dart';
import '../cubit/contact_cubit.dart';
import '../cubit/contact_state.dart';
import '../repo/contact_service.dart';

class Contact extends StatelessWidget {
  Contact({super.key});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactCubit(ContactService(ServerGate.i))..fetchContactInfo(),
      child: ScaffoldMessenger(
        child: Scaffold(
          appBar: CustomAppBar(
            title: "تواصل معنا",
            onBackPressed: () {
              print('Back pressed from Contact screen');
              Navigator.pop(context);
            },
          ),
          body: BlocConsumer<ContactCubit, ContactState>(
            listener: (context, state) {
              print('ContactCubit State: $state');
              if (state is SendMessageSuccess) {
                print('SendMessageSuccess: ${state.message}');
                showCustomMessageDialog(
                  context,
                  state.message,
                );
                nameController.clear();
                phoneController.clear();
                subjectController.clear();
                messageController.clear();
              } else if (state is SendMessageError) {
                print('SendMessageError: ${state.message}');
                showCustomMessageDialog(
                  context,
                  state.message,
                );
              }
            },
            builder: (context, state) {
              print('Building UI for state: $state');
              final cubit = context.read<ContactCubit>();
              Widget buildContent() {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: double.infinity,
                              child: cubit.contactInfo != null
                                  ? GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                    cubit.contactInfo!.lat,
                                    cubit.contactInfo!.lng,
                                  ),
                                  zoom: 15.0,
                                ),
                                markers: {
                                  Marker(
                                    markerId: const MarkerId('company_location'),
                                    position: LatLng(
                                      cubit.contactInfo!.lat,
                                      cubit.contactInfo!.lng,
                                    ),
                                    infoWindow: InfoWindow(
                                      title: cubit.contactInfo!.location,
                                    ),
                                  ),
                                },
                                myLocationEnabled: false,
                                zoomControlsEnabled: false,
                                mapType: MapType.normal,
                              )
                                  : Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color)),
                            ),
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.25,
                              left: 16,
                              right: 16,
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppThemes.whiteColor.color,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          Assets.images.location.path,
                                          width: 18,
                                          height: 18,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            cubit.contactInfo?.location ?? 'جاري التحميل...',
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              fontFamily: "Tajawal",
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18,
                                              color: AppThemes.greenColor.color,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (cubit.contactInfo?.phone.isNotEmpty ?? false) ...[
                                      const SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Image.asset(
                                            Assets.images.calling.path,
                                            width: 18,
                                            height: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              cubit.contactInfo!.phone,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                fontFamily: "Tajawal",
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18,
                                                color: AppThemes.greenColor.color,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                    if (cubit.contactInfo?.email.isNotEmpty ?? false) ...[
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Image.asset(
                                            Assets.images.message.path,
                                            width: 18,
                                            height: 18,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              cubit.contactInfo!.email,
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                fontFamily: "Tajawal",
                                                fontWeight: FontWeight.normal,
                                                fontSize: 18,
                                                color: AppThemes.greenColor.color,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        Text(
                          "أو يمكنك إرسال رسالة",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Tajawal",
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        AppField(hintText: "الإسم", controller: nameController),
                        const SizedBox(height: 10),
                        AppField(hintText: "رقم الموبايل", controller: phoneController),
                        const SizedBox(height: 10),
                        AppField(hintText: "عنوان الرسالة", controller: subjectController),
                        const SizedBox(height: 10),
                        AppField(hintText: "نص الرسالة", controller: messageController),
                        const SizedBox(height: 10),
                        state is SendMessageLoading
                            ? Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color))
                            : AppBtn(
                          title: "إرسال",
                          backgroundColor: AppThemes.greenColor.color,
                          onPressed: () {
                            if (nameController.text.isNotEmpty &&
                                phoneController.text.isNotEmpty &&
                                subjectController.text.isNotEmpty &&
                                messageController.text.isNotEmpty) {
                              context.read<ContactCubit>().sendMessage(
                                fullname: nameController.text,
                                phone: phoneController.text,
                                title: subjectController.text,
                                content: messageController.text,
                              );
                            } else {
                              showCustomMessageDialog(
                                context,
                                "يرجى ملء جميع الحقول",
                              );
                            }
                          },
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                );
              }

              if (state is ContactLoading) {
                return Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color));
              } else if (state is ContactError) {
                return Center(child: Text(state.message));
              } else {
                return buildContent();
              }
            },
          ),
        ),
      ),
    );
  }
}