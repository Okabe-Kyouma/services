import 'package:services/api/dio_setup.dart';

Future<int> deleteAccount() async {
  final dio = await createDioWithCookieManager();
  try {
    final response = await dio.post('$url/remove/account');

    if (response.statusCode == 200) {
      return 200;
    } else {
      return 404;
    }
  } catch (e) {
    print('error $e');
    return 500;
  }
}
