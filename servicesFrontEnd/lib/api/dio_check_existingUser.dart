import 'package:services/api/dio_setup.dart';

Future<int> checkIfEmailExistsInDb(String email) async {
  final dio = await createDioWithCookieManager();

  try {
    final response =
        await dio.get('$url/check/email/$email');

    if (response.statusCode == 200) {
      return 200;
    } else if (response.statusCode == 202) {
      return 202;
    } else if (response.statusCode == 500) {
      return 500;
    }
  } catch (e) {
    print('exception: $e');
    return 404;
  }

  return 0;
}

Future<bool> checkIfUsernameExists(String username) async {
  final dio = await createDioWithCookieManager();

  try {
     final response = 
         await dio.get('http://192.168.29.163:4000/check/username/$username');



    if (response.statusCode == 200) {
      return true; 
    } else if (response.statusCode == 202) {
      return false;
    }
  } catch (e) {
    print('Exception: $e');
    return false; 
  }

  return false;
}
