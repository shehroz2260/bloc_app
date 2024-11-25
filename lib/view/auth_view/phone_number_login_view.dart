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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final theme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: theme.bgColor,
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
              Text(AppLocalizations.of(context)!.phoneNumber,
                  style: AppTextStyle.font30.copyWith(color: theme.textColor)),
              Text(
                  AppLocalizations.of(context)!.pleaseEnterYourValidPhoneNumber,
                  style: AppTextStyle.font16.copyWith(color: theme.textColor)),
              const AppHeight(height: 30),
              CustomTextField(
                hintText: AppLocalizations.of(context)!.phoneHint,
                validator: (p0) {
                  if ((p0 ?? "").isEmpty) {
                    return AppLocalizations.of(context)!.phoneNumberIsRequired;
                  }
                  if ((p0 ?? "").length < 10) {
                    return AppLocalizations.of(context)!.enterValidNumber;
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
                        onChanged: (val) => context.read<PhoneNumberBloc>().add(
                            OnCountryCodeChange(code: val, context: context)),
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
              CustomNewButton(
                btnName: AppLocalizations.of(context)!.continues,
                onTap: () {
                  if (!_formKey.currentState!.validate()) return;
                  context.read<PhoneNumberBloc>().add(VerifyPhoneNumber(
                      context: context, controller: _controller));
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
