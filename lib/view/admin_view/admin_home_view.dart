import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/admin_home_bloc/admin_home_bloc.dart';
import 'package:chat_with_bloc/view_model/admin_bloc/admin_home_bloc/admin_home_state.dart';
import 'package:chat_with_bloc/widgets/app_cache_image.dart';
import 'package:chat_with_bloc/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../view_model/admin_bloc/admin_home_bloc/admin_home_event.dart';

class AdminHomeView extends StatefulWidget {
  const AdminHomeView({super.key});

  @override
  State<AdminHomeView> createState() => _AdminHomeViewState();
}

class _AdminHomeViewState extends State<AdminHomeView> {
  @override
  void initState() {
    context.read<AdminHomeBloc>().add(AdminHomeInit());
    super.initState();
  }

  final _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const AppHeight(height: 10),
          CustomTextField(
              onChange: (p0) {
                context.read<AdminHomeBloc>().add(OnChangedTextField(val: p0));
              },
              hintText: "Search here...",
              textEditingController: _textEditingController),
          const AppHeight(height: 10),
          BlocBuilder<AdminHomeBloc, AdminHomeState>(
            builder: (context, state) {
              return Expanded(
                  child: SingleChildScrollView(
                child: Column(
                  children: List.generate(state.userList.length, (index) {
                    return state.userList[index].firstName
                            .toLowerCase()
                            .contains(state.searchText.toLowerCase())
                        ? Container(
                            decoration: BoxDecoration(
                                color: AppColors.borderGreyColor,
                                borderRadius: BorderRadius.circular(20)),
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Row(
                              children: [
                                AppCacheImage(
                                    imageUrl:
                                        state.userList[index].profileImage,
                                    height: 50,
                                    width: 50,
                                    round: 40),
                                const AppWidth(width: 10),
                                Expanded(
                                    child: Text(state.userList[index].firstName,
                                        style: AppTextStyle.font20
                                            .copyWith(color: theme.textColor))),
                                Column(
                                  children: [
                                    const Text("verify"),
                                    Switch(
                                        value: state.isVerify,
                                        onChanged: (val) {
                                          context
                                              .read<AdminHomeBloc>()
                                              .add(OnChangeVerify(val: val));
                                        }),
                                  ],
                                )
                              ],
                            ),
                          )
                        : const SizedBox();
                  }),
                ),
              ));
            },
          )
        ],
      ),
    );
  }
}
