import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/utils/app_validation.dart';
import 'package:chat_with_bloc/view/account_creation_view/gender_view.dart';
import 'package:chat_with_bloc/view_model/edit_bloc/edit_bloc.dart';
import 'package:chat_with_bloc/view_model/edit_bloc/edit_event.dart';
import 'package:chat_with_bloc/view_model/edit_bloc/edit_state.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../view_model/location_permission_bloc/location_bloc.dart';
import '../../../view_model/location_permission_bloc/location_event.dart';
import '../../account_creation_view/preference_view.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  EditBloc ancestorContext = EditBloc();
  @override
  void didChangeDependencies() {
    ancestorContext = MyInheritedWidget(
            bloc: context.read<EditBloc>(), child: const SizedBox())
        .bloc;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    ancestorContext.add(OndisPose());
    super.dispose();
  }

  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _aboutController = TextEditingController();
  @override
  void initState() {
    final user = context.read<UserBaseBloc>().state.userData;
    _nameController.text = user.firstName;
    _bioController.text = user.bio;
    _lastNameController.text = user.lastName;
    _aboutController.text = user.about;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: theme.bgColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: BlocBuilder<UserBaseBloc, UserBaseState>(
              builder: (context, userState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeight(height: 60),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const CustomBackButton(),
                    Text(AppLocalizations.of(context)!.editProfile,
                        style: AppTextStyle.font25
                            .copyWith(color: AppColors.blackColor)),
                    const SizedBox(width: 50),
                  ],
                ),
                const AppHeight(height: 30),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocBuilder<EditBloc, EditState>(
                          builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<EditBloc>()
                                      .add(ImagesPick(context: context));
                                },
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: AppColors.redColor,
                                              width: 3)),
                                      child: (state.imageFile?.path ?? "")
                                              .isEmpty
                                          ? AppCacheImage(
                                              imageUrl: context
                                                  .read<UserBaseBloc>()
                                                  .state
                                                  .userData
                                                  .profileImage,
                                              round: 150,
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(150),
                                              child: Image.file(
                                                  state.imageFile!,
                                                  fit: BoxFit.cover)),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteColor,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 3,
                                              color: AppColors.redColor)),
                                      padding: const EdgeInsets.all(8),
                                      child: Icon(Icons.edit,
                                          color: AppColors.redColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const AppHeight(height: 30),
                            Text(
                              AppLocalizations.of(context)!.firstName,
                              style: AppTextStyle.font20
                                  .copyWith(color: theme.textColor),
                            ),
                            const AppHeight(height: 5),
                            CustomTextField(
                              hintText:
                                  AppLocalizations.of(context)!.enterFirstName,
                              textEditingController: _nameController,
                              validator: (val) =>
                                  AppValidation.nameValidation(val, context),
                            ),
                            const AppHeight(height: 20),
                            CustomTextField(
                              hintText: AppLocalizations.of(context)!
                                  .enterYourLastName,
                              textEditingController: _lastNameController,
                              validator: (val) =>
                                  AppValidation.nameValidation(val, context),
                            ),
                            const AppHeight(height: 20),
                            Text(
                              AppLocalizations.of(context)!.bios,
                              style: AppTextStyle.font20
                                  .copyWith(color: theme.textColor),
                            ),
                            const AppHeight(height: 5),
                            CustomTextField(
                              hintText: AppLocalizations.of(context)!.enTerBio,
                              textEditingController: _bioController,
                              validator: (val) =>
                                  AppValidation.bioValidation(val, context),
                            ),
                            const AppHeight(height: 20),
                            Text(
                              AppLocalizations.of(context)!.aboutWithColon,
                              style: AppTextStyle.font20
                                  .copyWith(color: theme.textColor),
                            ),
                            const AppHeight(height: 5),
                            CustomTextField(
                                hintText:
                                    AppLocalizations.of(context)!.enterAbout,
                                textEditingController: _aboutController,
                                maxLines: 4,
                                validator: (val) =>
                                    AppValidation.aboutValidation(
                                        val, context)),
                            const AppHeight(height: 20),
                            Text(
                              AppLocalizations.of(context)!.ageWithColon,
                              style: AppTextStyle.font20
                                  .copyWith(color: theme.textColor),
                            ),
                            const AppHeight(height: 5),
                            CustomNewButton(
                              btnName: state.dob == DateTime(1800)
                                  ? userState.userData.age.toString()
                                  : DateFormat("dd MMM yyyy").format(state.dob),
                              btnColor: AppColors.redColor
                                  .withAlpha((0.1 * 255).toInt()),
                              isRow: true,
                              onTap: () {
                                context
                                    .read<EditBloc>()
                                    .add(OnPickDateTime(context: context));
                              },
                            ),
                            const AppHeight(height: 20)
                          ],
                        );
                      }),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Go.to(context, const GenderView(isUpdate: true));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.gender,
                                style: AppTextStyle.font20
                                    .copyWith(color: theme.textColor)),
                            Text(
                              AppLocalizations.of(context)!.edit,
                              style: AppTextStyle.font16
                                  .copyWith(color: AppColors.redColor),
                            ),
                          ],
                        ),
                      ),
                      const AppHeight(height: 5),
                      Text(
                        userState.userData.gender == 1
                            ? AppLocalizations.of(context)!.male
                            : AppLocalizations.of(context)!.female,
                        style: AppTextStyle.font20
                            .copyWith(color: AppColors.redColor),
                      ),
                      Container(
                        width: double.infinity,
                        height: 2,
                        color: AppColors.borderGreyColor,
                      ),
                      const AppHeight(height: 20),
                      GestureDetector(
                        onTap: () {
                          Go.to(context, const PreferenceView(isUpdate: true));
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppLocalizations.of(context)!.interested,
                                style: AppTextStyle.font20
                                    .copyWith(color: theme.textColor)),
                            Text(AppLocalizations.of(context)!.edit,
                                style: AppTextStyle.font16
                                    .copyWith(color: AppColors.redColor)),
                          ],
                        ),
                      ),
                      const AppHeight(height: 20),
                      GridView.builder(
                          shrinkWrap: true,
                          hitTestBehavior: HitTestBehavior.opaque,
                          padding: EdgeInsets.zero,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 3.3),
                          itemCount: userState.userData.myInstrest.length,
                          itemBuilder: (context, index) {
                            final interest =
                                userState.userData.myInstrest[index];
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                  color: AppColors.redColor,
                                  borderRadius: BorderRadius.circular(15),
                                  border:
                                      Border.all(color: AppColors.redColor)),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(interestList[interest].icon,
                                      colorFilter: ColorFilter.mode(
                                          AppColors.whiteColor,
                                          BlendMode.srcIn)),
                                  const AppWidth(width: 10),
                                  Text(interestList[interest].name,
                                      style: AppTextStyle.font16.copyWith(
                                          color: AppColors.whiteColor))
                                ],
                              ),
                            );
                          }),
                      const AppHeight(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Show Location Publically",
                                style: AppTextStyle.font16
                                    .copyWith(color: AppColors.blackColor)),
                            BlocBuilder<UserBaseBloc, UserBaseState>(
                                builder: (context, state) {
                              return Switch(
                                  value: state.userData.isShowLocation,
                                  onChanged: (val) {
                                    context.read<LocationBloc>().add(
                                        OnPublically(
                                            isOn: val, context: context));
                                  });
                            }),
                          ]),
                      const AppHeight(height: 20),
                    ],
                  ),
                )),
                const AppHeight(height: 20),
                CustomNewButton(
                    btnName: AppLocalizations.of(context)!.update,
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;
                      context.read<EditBloc>().add(UpdateUser(
                          context: context,
                          lastName: _lastNameController.text,
                          firstName: _nameController.text,
                          bio: _bioController.text,
                          about: _aboutController.text));
                    }),
                const AppHeight(height: 20)
              ],
            );
          }),
        ),
      ),
    );
  }
}

class MyInheritedWidget extends InheritedWidget {
  final EditBloc bloc;

  const MyInheritedWidget({
    super.key,
    required this.bloc,
    required super.child,
  });

  // Access the BLoC from the widget tree.
  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }

  @override
  bool updateShouldNotify(covariant MyInheritedWidget oldWidget) {
    // Notify when the BLoC changes (not needed here because BLoC is the same).
    return false;
  }
}
