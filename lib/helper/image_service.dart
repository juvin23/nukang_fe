import 'package:dio/dio.dart';
import 'package:nukang_fe/environment.dart';
import 'package:nukang_fe/helper/http_helper.dart';
import 'package:nukang_fe/user/appuser/app_user.dart';

class ImageService {
  static String getProfileImage(String? merchantId) {
    print(
        "http://${Environment.apiUrl}/api/v1/images/get-profile-image/$merchantId");
    return "http://${Environment.apiUrl}/api/v1/images/get-profile-image/$merchantId";
  }

  static Future<Response> uploadFile(filePath, userId, savepath) async {
    try {
      FormData formData = FormData.fromMap({
        "image":
            await MultipartFile.fromFile(filePath, filename: AppUser.userId),
        "directory": savepath
      });

      Response response = await HttpHelper.dioPost(
          "https://${Environment.apiUrl}/api/v1/images/upload", formData);
      return response;
    } on DioError catch (e) {
      print(e);
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
