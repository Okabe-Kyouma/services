import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

Future<Dio> createDioWithCookieManager() async {
  // Get the application document directory
  final directory = await getApplicationDocumentsDirectory();
  final cookieJarPath = '${directory.path}/cookies'; // Set the path to the document directory

  // Initialize the cookie manager with the file path
  final cookieJar = PersistCookieJar(storage: FileStorage(cookieJarPath));

  final dio = Dio()
    ..interceptors.add(CookieManager(cookieJar));

  return dio;
}
