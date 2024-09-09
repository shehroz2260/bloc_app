// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MarkerHelper {
  Future<ui.Image> getImageFromPath(String imagePath) async {
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(imagePath);

    Uint8List? markerImageBytes = await markerImageFile.readAsBytes();
    final ui.Codec imageCodec = await ui.instantiateImageCodec(markerImageBytes,
        targetWidth: 120, targetHeight: 120);

    final ui.FrameInfo frameInfo = await imageCodec.getNextFrame();

    final data =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);

    markerImageBytes = data?.buffer.asUint8List();
    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(markerImageBytes!, (ui.Image img) {
      return completer.complete(img);
    });

    return completer.future;
  }

  Future<BitmapDescriptor> getMarkerIcon(String imagePath, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint shadowPaint = Paint()..color = Colors.white;
    const double shadowWidth = 3.0;

    final Paint borderPaint = Paint()..color = Colors.white;
    const double borderWidth = 1.0;

    const double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    ui.Image image = await getImageFromPath(
        imagePath); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  Future<ui.Image> getImageFromAsset(String assetPath) async {
    final ByteData assetByteData = await rootBundle.load(assetPath);
    Uint8List? markerImageBytes = assetByteData.buffer.asUint8List();
    final ui.Codec imageCodec = await ui.instantiateImageCodec(markerImageBytes,
        targetWidth: 120, targetHeight: 120);
    final ui.FrameInfo frameInfo = await imageCodec.getNextFrame();
    final data =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    markerImageBytes = data?.buffer.asUint8List();
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(markerImageBytes!, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<BitmapDescriptor> getAssetMarkerIcon(
      String assetPath, Size size) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // Oval for the image
    Rect oval = Rect.fromLTWH(0, 0, size.width, size.height);

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    ui.Image image =
        await getImageFromAsset(assetPath); // Load the image from the asset
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder.endRecording().toImage(
          size.width.toInt(),
          size.height.toInt(),
        );

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }
}
