import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper{

  static Dio dio;
  static init(){
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://student.valuxapps.com/api/',
        receiveDataWhenStatusError: true,
    //     headers: {
    //       'Content-Type' : 'application/json',
    //
    // }
      )
    );
  }

  static Future<Response> getData({
    @required String pathUrl,
     Map<String,dynamic> query,
    String token,
    String lang = 'en',
}) async{
    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.get(
        pathUrl,
    queryParameters: query,);
  }

  static Future<Response> postData({
    @required String pathUrl,
    @required Map<String,dynamic> data,
    Map<String,dynamic> query,
    String token,
    String lang = 'en',
  })async{
    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.post(
        pathUrl,
    queryParameters: query,
    data:data );
}

  static Future<Response> putData({
    @required String pathUrl,
    @required Map<String,dynamic> data,
    Map<String,dynamic> query,
    String token,
    String lang = 'en',
  })async{
    dio.options.headers = {
      'Content-Type':'application/json',
      'lang':lang,
      'Authorization':token??'',
    };
    return await dio.put(
        pathUrl,
        queryParameters: query,
        data:data );
  }
}