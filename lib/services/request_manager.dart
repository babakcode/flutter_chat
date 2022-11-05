import 'dart:convert';
import 'package:chat_babakcode/constants/config.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class RequestManager {
  RequestManager._();

  static Dio dio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl));

  static Future<ResponseHttp?> post(String uri,
      {Map<String, dynamic> data = const {}}) async {
    try {
      // todo: check x-access-token in header

      print('** Request {POST} => ${AppConfig.baseUrl}/$uri');
      print('| data => $data');
      // http.Response response =
      var res = await http.post(Uri.parse('${AppConfig.baseUrl}/$uri'), body: data);
      print('| respose => ${res.body}');
      return ResponseHttp(jsonDecode(res.body), res.statusCode);
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<ResponseHttp?> get(String uri,
      {Map<String, dynamic>? parameters}) async {
    try {
      Response response =
          await dio.get('${AppConfig.baseUrl}/$uri', queryParameters: parameters);
      return ResponseHttp(response.data, response.statusCode);
    } catch (e) {
      print(e);
    }
    return null;
  }
}

class ResponseHttp {
  Map data;
  int? statusCode;
  ResponseHttp(this.data, this.statusCode);
}
