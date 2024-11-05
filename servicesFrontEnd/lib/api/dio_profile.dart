import 'package:services/api/dio_setup.dart';

class ProfileData {
  late String profileImage;
  late String fullName;
  late String userName;
  late String service;
  late String experience;
  late String phoneNumber;
  late String email;
}

Future<ProfileData> getProfileDate() async {
  final dio = await createDioWithCookieManager();

  try {
    final response = await dio.get('$url/profile');

    if (response.statusCode == 200) {
      final data = response.data;
      final profile = ProfileData()
        ..userName = data['username']
        ..email = data['email']
        ..profileImage = data['profilePictureUrl']
        ..phoneNumber = data['phoneNumber']
        ..service = data['service']
        ..experience = data['exp']
        ..fullName = data['fullname'];
      return profile;
    } else {
       throw Exception('Failed to load profile data: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception $e');
    throw Exception('Failed to load profile data:');
  }
}
