import 'package:dio/dio.dart';

Future<int> signupUser({
  required String username,
  required String fullname,
  required String phoneNumber,
  required String email,
  required String aadhar,
  required String password,
  required String service,
  required String exp,
  required String profilePictureUrl,
  required double latitude,
  required double longitude,
  required String homeLocation,
}) async {
  final dio = Dio();

  final userData = {
    'profilePictureUrl': profilePictureUrl,
    'username': username,
    'fullname': fullname,
    'phoneNumber': phoneNumber,
    'email': email,
    'aadhar': aadhar,
    'password': password,
    'service': service,
    'exp': exp,
    'currentLocation': {
      'type': 'Point',
      'coordinates': [latitude, longitude],
    },
    'homeLocation': homeLocation
  };

  try {
    final response =
        await dio.post('http://192.168.29.163:4000/signup', data: userData);

    if (response.statusCode == 201) {
      print('signed up!!');
      return 201;
    } else {
      print('signup failed');
      return 404;
    }
  } catch (e) {
    print('error during signup: $e');
    return 405;
  }
}
