import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/services/firebase_services_storage.dart';
import 'package:chat_with_bloc/services/network_service.dart';
import 'package:chat_with_bloc/utils/app_funcs.dart';
import 'package:chat_with_bloc/utils/loading_dialog.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_bloc.dart';
import 'package:chat_with_bloc/view_model/user_base_bloc/user_base_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/user_model.dart';
import '../../utils/custom_image_picker.dart';
import 'gallery_event.dart';
import 'gallery_state.dart';

class GalleryBloc extends Bloc<GalleryEvent, GalleryState> {
  GalleryBloc() : super(GalleryState()) {
    on<SelectImage>(_onImageSelect);
    on<ClearImage>(_onClearImage);
  }

  _onImageSelect(SelectImage event, Emitter<GalleryState> emit) async {
    var file = await kImagePicker(context: event.context);
    if (file == null) {
      return;
    }
    UserModel model = event.context.read<UserBaseBloc>().state.userData;
    if (model.galleryImages.length == 6) {
      showOkAlertDialog(
          context: event.context,
          message: "Permission Only six images are select");
      return;
    }
    LoadingDialog.showProgress(event.context);
    final url = await FirebaseStorageService()
        .uploadImage("gallery/${AppFuncs.generateRandomString(15)}", file.path);

    model.galleryImages.add(url);
    model = model.copyWith(galleryImages: model.galleryImages);
    event.context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: model));
    NetworkService.updateUser(model);
    LoadingDialog.hideProgress(event.context);
  }

  _onClearImage(ClearImage event, Emitter<GalleryState> emit) {
    final user = event.context.read<UserBaseBloc>().state.userData;
    if (user.galleryImages.isNotEmpty) {
      FirebaseStorageService()
          .deleteFile(user.galleryImages[event.index], event.context);
      user.galleryImages.removeAt(event.index);
      event.context.read<UserBaseBloc>().add(UpdateUserEvent(userModel: user));
      NetworkService.updateUser(user);
    }
  }
}
