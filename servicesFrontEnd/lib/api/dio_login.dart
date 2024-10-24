import 'package:services/api/dio_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<int> signIn({required String username, required String password}) async {
  final dio = await createDioWithCookieManager();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  final userData = {
    'username': username,
    "password": password,
  };

  try {
    final response = await dio.post('$url/login', data: userData);

    if (response.statusCode == 200) {
      print('logged In!');
      final sesssionId = response.data['sessionId'];

      await prefs.setString('session', sesssionId.toString());
      return 200;
    } else {
      print('login failed! User donest Exists');
      return 202;
    }
  } catch (e) {
    print('error duing login $e');
    return 404;
  }
}
