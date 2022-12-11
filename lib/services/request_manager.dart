import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class RequestManager {
  RequestManager._();

  static Dio dio = Dio(BaseOptions(baseUrl: AppConstants.baseUrl));

  static Future<ResponseHttp?> post(String uri,
      {Map<String, dynamic> data = const {}}) async {
    try {
      // todo: check x-access-token in header

      print('** Request {POST} => ${AppConstants.baseUrl}/$uri');
      print('| data => $data');
      // http.Response response =
      var res = await http.post(Uri.parse('${AppConstants.baseUrl}/$uri'), body: data);
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
          await dio.get('${AppConstants.baseUrl}/$uri', queryParameters: parameters);
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
