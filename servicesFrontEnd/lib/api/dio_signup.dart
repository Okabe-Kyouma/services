import 'package:services/api/dio_setup.dart';

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
  final dio = await createDioWithCookieManager();

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
    //192.168.29.
    final response =
        await dio.post('http://192.168.29.163:4000/signup', data: userData);

    if (response.statusCode == 200) {
      print('signed up!!');
      return 200;
    } else if (response.statusCode == 202) {
      print('signup failed! User already exists');
      return 202;
    } else {
      return 404;
    }
  } catch (e) {
    print('error during signup: $e');
    return 404;
  }
}
