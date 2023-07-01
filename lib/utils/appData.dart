import 'package:firebase_auth/firebase_auth.dart';

enum LoginType{None, Google, Anonymous}

class AppProfile {
  User? user;
  LoginType? loginType;

  AppProfile() {
    user = null;
    loginType = LoginType.None;
  }

}

AppProfile appProfile = AppProfile();

final String storagePath = 'gs://moappfinal-b334f.appspot.com/images';
bool isDescending = false;