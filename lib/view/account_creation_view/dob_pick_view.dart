import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/app_validation.dart';
import 'package:chat_with_bloc/view_model/dob_bloc/dob_bloc.dart';
import 'package:chat_with_bloc/view_model/dob_bloc/dob_state.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import '../../view_model/dob_bloc/dob_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DobPickView extends StatefulWidget {
  const DobPickView({super.key});

  @override
  State<DobPickView> createState() => _DobPickViewState();
}

class _DobPickViewState extends State<DobPickView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: BlocBuilder<DobBloc, DobState>(builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const AppHeight(height: 120),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(AppLocalizations.of(context)!.profiledetails,
                          style: AppTextStyle.font25
                              .copyWith(color: AppColors.blackColor))),
                  const AppHeight(height: 50),
                  GestureDetector(
                    onTap: () => context
                        .read<DobBloc>()
                        .add(ImagePickerEvent(context: context)),
                    child: SizedBox(
                      height: 130,
                      width: 130,
                      child: Stack(alignment: Alignment.center, children: [
                        Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                              color: AppColors.borderGreyColor,
                              border:
                                  Border.all(color: AppColors.borderGreyColor),
                              borderRadius: BorderRadius.circular(30)),
                          child: state.image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.file(
                                    state.image!,
                                    fit: BoxFit.cover,
                                  ))
                              : Icon(Icons.add, color: AppColors.blackColor),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.whiteColor),
                            padding: const EdgeInsets.all(3),
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.redColor),
                              padding: const EdgeInsets.all(10),
                              child: SvgPicture.asset(AppAssets.cameraIcon),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                  if (state.imgString.isNotEmpty)
                    Text(
                      state.imgString,
                      style: AppTextStyle.font16
                          .copyWith(color: AppColors.redColor, fontSize: 12),
                    ),
                  const AppHeight(height: 25),
                  CustomTextField(
                      hintText: AppLocalizations.of(context)!.enterYourName,
                      labelText: AppLocalizations.of(context)!.firsyName,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      textEditingController: _nameController,
                      validator: AppValidation.nameValidation),
                  const AppHeight(height: 20),
                  CustomNewButton(
                    btnName: state.dob == null
                        ? AppLocalizations.of(context)!.choosebirthdaydate
                        : DateFormat("dd MMM yyyy").format(state.dob!),
                    btnColor: AppColors.redColor.withOpacity(0.1),
                    isRow: true,
                    onTap: () {
                      context
                          .read<DobBloc>()
                          .add(DatePickerEvent(context: context));
                    },
                  ),
                  if (state.dateString.isNotEmpty)
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          state.dateString,
                          style: AppTextStyle.font16.copyWith(
                              color: AppColors.redColor, fontSize: 12),
                        )),
                  const AppHeight(height: 30),
                  CustomNewButton(
                      btnName: AppLocalizations.of(context)!.next,
                      onTap: () {
                        context.read<DobBloc>().add(OnNextEvent(
                            context: context,
                            formKey: _formKey,
                            nameController: _nameController));
                      }),
                  const AppHeight(height: 30)
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
