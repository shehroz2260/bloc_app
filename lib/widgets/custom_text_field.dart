import 'dart:io';
import 'package:chat_with_bloc/src/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../src/app_colors.dart';
import '../src/app_text_style.dart';
import '../utils/app_funcs.dart';
import '../utils/media_type.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? textEditingController;
  final void Function(String)?  onChange;
  final String? Function(String?)? validator;
  final String hintText;
  final bool isPasswordField;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final bool? enabled;
  final bool isSowPrefixcon;
  final String? labelText;
  const CustomTextField({
    super.key,this.enabled, this.textEditingController, this.onChange, required this.hintText,this.validator, this.isPasswordField =false, this.floatingLabelBehavior, this.labelText,  this.isSowPrefixcon = false
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
bool isVisible = false;
void visiblePassword(){
  setState(() {
    isVisible = !isVisible;
  });
}
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChange,
      enabled: widget.enabled,
      validator: widget.validator,
      controller: widget.textEditingController,
      cursorColor: AppColors.redColor,
      obscureText: isVisible,
      style: AppTextStyle.font16.copyWith(color: AppColors.redColor),
      decoration:  InputDecoration(
        prefixIcon: widget.isSowPrefixcon? Icon(Icons.search,color: AppColors.borderGreyColor): null,
        labelText: widget.labelText,
        floatingLabelBehavior: widget.floatingLabelBehavior,
        suffixIcon:widget.isPasswordField? Padding(padding: const EdgeInsets.all(5),child: GestureDetector(
          onTap: visiblePassword,
          child: Icon(isVisible? Icons.visibility: Icons.visibility_off,color: AppColors.whiteColor,)),):null,
        focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.borderGreyColor,width: 1)
        ),
      hintText: widget.hintText,
      hintStyle: AppTextStyle.font16.copyWith(color: AppColors.borderGreyColor),
        border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.borderGreyColor,width: 1)
        ),
        focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.borderGreyColor,width: 1)
        ),
        enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.borderGreyColor,width: 1)
        ),
        errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.borderGreyColor,width: 1)
        ),
        disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: AppColors.borderGreyColor,width: 1)
        ),
      ),
    );
  }
}

class ChatTextField extends StatelessWidget {
  const ChatTextField({
    super.key,
    required this.controller, this.onChanged,required  this.isRecording,required  this.duration, required this.pickFiles, required this.sendMessage, required this.startOrStopRecording, this.thumbnail, this.pickFile, required this.isLoading, required this.isDisable,
  });

  final TextEditingController controller;
  final void Function(String)? onChanged;
  final bool isRecording;
  final Duration duration;
  final void Function() pickFiles , sendMessage , startOrStopRecording;
  final File? thumbnail;
  final File? pickFile;
  final bool isLoading;
  final bool isDisable;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: TextFormField(
            minLines: 1,
            maxLines: 5,
            onTapOutside: (event) async{
            },
            controller: controller ,
            onChanged: onChanged,
            decoration: InputDecoration(
              suffixIcon: isRecording?  Text(AppFuncs.formatDuration(duration)): GestureDetector(
                onTap: pickFiles,
                child:MediaType.type == MediaType.video && thumbnail != null? ClipRRect(
                  borderRadius: BorderRadius.circular(35),
                  child: Image.file(thumbnail!,height: 35,width: 35,fit: BoxFit.cover,)): MediaType.type == MediaType.image && pickFile != null? ClipRRect(
                    borderRadius: BorderRadius.circular(35),
                    child: Image.file(pickFile!,height: 35,width: 35,fit: BoxFit.cover,)): Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(AppAssets.filesIcon,height: 20,width: 20,),
                    )),
              hintText: "Your message",
              hintStyle: TextStyle(color: AppColors.borderGreyColor),
              enabledBorder: OutlineInputBorder(
                borderSide:  BorderSide(
                   color: AppColors.borderGreyColor,
                   width: 1),
                borderRadius: BorderRadius.circular(18)
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                   color: AppColors.borderGreyColor,
                   width: 1),
                borderRadius: BorderRadius.circular(18)
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                   color: AppColors.borderGreyColor,
                   width: 1),
                borderRadius: BorderRadius.circular(18)
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                   color: AppColors.borderGreyColor,
                   width: 1),
                borderRadius: BorderRadius.circular(18)
              ),
     
            ),
            
          )),
          const SizedBox(width: 10),
         GestureDetector(
          onTap:isLoading? null: isDisable? startOrStopRecording: sendMessage,
           child: Container(
            padding: const EdgeInsets.all(13),
            decoration:  BoxDecoration(
              color:AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppColors.borderGreyColor
              )
            ),
            child:  Icon( isDisable && isRecording?Icons.stop: isDisable && !isRecording? Icons.mic: Icons.send_rounded,color: AppColors.redColor),
           ),
         ),
                
        ],
      ),
    );
  }
}