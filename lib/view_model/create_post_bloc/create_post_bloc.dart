import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/model/posts_model.dart';
import 'package:chat_with_bloc/services/firebase_services_storage.dart';
import 'package:chat_with_bloc/src/go_file.dart';
import 'package:chat_with_bloc/utils/app_funcs.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../utils/permission_utils.dart';
import 'create_post_event.dart';
import 'create_post_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  CreatePostBloc() : super(CreatePostState(images: [])) {
    on<PickImages>(_pickImages);
    on<CancelImage>(_cancelImage);
    on<OnPostCreate>(_onCreatePost);
  }

  _pickImages(PickImages event, Emitter<CreatePostState> emit) async {
    final picker = ImagePicker();
    if (!await PermissionUtils(
            permission: Permission.camera,
            permissionName: AppLocalizations.of(event.context)!.camera,
            context: event.context)
        .isAllowed) {
      return;
    }

    if (Platform.isIOS &&
        !await PermissionUtils(
                permission: Permission.photos,
                permissionName: AppLocalizations.of(event.context)!.photos,
                context: event.context)
            .isAllowed) {
      return;
    }

    final files = await picker.pickMultiImage();
    if (files.isNotEmpty) {
      emit(state.copyWith(images: files));
    }
  }

  _cancelImage(CancelImage event, Emitter<CreatePostState> emit) {
    state.images.removeAt(event.index);
    emit(state.copyWith(images: state.images));
  }

  _onCreatePost(OnPostCreate event, Emitter<CreatePostState> emit) async {
    if (event.controller.text.isEmpty && state.images.isEmpty) {
      showOkAlertDialog(
          context: event.context,
          message: "Please Select at least one image or write something",
          title: "Error");
      return;
    }

    try {
      LoadingDialog.showProgress(event.context);
      List<String> images = [];
      var cUser = event.context.read<UserBaseBloc>().state.userData;
      if (state.images.isNotEmpty) {
        for (final e in state.images) {
          final url = await FirebaseStorageService().uploadImage(
              "Post/${cUser.uid}/${AppFuncs.generateRandomString(10)}", e.path);
          images.add(url);
        }
      }
      PostsModel model = PostsModel(
          id: AppFuncs.generateRandomString(15),
          uid: cUser.uid,
          text: event.controller.text,
          avatar: cUser.profileImage,
          userName: "${cUser.firstName} ${cUser.lastName}",
          imageList: images,
          createdAt: DateTime.now());
      await FirebaseFirestore.instance
          .collection(PostsModel.tableName)
          .doc(model.id)
          .set(model.toMap());
      LoadingDialog.hideProgress(event.context);
      Go.back(event.context);
    } on FirebaseException catch (e) {
      LoadingDialog.hideProgress(event.context);
      showOkAlertDialog(
          context: event.context, message: e.message, title: "Error");
    }
  }
}
