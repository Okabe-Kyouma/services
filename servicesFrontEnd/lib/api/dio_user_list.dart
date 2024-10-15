import 'package:dio/dio.dart';

Future<int> getUserList(String text) async {
  Dio dio = Dio();

  try {
    final response = await dio.post('http://192.168.29.163:4000/userList/$text');

    print('response: $response');

    if (response.statusCode == 202) {
      return 202;
    } else {
      return 404;
    }
  } catch (e) {
    return 404;
  }
}
