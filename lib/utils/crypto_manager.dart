import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../constants/app_constants.dart';

class CryptoManager {

  final _encryptor = encrypt.Encrypter(encrypt.AES(
      encrypt.Key.fromUtf8(AppConstants.globalEncryptKey),
      mode: encrypt.AESMode.ctr,
      padding: null));

  String? decryptData(Map mapHash) {
    try {
      final decrypted = _encryptor.decryptBytes(
          encrypt.Encrypted(Uint8List.fromList(hex.decode(mapHash['content']))),
          iv: encrypt.IV(Uint8List.fromList(hex.decode(mapHash['iv']))));
      return utf8.decode(decrypted);
    } catch (e) {
      print(e);
      return null;
    }
  }

  EncryptModel? encryptData(String data) {
    try {
      final iv = encrypt.IV.fromSecureRandom(16);
      final encrypted = _encryptor.encrypt(data, iv: iv);
      return EncryptModel(hex.encode(encrypted.bytes), hex.encode(iv.bytes));
    } catch (e) {
      return null;
    }
  }
}

class EncryptModel {
  String hash, iv;
  EncryptModel(this.hash, this.iv);
  toMap() => {'content': hash, 'iv': iv};
}
