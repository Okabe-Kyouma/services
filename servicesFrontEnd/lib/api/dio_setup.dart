import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:path_provider/path_provider.dart';

Future<Dio> createDioWithCookieManager() async {
  final directory = await getApplicationDocumentsDirectory();
  final cookieJarPath = '${directory.path}/cookies';

  final cookieJar = PersistCookieJar(storage: FileStorage(cookieJarPath));

  final dio = Dio()..interceptors.add(CookieManager(cookieJar));

  return dio;
}

const url = 'http://192.168.29.163:4000';
//const url = 'http://172.16.154.34:4000';
