import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:nukang_fe/authentication/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  static GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  static GlobalKey<NavigatorState>? navigationKey;

  static GlobalKey<NavigatorState> getNavigationKey() {
    return navigationKey ??= GlobalKey<NavigatorState>();
  }

  static Future<dynamic> navigateToRoute(
    Widget _rn,
  ) {
    // print("NAVIGATE");
    return getNavigationKey().currentState!.push(
          MaterialPageRoute(
            builder: (context) => _rn,
          ),
        );
  }

  static Future<dynamic> pushAndReplace(
    Widget _rn,
  ) {
    // if (getNavigationKey().currentState!.canPop()) {
    return getNavigationKey().currentState!.pushReplacement(
          MaterialPageRoute(
            builder: (context) => _rn,
          ),
        );
    // } else {
    //   return getNavigationKey().currentState!.push(
    //         MaterialPageRoute(
    //           builder: (context) => _rn,
    //         ),
    //       );
    // }
  }

  static Future<dynamic> clearStackPush(
    Widget _rn,
  ) {
    if (getNavigationKey().currentState!.canPop()) {
      return getNavigationKey().currentState!.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => _rn,
          ),
          (Route<dynamic> route) => false);
    } else {
      return getNavigationKey().currentState!.push(MaterialPageRoute(
            builder: (context) => _rn,
          ));
    }
  }

  static MotionToast toast(String msg, int duration,
      MotionToastPosition motionToastPosition, double size) {
    return MotionToast.error(
      animationDuration: Duration(milliseconds: duration),
      title: const Text(
        'Error',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        msg,
        style: TextStyle(fontSize: 10),
      ),
      position: motionToastPosition,
      barrierColor: Colors.black.withOpacity(0.3),
      width: size,
      dismissable: false,
      toastDuration: Duration(milliseconds: duration * 2),
    );
  }

  static MotionToast toastSuccess(String msg, int duration,
      MotionToastPosition motionToastPosition, double size) {
    return MotionToast.success(
      animationDuration: Duration(milliseconds: duration),
      title: const Text(
        'Success',
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      description: Text(
        msg,
        style: TextStyle(fontSize: 10),
      ),
      position: motionToastPosition,
      barrierColor: Colors.black.withOpacity(0.3),
      width: size,
      height: 40,
      dismissable: false,
      toastDuration: Duration(milliseconds: duration * 2),
    );
  }

  static navigateBack() {
    return getNavigationKey().currentState!.pop();
  }



  static void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("nukang_user", "");
    clearStackPush(const LoginPage());
  }
}

extension Data on Map<String, TextEditingController> {
  Map<String, String> data() {
    final res = <String, String>{};
    for (MapEntry e in entries) {
      res.putIfAbsent(e.key, () => e.value?.text);
    }
    return res;
  }
}
