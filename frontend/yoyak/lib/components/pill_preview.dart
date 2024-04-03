import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/screen/Search/pill_detail_screen.dart';
import '../styles/colors/palette.dart';
import 'package:yoyak/apis/url.dart';

class PillPreview extends StatefulWidget {
  final int medicineSeq;
  final String? imgPath;
  final String itemName;
  final String? entpName;
  final Function()? onTap;

  const PillPreview({
    super.key,
    this.imgPath,
    required this.itemName,
    required this.medicineSeq,
    this.entpName,
    this.onTap,
  });

  @override
  State<PillPreview> createState() => _PillPreviewState();
}

class _PillPreviewState extends State<PillPreview> {
  // 상세보기 이동 api
  Future<void> _goToDetail() async {
    String yoyakURL = API.yoyakUrl; // 호스트 URL
    String url = '$yoyakURL/medicineDetail/${widget.medicineSeq}';
    Uri uri = Uri.parse(url);

    try {
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);
        var jsonData = json.decode(decodedBody);

        print("알약 상세정보 페이지로 이동 성공 $jsonData");

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PillDetailScreen(
                medicineInfo: jsonData,
              ),
            ),
          );
        }
      } else {
        print("알약 상세정보 페이지로 이동 실패: ${response.body}");
      }
    } catch (e) {
      print("알약 상세정보 페이지로 이동 실패 캐피: $e");
    }
    // path
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap 상세정보 페이지로 이동(mediaSeq로 api 요청해서 받아오기)
      onTap: () {
        print('상세정보 페이지로 이동 클릭');
        _goToDetail();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: RoundedRectangle(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * 0.20,
          boxShadow: const [
            BoxShadow(
              color: Palette.SHADOW_GREY,
              blurRadius: 3,
              offset: Offset(0, 2),
            )
          ],
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.05,
              ),
              ClipRRect(
                // 자식요소 크기 강제 설정
                borderRadius: BorderRadius.circular(17),
                child: Image.network(
                  widget.imgPath!, // null이 아님
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.width * 0.13,
                  fit: BoxFit.cover,
                  // 에러 처리
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    print(error);
                    print("이미지 오류 해결 !!!!!!!!!!!!!");
                    // 대체 이미지 반환
                    return Image.asset(
                      'assets/images/pillbox.jpg',
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.width * 0.13,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.07,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      widget.itemName,
                      overflow: TextOverflow.ellipsis, // 길이 초과하면 ...
                      style: const TextStyle(
                        color: Palette.MAIN_BLACK,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  if (widget.entpName != null)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        widget.entpName!,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Palette.SUB_BLACK,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
