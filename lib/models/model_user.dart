import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModelUser {
  String id;
  String username;
  String? password;
  String? fullName;
  String? mobileNumber;
  String? expert;
  String? medicalCouncilNo;
  String? token;
  String? imgUrl;
  String? signatureImage;
  TextEditingController newUsernameController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  ModelUser(
      this.id,
      this.username,
      this.password,
      this.fullName,
      this.mobileNumber,
      this.expert,
      this.medicalCouncilNo,
      this.token,
      this.imgUrl,
      this.signatureImage);

  factory ModelUser.fromData(data) {

    return ModelUser(
        data['_id'],
        data['username'],
        data['password'],
        data['fullName'],
        data['mobileNumber'],
        data['expert'],
        data['medicalCouncilNo'],
        data['token'],
        data['img'],
        data['signatureImage']);
  }

  static ModelUser? getModelUser(SharedPreferences sharedPreferences) {
    if ((sharedPreferences.getBool('isLoggedIn') ?? false) == false) {
      return null;
    }

    return ModelUser(
        sharedPreferences.getString('id')!,
        sharedPreferences.getString('username')!,
        null,
        sharedPreferences.getString('fullName'),
        sharedPreferences.getString('mobileNumber'),
        sharedPreferences.getString('expert'),
        sharedPreferences.getString('medicalCouncilNo'),
        sharedPreferences.getString('token'),
        sharedPreferences.getString('imgUrl'),
        sharedPreferences.getString('signatureUrl'));
  }

  static addToSharedPrefs(
      SharedPreferences sharedPreferences, ModelUser modelUser) async {
    sharedPreferences.setString('id', modelUser.id);
    sharedPreferences.setString('username', modelUser.username);
    if (modelUser.fullName != null) {
      sharedPreferences.setString('fullName', modelUser.fullName!);
    }
    if (modelUser.mobileNumber != null) {
      sharedPreferences.setString('mobileNumber', modelUser.mobileNumber!);
    }
    if (modelUser.expert != null) {
      sharedPreferences.setString('expert', modelUser.expert!);
    }
    if (modelUser.medicalCouncilNo != null) {
      sharedPreferences.setString(
          'medicalCouncilNo', modelUser.medicalCouncilNo!);
    }

    await sharedPreferences.setString('token', modelUser.token!);

    if (modelUser.imgUrl != null) {
      sharedPreferences.setString('imgUrl', modelUser.imgUrl!);
    }

    if (modelUser.signatureImage != null) {
      sharedPreferences.setString('signatureUrl', modelUser.signatureImage!);
    }
  }
}
