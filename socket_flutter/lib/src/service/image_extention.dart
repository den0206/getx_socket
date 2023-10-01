import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';

class ImageExtention {
  final ImagePicker _imagePicker = ImagePicker();
  Future<File?> selectImage({required ImageSource imageSource}) async {
    final XFile? _image = await _imagePicker.pickImage(
      source: imageSource,
      imageQuality: 85,
    );

    if (_image != null) {
      return File(_image.path);
    } else {
      return null;
    }
  }

  Future<File?> selectVideo() async {
    final XFile? _video =
        await _imagePicker.pickVideo(source: ImageSource.gallery);
    if (_video == null) return null;
    final compressVideo = await VideoCompress.compressVideo(
      _video.path,
      deleteOrigin: false,
      includeAudio: true,
      quality: VideoQuality.LowQuality,
      frameRate: 24,
    );

    if (compressVideo == null) return null;
    return compressVideo.file;
  }

  Future<File> getThumbnail(File videoFile) async {
    final thumbail = await VideoCompress.getFileThumbnail(
      videoFile.path,
      quality: 50,
    );

    return thumbail;
  }

  Future<bool> downloadImage(String imageUrl) async {
    try {
      // TODO ---- downlod from internet

      // put Image Gallary
      await Gal.putImage(imageUrl);
      return true;
    } catch (e) {
      debugPrint("Fail Download Image: ${e.toString()}");
      return false;
    }
  }
}
