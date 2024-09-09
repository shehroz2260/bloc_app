import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_bloc.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_event.dart';
import 'package:chat_with_bloc/view_model/main_bloc/main_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/custom_navigation_bar.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return  Column(
              children: [
                Expanded(child: state.currentBody),
                CustomNavigationBar(ontap: _onIndexChange,currentIndex: state.currentIndex)
              ],
            );
        },
      ),
    );
  }
  void  _onIndexChange(int index){
     context.read<MainBloc>().add(ChangeIndexEvent(index: index));
  }
}
