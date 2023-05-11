import 'package:flutter/foundation.dart';

class AppUser {
  static String? username;
  static Role? role;
  //  = Role.customer;
  static String? userId;
  static String? token;
}

enum Role { merchant, customer }
