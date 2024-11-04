import 'dart:io';
import 'package:chat_with_bloc/services/firebase_services_storage.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/custom_image_picker.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_event.dart';
import 'edit_state.dart';

class EditBloc extends Bloc<EditEvent, EditState> {
  EditBloc() : super(EditState(imageFile: null,isEdit: false)) {
    on<ImagesPick>(_onPickImage);
    on<OndisPose>(_onDisPose);
    on<OpenEditTextField>(_onEditOpen);
    on<UpdateUser>(_onUpdateUser);
  }

  _onPickImage(ImagesPick event , Emitter<EditState>emit)async{
  final file = await kImagePicker(context: event.context);
  if(file != null){
    emit(state.copyWith(imageFile: file));
  }
  }

  _onDisPose (OndisPose event , Emitter<EditState>emit )async{
    emit(state.copyWith(imageFile: File(""),isEdit: false));
  }
  _onEditOpen(OpenEditTextField event, Emitter<EditState>emit){
    emit(state.copyWith(isEdit: !state.isEdit));
  }
  _onUpdateUser(UpdateUser event, Emitter<EditState>edit)async{
    var user = event.context.read<UserBaseBloc>().state.userData;
    String url = user.profileImage;
  LoadingDialog.showProgress(event.context);
    if((state.imageFile?.path??"").isNotEmpty){
      url = await FirebaseStorageService().uploadImage("profile${user.uid}", state.imageFile?.path??"");
    }
    user = user.copyWith(
      about: event.about,
      bio: event.bio,
      firstName: event.firstName,
      profileImage: url,
    );
    NetworkService.updateUser(user);
    LoadingDialog.hideProgress(event.context);
    Go.back(event.context);
  }
}
