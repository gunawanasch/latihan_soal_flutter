import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:latihan_soal_flutter/constants/api_url.dart';
import 'package:latihan_soal_flutter/helpers/user_email.dart';
import 'package:latihan_soal_flutter/models/network_response.dart';

class AuthProvider extends ChangeNotifier {

  Dio dioApi() {
    BaseOptions options = BaseOptions(
      baseUrl: ApiUrl.baseUrl,
      headers: {
        "x-api-key" : ApiUrl.apiKey,
        HttpHeaders.contentTypeHeader : "application/json",
      },
      responseType: ResponseType.json,
    );

    final dio = Dio(options);

    return dio;
  }

  Future<NetworkResponse> _getRequest({endpoint, param}) async {
    try {
      final dio = dioApi();
      final result = await dio.get(endpoint, queryParameters: param);

      return NetworkResponse.success(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        return NetworkResponse.error(data: null, message: 'request timeout');
      } else {
        return NetworkResponse.error(data: null, message: 'request error dio');
      }
    } catch(e) {
      return NetworkResponse.error(data: null, message: 'other error');
    }
  }

  Future<NetworkResponse> _postRequest({endpoint, body}) async {
    try {
      final dio = dioApi();
      final result = await dio.post(endpoint, data: body);

      return NetworkResponse.success(result.data);
    } on DioError catch (e) {
      if (e.type == DioErrorType.sendTimeout) {
        return NetworkResponse.error(data: null, message: 'request timeout');
      } else {
        return NetworkResponse.error(data: null, message: 'request error dio');
      }
    } catch(e) {
      return NetworkResponse.error(data: null, message: 'other error');
    }
  }

  Future<NetworkResponse> getUserByEmail() async {
    final result = await _getRequest(
      endpoint: ApiUrl.users,
      param: {
        "email" : UserEmail.getUserEmail(),
      }
    );

    return result;
  }

  Future<NetworkResponse> postRegister(body) async {
    final result = await _postRequest(
      endpoint: ApiUrl.usersRegistrasi,
      body: body,
    );

    return result;
  }

  Future<NetworkResponse> postUpdateUser(body) async {
    final result = await _postRequest(
      endpoint: ApiUrl.usersUpdateProfile,
      body: body,
    );

    return result;
  }

}