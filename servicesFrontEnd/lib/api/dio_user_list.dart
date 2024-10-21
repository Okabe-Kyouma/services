import 'package:dio/dio.dart';
import 'package:services/api/dio_setup.dart';

Future<dynamic> getUserList(String text,double latitude,double longitude) async {
  Dio dio = await createDioWithCookieManager();

  print('calling the api');

  try {
    Response<dynamic> response =
        await dio.get('$url/userList/$text/$latitude/$longitude');

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
