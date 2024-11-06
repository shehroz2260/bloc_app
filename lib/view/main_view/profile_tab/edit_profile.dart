// import 'package:adaptive_dialog/adaptive_dialog.dart';
// import 'package:chat_with_bloc/model/user_model.dart';
// import 'package:chat_with_bloc/src/app_colors.dart';
// import 'package:chat_with_bloc/src/width_hieght.dart';
// import 'package:chat_with_bloc/utils/app_validation.dart';
// import 'package:chat_with_bloc/widgets/custom_button.dart';
// import 'package:chat_with_bloc/widgets/custom_text_field.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:url_launcher/url_launcher_string.dart';
// import '../../../view_model/user_base_bloc/user_base_bloc.dart';
// import '../../../view_model/user_base_bloc/user_base_event.dart';

// class EditProfile extends StatefulWidget {
//   const EditProfile({super.key});

//   @override
//   State<EditProfile> createState() => _EditProfileState();
// }

// class _EditProfileState extends State<EditProfile> {
// final _emailController = TextEditingController();
// final _passwordController = TextEditingController();
// final _formKey = GlobalKey<FormState>();
// Future<void> updateEmail(String newEmail) async {
//   if(!_formKey.currentState!.validate()) return;
//   User? user = FirebaseAuth.instance.currentUser;

//   if (user != null) {
//     try {
//       AuthCredential credential = EmailAuthProvider.credential(
//         email: user.email!,
//         password: _passwordController.text,
//       );
//     await  user.reauthenticateWithCredential(credential);
//       await user.verifyBeforeUpdateEmail(newEmail);
//       var cUser = context.read<UserBaseBloc>().state.userData;
//        cUser = cUser.copyWith(email: newEmail);
//        await launchUrlString("mailto:");
//      context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: cUser));
// await FirebaseFirestore.instance.collection(UserModel.tableName).doc(user.uid).set(cUser.toMap(),SetOptions(merge: true));
//       showOkAlertDialog(context: context , message: "Your email successfully updated");

//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'requires-recent-login') {
//          showOkAlertDialog(context: context , message: "dddddddddddddddddddd");
//         // print("The user needs to reauthenticate before this operation.");
//         // Handle reauthentication here
//       } else {
//          showOkAlertDialog(context: context , message: e.message);

//         // print("Failed to update email: ${e.message}");
//       }
//     }
//   }
// }

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Scaffold(
//         backgroundColor: AppColors.blackColor,
//         appBar: AppBar(
//           backgroundColor: AppColors.blackColor,
//           foregroundColor: AppColors.whiteColor,
//           title: const Text("Update Email"),
//           centerTitle: true,
//         ),
//         body:  Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const AppHeight(height: 50),
//                Text("Old Password",style: TextStyle(
//                 color: AppColors.whiteColor
//               ),),
//               const AppHeight(height: 5),
//               CustomTextField(
//                 validator: AppValidation.passwordValidation,
//                 hintText: "Password",textEditingController: _passwordController,),
//               const AppHeight(height: 25),
//                Text("New email",style: TextStyle(
//                 color: AppColors.whiteColor
//               ),),
//               const AppHeight(height: 5),
//               CustomTextField(
//                 validator: AppValidation.emailValidation,
//                 hintText: "Email",textEditingController: _emailController,),
//               const AppHeight(height: 25),
//               CustomButton(btnName: "Update",onTap: ()async{
//           await updateEmail(_emailController.text);
//               })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
  final _bioController = TextEditingController();
  final _aboutController = TextEditingController();
  @override
  void initState() {
    final user = context.read<UserBaseBloc>().state.userData;
    _nameController.text = user.firstName;
    _bioController.text = user.bio;
    _aboutController.text = user.about;
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
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
                    Text("Edit Profile",
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
                              "First Name:",
                              style: AppTextStyle.font20
                                  .copyWith(color: AppColors.blackColor),
                            ),
                            const AppHeight(height: 5),
                            CustomTextField(
                              hintText: "Enter first name",
                              textEditingController: _nameController,
                              validator: AppValidation
                                  .nameValidation, //  enabled: state.isEdit,
                            ),
                            const AppHeight(height: 20),
                            Text(
                              "Bio:",
                              style: AppTextStyle.font20
                                  .copyWith(color: AppColors.blackColor),
                            ),
                            const AppHeight(height: 5),
                            CustomTextField(
                              hintText: "EnTer bio",
                              textEditingController: _bioController,
                              validator: AppValidation
                                  .bioValidation, //  enabled: state.isEdit,
                            ),
                            const AppHeight(height: 20),
                            Text(
                              "About:",
                              style: AppTextStyle.font20
                                  .copyWith(color: AppColors.blackColor),
                            ),
                            const AppHeight(height: 5),
                            CustomTextField(
                                hintText: "Enter About",
                                textEditingController: _aboutController,
                                maxLines: 4,
                                validator: AppValidation.aboutValidation),
                            const AppHeight(height: 20),
                            Text(
                              "Age:",
                              style: AppTextStyle.font20
                                  .copyWith(color: AppColors.blackColor),
                            ),
                            const AppHeight(height: 5),
                            CustomNewButton(
                              btnName: state.dob == DateTime(1800)
                                  ? userState.userData.age.toString()
                                  : DateFormat("dd MMM yyyy").format(state.dob),
                              btnColor: AppColors.redColor.withOpacity(0.1),
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
                            Text("Gender",
                                style: AppTextStyle.font20
                                    .copyWith(color: AppColors.blackColor)),
                            Text(
                              "Edit",
                              style: AppTextStyle.font16
                                  .copyWith(color: AppColors.redColor),
                            ),
                          ],
                        ),
                      ),
                      const AppHeight(height: 5),
                      Text(
                        userState.userData.gender == 1 ? "Male" : "Female",
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
                            Text("Interested",
                                style: AppTextStyle.font20
                                    .copyWith(color: AppColors.blackColor)),
                            Text("Edit",
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
                    ],
                  ),
                )),
                const AppHeight(height: 20),
                CustomNewButton(
                    btnName: "Update",
                    onTap: () {
                      if (!_formKey.currentState!.validate()) return;
                      context.read<EditBloc>().add(UpdateUser(
                          context: context,
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
