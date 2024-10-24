import 'package:dio/dio.dart';
import 'package:services/api/dio_setup.dart';

Future<int> updateLocation(double latitude, double longitude) async {
  Dio dio = await createDioWithCookieManager();

  try {
    final response =
        await dio.post('$url/update/location/$latitude/$longitude');

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

Future<int> updatePassword(String email,String newPassword) async {
  Dio dio = Dio();

  try {
    final response = await dio.post('$url/update/password/$email/$newPassword');

    if (response.statusCode == 200) {
      print('password changed');
      return 200;
    } else if (response.statusCode == 202) {
      print('some error occurred!');
      return 202;
    } else {
      return 404;
    }
  } catch (e) {
    print("Exceptoin: $e");
    return 404;
  }
}
