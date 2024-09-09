import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/view/main_view/home_tab/filter_view.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_bloc.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_event.dart';
import 'package:chat_with_bloc/view_model/home_bloc/home_state.dart';
import 'package:flutter/material.dart';
import '../../../src/app_text_style.dart';
import '../../../src/width_hieght.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    context.read<HomeBloc>().add(ONINITEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Column(children: [
          const AppHeight(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 35),
                Text("Home", style: AppTextStyle.font25),
                GestureDetector(
                  onTap: () {
                    Go.to(context, const FilterView());
                  },
                  child: SizedBox(
                    width: 35,
                    child: Icon(
                      Icons.filter_alt_outlined,
                      color: AppColors.whiteColor,
                      size: 35,
                    ),
                  ),
                )
              ],
            ),
          ),
          const AppHeight(height: 20),
          ...List.generate(state.userList.length, (index){
            return Text(state.userList[index].name,style: AppTextStyle.font16,);
          })
        ]);
      },
    );
  }
}
