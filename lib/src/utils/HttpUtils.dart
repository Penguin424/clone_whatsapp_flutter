// ignore_for_file: file_names

import 'package:chat_flutter/src/utils/PrefsSIngle.dart';
import 'package:dio/dio.dart';

class Http {
  static final Http _httpMod = Http._internal();
  factory Http() {
    PreferenceUtils.init();

    return _httpMod;
  }
  Http._internal();

  static const String _host = "192.168.15.157";
  static const int _port = 1337;

  static final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  static final Map<String, String> _headersAuth = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${PreferenceUtils.getString("jwt")}',
  };

  static Future<Response> get(
    String path,
    Map<String, dynamic> parameters,
  ) async {
    Uri url = Uri(
      host: _host,
      port: _port,
      path: "api/" + path,
      queryParameters: parameters,
      scheme: 'http',
    );

    print(url.toString());

    Response response = await Dio().get(
      url.toString(),
      options: Options(
        headers: _headersAuth,
      ),
    );

    return response;
  }

  static Future<Response> post(
    String path,
    String data,
  ) async {
    Uri url = Uri(
      host: _host,
      port: _port,
      path: "api/" + path,
      scheme: 'http',
    );
    Response response = await Dio().post(
      url.toString(),
      data: data,
      options: Options(
        headers: _headersAuth,
      ),
    );

    return response;
  }

  static Future<Response> login(
    String path,
    String data,
  ) async {
    Uri url = Uri(
      host: _host,
      port: _port,
      path: "api/" + path,
      scheme: 'http',
    );

    Response response = await Dio().post(
      url.toString(),
      data: data,
      options: Options(
        headers: _headers,
      ),
    );

    return response;
  }

  static Future<Response> update(
    String path,
    String data,
  ) async {
    Uri url = Uri(
      host: _host,
      port: _port,
      path: "api/" + path,
      scheme: 'http',
    );
    Response response = await Dio().put(
      url.toString(),
      data: data,
      options: Options(
        headers: _headersAuth,
      ),
    );

    return response;
  }

  static Future<Response> delete(
    String path,
    Map<String, dynamic> parameters,
  ) async {
    Uri url = Uri(
      host: _host,
      port: _port,
      path: "api/" + path,
      queryParameters: parameters,
      scheme: 'http',
    );
    Response response = await Dio().delete(
      url.toString(),
      options: Options(
        headers: _headersAuth,
      ),
    );

    return response;
  }
}
