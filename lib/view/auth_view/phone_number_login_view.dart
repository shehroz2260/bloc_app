import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/phone_number_bloc/phone_number_bloc.dart';
import 'package:chat_with_bloc/view_model/phone_number_bloc/phone_number_event.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhoneNumberLoginView extends StatefulWidget {
  const PhoneNumberLoginView({super.key});

  @override
  State<PhoneNumberLoginView> createState() => _PhoneNumberLoginViewState();
}

class _PhoneNumberLoginViewState extends State<PhoneNumberLoginView> {
final _formKey = GlobalKey<FormState>();
final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppHeight(height: 70),
              const CustomBackButton(),
              const AppHeight(height: 50),
              Text('Phone Number',style: AppTextStyle.font30.copyWith(color: AppColors.blackColor)),
              Text('Please enter your valid phone number. We will send you a 6-digit code to verify your account. ',style: AppTextStyle.font16.copyWith(color: AppColors.blackColor)),
            const AppHeight(height: 30),
             CustomTextField(hintText: "30707000000",
             validator: (p0) {
               if((p0??"").isEmpty){
                return "Phone number is required";
               }
               if((p0??"").length < 10){
                return "Enter valid number";
               }
               return null;
             },
             textEditingController: _controller,
             keyboardType: TextInputType.phone,
            prefixIcon: SizedBox(
              width: 130,
              child: Row(
                children: [
                   CountryCodePicker(
                           onChanged: (val)=> context.read<PhoneNumberBloc>().add(OnCountryCodeChange(code: val, context: context)),
                           initialSelection: 'US',
                           showCountryOnly: false,
                           showFlag: true,
                           showOnlyCountryWhenClosed: false,
                           alignLeft: false,
                         ),
                         Container(
                         color: AppColors.borderGreyColor,
                         width: 2,
                         height: 30,
                         )
                ],
              ),
            ),
            ),
            const AppHeight(height: 64),
             CustomNewButton(btnName: "Continue",
             onTap: () {
              if(!_formKey.currentState!.validate())return;
               context.read<PhoneNumberBloc>().add(VerifyPhoneNumber(context: context,controller: _controller));
             },
             )
            ],
          ),
        ),
      ),
    );
  }
}