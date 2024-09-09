import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/app_validation.dart';
import 'package:chat_with_bloc/view_model/dob_bloc/dob_bloc.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../view_model/dob_bloc/dob_event.dart';

class DobPickView extends StatefulWidget {
  const DobPickView({super.key});

  @override
  State<DobPickView> createState() => _DobPickViewState();
}

class _DobPickViewState extends State<DobPickView> {
  final _dobController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.blackColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const AppHeight(height: 50),
              Text(AppStrings.dob,style: AppTextStyle.font25),
              const AppHeight(height: 20),
              const Expanded(child: SizedBox()),
               GestureDetector(
                onTap: () {
                  context.read<DobBloc>().add(DatePickerEvent(context: context,textEditingController: _dobController));
                },
                child: CustomTextField(hintText: AppStrings.selectDob,enabled: false,textEditingController: _dobController,validator: AppValidation.dobValidation)),
               const Expanded(child: SizedBox()),
                CustomButton(btnName: AppStrings.next,onTap: () {
                 context.read<DobBloc>().add(OnNextEvent(context: context,formKey: _formKey));
               },),
               const AppHeight(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}