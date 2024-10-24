import 'package:dio/dio.dart';
import 'package:services/api/dio_setup.dart';

Future<int> updateLocation(double latitude, double longitude) async {
  Dio dio = await createDioWithCookieManager();

  try {
    final response = await dio.post('$url/update/location/$latitude/$longitude');

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
