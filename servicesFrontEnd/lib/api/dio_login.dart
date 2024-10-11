import 'package:dio/dio.dart';

Future<int> signIn({required String username, required String password}) async {
  final dio = Dio();

  final userData = {
    'username': username,
    "password": password,
  };

  try {
    final response =
        await dio.post('http://192.168.29.163:4000/login', data: userData);

    if (response.statusCode == 202) {
      print('logged In!');
      return 202;
    } else {
      print('Signup failed');
      return 404;
    }
  } catch (e) {
    print('error duing login $e');
    return 404;
  }
}
