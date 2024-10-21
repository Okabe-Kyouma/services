import 'package:services/api/dio_setup.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<int> logout() async {
  final dio = await createDioWithCookieManager();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  try {
    final response = await dio.post('$url/logout');

    if (response.statusCode == 202) {
      print('logged Out!2');
      await prefs.remove('session');
      return 202;
    } else {
      print('Logout failed');
      return 404;
    }
  } catch (e) {
    print('error duing Logout $e');
    return 404;
  }
}
