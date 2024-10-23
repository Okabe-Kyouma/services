import 'package:dio/dio.dart';
import 'package:services/api/dio_setup.dart';

Future<int> findUserByEmail(String email) async {
  Dio dio = Dio();

  try {
     final response =
        await dio.get('$url/check/email/$email');


    print('response mssg: ${response.statusMessage}');

    if (response.statusCode == 200) {
      return 200;
    } else if (response.statusCode == 202) {
      return 202;
    } else {
      return 404;
    }
  } catch (e) {
    print('Exception: $e');
    return 404;
  }
}
