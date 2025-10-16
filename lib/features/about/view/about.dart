import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:html/parser.dart';
import 'package:skydive/core/routes/app_routes_fun.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../core/utils/app_theme.dart';
import '../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../../../gen/assets.gen.dart';
import '../cubit/about_cubit.dart';
import '../cubit/about_state.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AboutCubit>().fetchAbout();
    });
    return Scaffold(
      appBar: CustomAppBar(
        title: "عن التطبيق",
        onBackPressed: () {
          pushBack();
        },
      ),
      body: BlocBuilder<AboutCubit, AboutState>(
        builder: (context, state) {
          if (state is AboutLoading) {
            return Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color));
          } else if (state is AboutSuccess) {
            // تحليل النص وإزالة HTML tags
            final aboutText = parse(state.response.data.about).body?.text ?? state.response.data.about;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.images.logo.path,
                      width: 160,
                      height: 160,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      aboutText,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Tajawal',
                        color: AppThemes.blackColor.color,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is AboutError) {
            return Center(
              child: Text(
                state.message,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Tajawal',
                  color: Colors.red,
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
