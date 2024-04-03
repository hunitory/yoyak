import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/pill_preview.dart';
import 'package:yoyak/store/camera_store.dart';
import '../../styles/colors/palette.dart';
import 'package:lottie/lottie.dart';

// @@ 페이지네이션 필요 ?
// @@ 비동기때문에 이전 검색 결과가 1초 동안 나오다가 새로운거 빌드..

class PhotoResultScreen extends StatefulWidget {
  final Map<String, dynamic> photoResults;

  const PhotoResultScreen({
    super.key,
    required this.photoResults,
  });

  @override
  State<PhotoResultScreen> createState() => _PhotoResultScreenState();
}

class _PhotoResultScreenState extends State<PhotoResultScreen> {
  @override
  Widget build(BuildContext context) {
    // 사진 검색 결과 가져오기
    var photoResults = context.watch<CameraStore>().photoResults;

    print("photoResults: $widget.photoResults");

    // PillPreview 위젯 생성
    // List<Widget> pillPreviews =
    //     List.from(photoResults["medicineList"]).map<Widget>((pill) {
    //   var imgPath = pill["imgPath"];
    //   var itemName = pill["itemName"];
    //   var entpName = pill["entpName"];
    //   var medicineSeq = pill["medicineSeq"];
    //   return PillPreview(
    //       imgPath: imgPath,
    //       itemName: itemName,
    //       entpName: entpName,
    //       medicineSeq: medicineSeq);
    // }).toList(); // map의 결과를 List<Widget>으로 변환

    return Scaffold(
      backgroundColor: Palette.BG_BLUE,
      appBar: AppBar(
        title: const Text(
          '약 검색',
          style: TextStyle(
            color: Palette.MAIN_BLACK,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        backgroundColor: Palette.BG_BLUE,
        centerTitle: true,
        toolbarHeight: 55,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // color: Palette.BG_BLUE,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: const Column(
                        children: [
                          Text(
                            "사진으로 알약 검색",
                            style: TextStyle(
                                color: Palette.MAIN_BLACK,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                                fontSize: 24),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      'assets/images/pill.png',
                      width: 30,
                      height: 30,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "검색 결과",
                        style: TextStyle(
                            color: Palette.MAIN_BLACK,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            fontSize: 24),
                      ),
                      Text(
                        "총 ${photoResults["count"] ?? 0}개",
                        style: const TextStyle(
                            color: Palette.SUB_BLACK,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w600,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // ...pillPreviews,
                Column(
                  children: photoResults["count"] != 0
                      ? photoResults["medicineList"].map<Widget>((pill) {
                          var imgPath = pill["imgPath"];
                          var itemName = pill["itemName"];
                          var entpName = pill["entpName"];
                          var medicineSeq = pill["medicineSeq"];
                          return PillPreview(
                              imgPath: imgPath,
                              itemName: itemName,
                              entpName: entpName,
                              medicineSeq: medicineSeq);
                        }).toList()

                      // PillPreviews 출력
                      : [
                          // 로티
                          Lottie.asset(
                            'assets/lotties/no_search.json',
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.750,
                            height: MediaQuery.of(context).size.height * 0.40,
                            // fit: BoxFit.fill,
                          ),
                          const Text(
                            "검색 결과가 없어요.",
                            style: TextStyle(
                              color: Palette.SUB_BLACK,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                            ),
                          ),
                        ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
