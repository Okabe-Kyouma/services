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

Future<int> updatePhoneNumber(String phoneNumber) async {
  final dio = await createDioWithCookieManager();

  try {
    final response = await dio.get('$url/update/phoneNumber/$phoneNumber');

    if (response.statusCode == 200) {
      print('phone Number changed');
      return 200;
    } else if (response.statusCode == 202) {
      print('Previous phone Number cant be new');
      return 202;
    } else {
      print('Some Error Occurred');
      return 404;
    }
  } catch (e) {
    print('Exception: $e');
    return 500;
  }
}

Future<int> updatePassword(String email, String newPassword) async {
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

Future<int> updateProfile(
    String selectedWork, String exp, String imgurImage) async {
  final dio = await createDioWithCookieManager();

  String encodedImageUrl = Uri.encodeComponent(imgurImage);

  try {
    print('imgur image on updateprofile in dio_update: $encodedImageUrl');
    final response = await dio
        .post('$url/profile/update/$selectedWork/$exp/$encodedImageUrl');

    if (response.statusCode == 200) {
      print('profile updated');
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
