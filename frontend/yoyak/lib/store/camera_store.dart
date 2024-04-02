import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../screen/Challenge/upload_challenge_screen.dart';
import 'package:yoyak/apis/url.dart';
import 'package:yoyak/screen/Search/photo_result_screen.dart';
import 'dart:io';

class CameraStore extends ChangeNotifier {
  Map<String, dynamic> photoResults = {}; // 사진 검색 결과
  XFile? image; // 이미지 담을 변수
  final ImagePicker picker = ImagePicker(); // Image Picker 초기화

  Future sendImageToServer(BuildContext context) async {
    String yoyakURL = API.yoyakUrl;
    String modifiedUrl = yoyakURL.substring(8, yoyakURL.length - 4);
    String toPath = '/api/recognition/upload'; // path
    String uri = 'https://$modifiedUrl$toPath';
    print("경로 : $uri");
    print("이미지 경로 : ${image!.path}");
    String fileName = path.basename(image!.path);
    print("이미지 네임 : $fileName");

    FormData formData = FormData.fromMap({
      'image': await MultipartFile.fromFile(image!.path, filename: fileName),
    });

    // 사진 용량 check
    await printImageFileSize(image!.path);

    try {
      Dio dio = Dio();
      Response response = await dio.post(
        uri,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (response.statusCode == 200) {
        print(response.data);
        photoResults = response.data;

        // 상세 페이지로 이동 (미완)
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PhotoResultScreen(
                      photoResults: photoResults,
                    )));
        // 이미지 변수 초기화
        // image = null;

        notifyListeners();
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future getImage(ImageSource imageSource) async {
    // pickedFile에 ImagePicker로 가져온 이미지가 담김
    final pickedFile = await picker.pickImage(
      source: imageSource,
      imageQuality: 100, // imageQuality는 이미지의 용량이 크기 때문에 압축을 위해 퀄리티를 낮춰주는 부분
    );
    if (pickedFile != null) {
      image = XFile(pickedFile.path); // 가져온 이미지를 image에 저장

      notifyListeners();
    } else {
      print("고른 이미지 null 값임");
    }
  }

  Future getImageAndNavigate(
      ImageSource imageSource, BuildContext context) async {
    // pickedFile에 ImagePicker로 가져온 이미지가 담김
    final pickedFile = await picker.pickImage(
      source: imageSource,
      imageQuality: 100,
    );
    if (pickedFile != null) {
      image = XFile(pickedFile.path); // 가져온 이미지를 image에 저장

      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const UploadChallengeScreen()));

      notifyListeners();
    } else {
      print("고른 이미지 null 값임");
    }
  }

  // 이미지 용량 체크
  Future<void> printImageFileSize(String imagePath) async {
    final file = File(imagePath);
    final fileSizeBytes = await file.length();
    final fileSizeKB = fileSizeBytes / 1024;
    final fileSizeMB = fileSizeKB / 1024;

    print("이미지 파일 크기: $fileSizeBytes 바이트");
    print("이미지 파일 크기: ${fileSizeKB.toStringAsFixed(2)} KB");
    print("이미지 파일 크기: ${fileSizeMB.toStringAsFixed(2)} MB");
  }

  // 화면 밖에 나갔다 오면 이미지 변수 초기화되게
  // 초기화하는 함수
  void clearImage() {
    image = null;
    notifyListeners();
  }
}
