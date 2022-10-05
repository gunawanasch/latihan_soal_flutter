import 'dart:convert';

import 'package:latihan_soal_flutter/models/user_by_email.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHelper {
  static String userData = 'data_user';

  Future<SharedPreferences>sharedPref() async {
    final sharedPref = await SharedPreferences.getInstance();

    return sharedPref;
  }

  Future _saveString(key, data) async {
    final _pref = await sharedPref();
    await _pref.setString(key, data);
  }

  Future<String?> _getString(key) async {
    final _pref = await sharedPref();
    return _pref.getString(key);
  }

  setUserData(UserData userDataModel) async {
    final json = userDataModel.toJson();
    final userDataString = jsonEncode(json);
    await _saveString(userData, userDataString);
  }

  Future<UserData?> getUserData() async {
    final user = await _getString(userData);
    final jsonUserData = jsonDecode(user!);
    final userDataModel = UserData.fromJson(jsonUserData);

    return userDataModel;
  }

}