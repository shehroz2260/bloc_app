import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/app_validation.dart';
import 'package:chat_with_bloc/view_model/bio_bloc/bio_bloc.dart';
import 'package:chat_with_bloc/view_model/bio_bloc/bio_event.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BioView extends StatefulWidget {
  const BioView({super.key});

  @override
  State<BioView> createState() => _BioViewState();
}

class _BioViewState extends State<BioView> {
  final _bioController = TextEditingController();
  final _aboutController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.whiteColor,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeight(height: 60),
              const CustomBackButton(),
              const AppHeight(height: 30),
              Text(AppStrings.bio,
                  style: AppTextStyle.font20.copyWith(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.bold)),
              const AppHeight(height: 10),
              CustomTextField(
                hintText: AppStrings.enterbio,
                textEditingController: _bioController,
                validator: AppValidation.bioValidation,
              ),
              const AppHeight(height: 30),
              Text(AppStrings.aboutyourself,
                  style: AppTextStyle.font20.copyWith(
                      color: AppColors.blackColor,
                      fontWeight: FontWeight.bold)),
              const AppHeight(height: 10),
              CustomTextField(
                hintText: AppStrings.enteraboutyourself,
                maxLines: 7,
                textEditingController: _aboutController,
                validator: AppValidation.aboutValidation,
              ),
              const Spacer(),
              CustomNewButton(
                  btnName: AppStrings.continues,
                  onTap: () {
                    if (!_formKey.currentState!.validate()) return;
                    context.read<BioBloc>().add(OnContinue(
                        bioController: _bioController,
                        aboutController: _aboutController,
                        context: context));
                  }),
              const AppHeight(height: 40)
            ],
          ),
        ),
      ),
    );
  }
}
