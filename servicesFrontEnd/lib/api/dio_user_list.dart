import 'package:dio/dio.dart';

Future<dynamic> getUserList(String text) async {
  Dio dio = Dio();

  print('calling the api');

  try {
    Response<dynamic> response =
        await dio.get('http://192.168.29.163:4000/userList/$text');

    print('response: $response');

    if (response.statusCode == 202) {
      return response.data;
    } else {
      return [];
    }
  } catch (e) {
    print('error received: ' + e.toString());
    return [];
  }
}
