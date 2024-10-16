import 'dart:io';

import 'package:dio/dio.dart';

Future<String> imageUploadtoImgur(File file) async {
  Dio dio = Dio();

  const clientId = '6ffafeb26ad4331';

  try {
    String fileName = file.path.split('/').last;

    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    Response response = await dio.post(
      'https://api.imgur.com/3/image',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Client-ID $clientId',
        },
      ),
    );

    if (response.statusCode != null && response.statusCode == 200) {
      String imageLink = response.data['data']['link'];
      print('image upload link: $imageLink');
      return imageLink;
    } else {
      print('failed to upload image');
      return 'cant';
    }
  } catch (e) {
    print('error during image uplaod: $e');
    return 'cant';
  }
}


