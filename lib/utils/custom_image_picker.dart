// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:chat_with_bloc/src/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../src/app_colors.dart';
import 'permission_utils.dart';

enum ActionStyle { normal, destructive, important, importantDestructive }

class CustomDialog extends StatelessWidget {
  final String? title, description, buttonText;
  final Image? image;
  final Function? function;

  const CustomDialog(
      {super.key,
      this.title,
      this.description,
      this.buttonText,
      this.image,
      this.function});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            padding: const EdgeInsets.only(
                top: 100, bottom: 16, left: 16, right: 16),
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(17),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10.0,
                    offset: Offset(0.0, 10.0),
                  )
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title ?? "",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 24.0),
                Text(description ?? "", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 24.0),
                Align(
                  alignment: Alignment.bottomRight,
                  child: MaterialButton(
                    onPressed: () {
                      if (function != null) {
                        function!.call();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    child: Text(buttonText ?? ""),
                  ),
                )
              ],
            )),
        Positioned(
            top: 0,
            left: 16,
            right: 16,
            child: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 50,
              child: ClipOval(
                child: image,
              ),
            ))
      ],
    );
  }
}

// ignore: must_be_immutable
class CameraGalleryBottomSheet extends StatelessWidget {
  Function? cameraClick;
  Function? galleryClick;
  final bool isVideo;
  Function(File? file)? onFileSelected;

  CameraGalleryBottomSheet(
      {super.key, this.cameraClick, this.galleryClick, this.isVideo = false});

  File? file;
  final picker = ImagePicker();

  Future getImage(ImageSource imageSource, BuildContext context) async {
    final pickedFile = isVideo
        ? await picker.pickVideo(source: imageSource)
        : await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      file = File(pickedFile.path);
      // onFileSelected.call(file);
      /*    ImageProperties properties =
          await FlutterNativeImage.getImageProperties(file!.path);
      File compressedFile = await FlutterNativeImage.compressImage(file!.path,
          quality: 100,
          targetWidth: 900,
          targetHeight: (properties.height! * 900 / properties.width!).round());
 */
      Navigator.pop(context, file);
    } else {
      onFileSelected?.call(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 30),
      height: 250,
      child: Column(
        children: <Widget>[
          ListTile(
            onTap: () async {
              //cameraClick.call();
              await getImage(ImageSource.camera, context);
            },
            leading: Icon(Icons.camera, size: 30, color: AppColors.redColor),
            title: Text(
              AppStrings.camera,
              style: TextStyle(fontSize: 20, color: AppColors.blackColor),
            ),
            subtitle: const Text(
              AppStrings.pickImageFromCamera,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          ListTile(
            onTap: () async {
              // galleryClick.call();
              await getImage(ImageSource.gallery, context);
              // Navigator.pop(context);
            },
            leading: Icon(
              Icons.browse_gallery,
              size: 30,
              color: AppColors.redColor,
            ),
            title: Text(
              AppStrings.gallery,
              style: TextStyle(fontSize: 20, color: AppColors.blackColor),
            ),
            subtitle: const Text(
              AppStrings.pickImageFromGallery,
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}

Future<File?> kImagePicker(
    {String title = AppStrings.choosevalue,
    String message = "",
    required BuildContext context}) async {
  if (!await PermissionUtils(
          permission: Permission.camera,
          permissionName: AppStrings.camera,
          context: context)
      .isAllowed) {
    return null;
  }

  if (Platform.isIOS &&
      !await PermissionUtils(
              permission: Permission.photos,
              permissionName: AppStrings.photos,
              context: context)
          .isAllowed) {
    return null;
  }

  if (Platform.isAndroid) {
    return await showModalBottomSheet(
        context: context, builder: (context) => CameraGalleryBottomSheet());
  }
  var input =
      await showModalActionSheet(context: context, title: title, actions: [
    const SheetAction(label: AppStrings.takePhoto, key: "0"),
    const SheetAction(label: AppStrings.chooseFromLibrary, key: "1")
  ]);
  if (input?.isEmpty ?? true) return null;
  return _getImage(
      input == "0" ? ImageSource.camera : ImageSource.gallery, context);
}

Future<File?> _getImage(ImageSource imageSource, BuildContext context,
    [bool isVideo = false]) async {
  File file;
  final picker = ImagePicker();

  final pickedFile = isVideo
      ? await picker.pickVideo(source: imageSource)
      : await picker.pickImage(source: imageSource);

  if (pickedFile != null) {
    file = File(pickedFile.path);
    ImageProperties properties =
        await FlutterNativeImage.getImageProperties(file.path);
    File compressedFile = await FlutterNativeImage.compressImage(file.path,
        quality: 40,
        targetWidth: 900,
        targetHeight: (properties.height! * 900 / properties.width!).round());

    return compressedFile;
  } else {
    return null;
  }
}

Future<File?> kVideoPicker(
    {String title = AppStrings.choosevalue,
    String message = "",
    required BuildContext context}) async {
  if (!await storagePermission(context)) {
    return null;
  }

  if (Platform.isAndroid) {
    return await showModalBottomSheet(
        context: context,
        builder: (context) => CameraGalleryBottomSheet(
              isVideo: true,
            ));
  }
  var input =
      await showModalActionSheet(context: context, title: title, actions: [
    const SheetAction(label: AppStrings.takePhoto, key: "0"),
    const SheetAction(label: AppStrings.chooseFromLibrary, key: "1")
  ]);
  if (input?.isEmpty ?? true) return null;
  return _getImage(
      input == "0" ? ImageSource.camera : ImageSource.gallery, context, true);
}

Future<bool> storagePermission(BuildContext context) async {
  PermissionStatus photo = await Permission.photos.request();
  PermissionStatus storage = await Permission.storage.request();
  PermissionStatus audio = await Permission.audio.request();
  PermissionStatus mic = await Permission.microphone.request();
  PermissionStatus camera = await Permission.camera.request();
  if (mic.isGranted &&
      camera.isGranted &&
      ((photo.isGranted && audio.isGranted) || storage.isGranted)) {
    return true;
  }

  var result = await showOkCancelAlertDialog(
      context: context,
      title: AppStrings.permissionforvideorecording,
      message: AppStrings.pleaseEnablecamera,
      okLabel: AppStrings.openSetting,
      cancelLabel: AppStrings.later);

  if (result == OkCancelResult.ok) {
    await openAppSettings();
    return false;
  }

  return false;
}
