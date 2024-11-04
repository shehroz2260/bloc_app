import 'package:chat_with_bloc/src/app_colors.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:chat_with_bloc/src/app_text_style.dart';
import 'package:chat_with_bloc/src/width_hieght.dart';
import 'package:chat_with_bloc/view_model/gender_bloc/gender_bloc.dart';
import 'package:chat_with_bloc/view_model/gender_bloc/gender_event.dart';
import 'package:chat_with_bloc/view_model/gender_bloc/gender_state.dart';
import 'package:chat_with_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenderView extends StatefulWidget {
  final bool isUpdate;
  const GenderView({super.key, this.isUpdate = false});

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  @override
  void initState() {
   if(widget.isUpdate){
    context.read<GenderBloc>().add(OninitGender(context: context));
   }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: BlocBuilder<GenderBloc, GenderState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeight(height: 60),
                const CustomBackButton(),
                 const AppHeight(height: 30),
                 Text(AppStrings.iAmA,style: AppTextStyle.font30.copyWith(color: AppColors.blackColor)),
                 const AppHeight(height: 80),
                GestureDetector(
                  onTap: () {
                     context.read<GenderBloc>().add(PickGender(gender: 1));
                  },
                  child: Container(
                     width: double.infinity,
                     decoration: BoxDecoration(
                    color: state.gender == 1? AppColors.redColor: null,
                      borderRadius: BorderRadius.circular(15),
                      border:state.gender != 1? Border.all(
                     color: AppColors.borderGreyColor,
                   ) : null
                   ),
                         padding:  const EdgeInsets.symmetric(vertical: 16,horizontal: 20),
                  
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text("Male",style: AppTextStyle.font16.copyWith(fontWeight: FontWeight.bold,color: state.gender == 1? AppColors.whiteColor:  AppColors.redColor)),
                  if(state.gender == 1)
                  Icon(Icons.check,color: AppColors.whiteColor)
                     ],
                  ),
                  ),
                ),
                const AppHeight(height: 30),
                GestureDetector(
                  onTap: () {
                     context.read<GenderBloc>().add(PickGender(gender: 2));
                  },
                  child: Container(
                     width: double.infinity,
                     decoration: BoxDecoration(
                    color: state.gender == 2? AppColors.redColor: null,
                      borderRadius: BorderRadius.circular(15),
                      border:state.gender != 2? Border.all(
                     color: AppColors.borderGreyColor,
                   ) : null
                   ),
                         padding:  const EdgeInsets.symmetric(vertical: 16,horizontal: 20),
                  
                   child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Text("Female",style: AppTextStyle.font16.copyWith(fontWeight: FontWeight.bold,color: state.gender == 2? AppColors.whiteColor:  AppColors.redColor)),
                  if(state.gender == 2)
                  Icon(Icons.check,color: AppColors.whiteColor)
                     ],
                  ),
                  ),
                ),
                const Expanded(child: SizedBox()),
                 CustomNewButton(btnName:widget.isUpdate?"Update": AppStrings.next,onTap: () {
                   context.read<GenderBloc>().add(OnNextEvent(context: context,isUpdate: widget.isUpdate));
                 },),
                const AppHeight(height: 40)
              ],
            );
          },
        ),
      ),
    );
  }
}
