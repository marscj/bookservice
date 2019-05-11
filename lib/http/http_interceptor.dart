// import 'dart:async';
// import 'package:dio/dio.dart';

// typedef HttpLoaderCallback = void Function();

// class HttpInterceptor extends Dio {
  
//   HttpInterceptor() {
//     interceptor.request.onSend =  onSend;
//     interceptor.response.onError = onError;
//   }

//   String token;

//   FutureOr getToken;

//   dynamic onSend(Options options) {
//     if (token == null){
//       lock();
//       return  Future(getToken).then((idToken) {
//         if (idToken != null) {
//           options.headers['Authorization'] = token = 'Bearer ' + idToken;
//         }
//         return options;
//       }).whenComplete((){
//         unlock();
//       });
//     } else {
//       options.headers['Authorization'] = token;
//     }
//   }

//   dynamic onError(DioError e){
//     if (e.type == DioErrorType.RESPONSE && e.response.statusCode == 401) {
//       token = null;
//     }
//     return e;
//   }

// }