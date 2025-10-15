import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../core/utils/app_theme.dart';
import '../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../cubit/faqs_cubit.dart';
import '../cubit/faqs_state.dart';

class Faqs extends StatelessWidget {
  const Faqs({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FaqsCubit>().fetchFaqs();
    });
    return Scaffold(
      appBar: CustomAppBar(
        title: "الأسئلة المتكررة",
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: BlocBuilder<FaqsCubit, FaqsState>(
        builder: (context, state) {
          if (state is FaqsLoading) {
            return Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color));
          } else if (state is FaqsSuccess) {
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: state.faqs.length,
              itemBuilder: (context, index) {
                final faq = state.faqs[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ExpansionTile(
                    iconColor: AppThemes.greenColor.color,
                    collapsedIconColor: AppThemes.greenColor.color,
                    title: Text(
                      faq.question,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          faq.answer,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is FaqsError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('جاري تحميل البيانات...'));
        },
      ),
    );
  }
}