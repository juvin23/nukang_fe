import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nukang_fe/helper/image_service.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';

class ImageHelper {
  static ImageHelper? profileContoller;
  var isLoading = false;
  var imageURL = '';

  Future<bool> uploadImage(ImageSource imageSource, savepath) async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: imageSource,
        imageQuality: 20,
      );
      if (pickedFile != null) {
        var response = await ImageService.uploadFile(
            pickedFile.path, AppUser.userId, savepath);
        if (response.statusCode == 200) {
          imageCache.clear();
          imageCache.clearLiveImages();
          return true;
        }
        print(response.statusCode);
        return false;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  static ImageHelper getInstance() {
    return profileContoller ??= ImageHelper();
  }
}
