import 'dart:convert';
import 'package:chat_babakcode/services/request_manager.dart';
import 'package:chat_babakcode/utils/crypto_manager.dart';

class AuthServices {

  final CryptoManager _cryptoManager = CryptoManager();
  String get loginWithTokenRoute => 'registerNewToken';
  String get recoveryTokenRoute => 'recovery';

  Future<ResponseHttp?> registerNewToken(
      String token, String name, String platform) async {
    return await RequestManager.post(loginWithTokenRoute,
        data: {'token': token, 'name': name, 'platform': platform});
  }
  
  Future<ResponseHttp?> recoveryToken(
      String phrase, String platform) async {
    
    return await RequestManager.post(recoveryTokenRoute,
        data: {'phrase': json.encode( _cryptoManager.encryptData(phrase)?.toMap()), 'platform': platform});
  }
}
