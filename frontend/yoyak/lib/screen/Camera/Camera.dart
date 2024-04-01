import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/store/camera_store.dart';
import 'package:yoyak/styles/colors/palette.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    var sendImageToServer = context.read<CameraStore>().sendImageToServer;
    return Container(
      color: Palette.BG_BLUE,
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          showImageArea(),
          const SizedBox(
            height: 20,
          ),
          cameraAndImageButton(),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () {
                sendImageToServer();
              },
              child: const Text("서버로 사진 전송"))
        ],
      ),
    );
  }

  Widget showImageArea() {
    var image = context.watch<CameraStore>().image;
    return image != null
        ? RoundedRectangle(
            width: 400,
            height: 300,
            child: Image.file(File(image.path)),
          )
        : RoundedRectangle(
            width: 400,
            height: 300,
            child: Container(
              width: 400,
              height: 300,
              color: Colors.grey,
            ),
          );
  }

  // 카메라 및 이미지 버튼
  Widget cameraAndImageButton() {
    var getImage = context.read<CameraStore>().getImage;
    return Row(
      children: [
        RoundedRectangle(
          child: Text("카메라"),
          width: 200,
          height: 200,
          onTap: () {
            print("카메라 열기");
            getImage(ImageSource.camera);
          },
        ),
        RoundedRectangle(
          width: 200,
          height: 200,
          onTap: () {
            print("카메라 열기");
            getImage(ImageSource.gallery);
          },
          child: Text("이미지 선택"),
        )
      ],
    );
  }
}
