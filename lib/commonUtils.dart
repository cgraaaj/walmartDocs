
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:dio/dio.dart';

class CommonUtils {
  String url;
  bool isTokenSet = false;
  String authKey;
  var response;
  Map jsonParam;
  final client = http.Client();
  Dio dio;
  
  

  CommonUtils(String url){
   this.url = url;
   jsonParam = new Map();
   dio = new Dio();
   //dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
  }

   void addParam(String name, String value)
    {
        jsonParam[name] = value;   
    }

    Map getJson()
    {
      return jsonParam;
    }

     String getUrl()
    {
      return url;
    }
    

  void setAuthKey(String token) {
    if (null != token) {
      this.isTokenSet = true;
      authKey = "Bearer " + token;
    }
  }

  String getResponse() {
    return response;
  }

  Future execute(String method) async {
    Completer completer = new Completer();
    
    switch (method) {
      case "GET":
        {
          print("get"+url);
          completer.complete(await dio.get(url));
        }
        break;
      case "POST":
        {
          print("post" + url + jsonParam.toString());
          completer.complete(await dio.post(url,data: jsonParam));
        }
        break;
      case "DELETE":
        {}
        break;
      case "PUT":
        {}
        break;
    }
    return completer.future;
  }
}
