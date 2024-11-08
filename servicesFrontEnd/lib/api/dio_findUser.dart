import 'package:dio/dio.dart';
import 'package:services/api/dio_setup.dart';

Future<String?> fetchUsername(String email) async {
  try {
    final response = await Dio().get('$url/send/username/$email');

    if (response.statusCode == 200) {
      return response.data['username'];
    } else if (response.statusCode == 202) {
      return "email-id doesn't exist";
    } else {
      return "Unknown error occurred";
    }
  } catch (e) {
    return "Server is down";
  }
}

Future<int> findUserByEmail(String email) async {
  Dio dio = Dio();

  print('this working?? the comp: url: $url/check/email/$email');

  try {
    final response = await dio.get('$url/check/email/$email');

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

Future<int> checkIfNumberExists(String number) async {
  Dio dio = Dio();

  try {
    final response = await dio.get('$url/check/number/$number');

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
