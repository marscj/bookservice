// import 'dart:async';
// import 'http_interceptor.dart';
// import 'package:dio/dio.dart';

// const String HTTP_HOST = 'https://us-central1-bookservice-7a1ad.cloudfunctions.net';
// const int CONNECT_TIMEOUT = 5000;
// const int RECEIVE_TIMEOUT = 3000;

// class _HttpLoader extends HttpInterceptor {
  
//   _HttpLoader();

//   void init(future) {
//     options = new Options(
//       baseUrl: HTTP_HOST,
//       connectTimeout: CONNECT_TIMEOUT,
//       receiveTimeout: RECEIVE_TIMEOUT,
//     );

//     getToken = future;
//   }

//   static _HttpLoader _instance = new _HttpLoader();
//   static _HttpLoader get instance => _instance;
// }

// class HttpLoader extends _HttpLoader {

//   HttpLoader._();

//   static HttpLoader _instance = new HttpLoader._();

//   static HttpLoader get instance => _instance;

//   Completer comparable;

//   Future<String> get hello => get('/app/hello').then((rep){
//     return rep.data;
//   });

//   Future<String> setCustomClaims(dynamic data) => post('/app/setCustomClaims', data: data).then((rep){
//     return rep?.data;
//   });
// }