import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/store/pill_bag_store.dart';
import '../../styles/colors/palette.dart';
import 'package:yoyak/apis/url.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:yoyak/screen/Search/pill_detail_screen.dart';

class PillBagDetailScreen extends StatefulWidget {
  final String envelopName;
  final int accountSeq;
  final int envelopSeq;

  const PillBagDetailScreen({
    super.key,
    required this.envelopName,
    required this.accountSeq,
    required this.envelopSeq,
  });

  @override
  State<PillBagDetailScreen> createState() => _PillBagDetailScreenState();
}

class _PillBagDetailScreenState extends State<PillBagDetailScreen> {
  // 상세보기 이동 api
  Future<void> _goToDetail(int medicineSeq) async {
    String yoyakURL = API.yoyakUrl; // 호스트 URL
    String url = '$yoyakURL/medicineDetail/$medicineSeq';
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

  // 약 삭제
  final List<int> _checkedPills = <int>[]; // 체크된 약 medicineSeq
  bool _isDeleteMode = false; // 삭제 모드

  void _toggleDeleteMode() {
    // 삭제 모드 토글
    setState(() {
      _isDeleteMode = !_isDeleteMode;
      _checkedPills.clear(); // 삭제 모드를 끄면 체크된 약 봉투 항목 초기화
    });
    print("삭제 모드: $_isDeleteMode");
  }

  _showSnackbar(String message, String color) {
    final snackbar = SnackBar(
      backgroundColor: color == 'red' ? Palette.MAIN_RED : Palette.MAIN_BLUE,
      content: Text(
        message,
        style: const TextStyle(
          color: Palette.MAIN_WHITE,
          fontSize: 14,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w400,
        ),
      ),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  // 약 컴포넌트
  Widget _pillComponent(
    int medicineSeq,
    // int accountSeq,
    // int envelopSeq,
    String imgPath,
    String itemName,
    // String envelopName,
  ) {
    bool isChecked =
        _checkedPills.contains(medicineSeq); // 현재 약 봉투 항목이 선택되었는지 여부

    return GestureDetector(
      onTap: () {
        if (!_isDeleteMode) {
          // 삭제 모드가 아닐 때, 클릭하면 상세 페이지로 이동
          print('상세정보 페이지로 이동 클릭');
          _goToDetail(medicineSeq);
        }
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.width * 0.20,
        decoration: const BoxDecoration(
          // color: isChecked ? Palette.BG_WHITE : Palette.BG_LIGHT_BLUE,
          // borderRadius: BorderRadius.circular(17),
          border: Border(
            bottom: BorderSide(
              color: Palette.MAIN_BLACK,
              width: 0.1,
            ),
          ),
        ),
        child: Row(
          children: [
            // 삭제모드 - 약 봉투 체크박스 출력
            if (_isDeleteMode)
              Container(
                width: MediaQuery.of(context).size.width * 0.07,
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                ),
                // 체크박스 크기 조정
                child: Transform.scale(
                  scale: 1.4,
                  child: Checkbox(
                    value: isChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _checkedPills.add(medicineSeq); // 체크하면 체크된 약 Seq에 추가
                        } else {
                          _checkedPills.remove(medicineSeq);
                        }
                      });
                      print("체크된 약: $_checkedPills");
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(
                      color: Palette.MAIN_BLACK,
                      width: 0.5,
                    ),
                    activeColor: Palette.MAIN_BLUE,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            SizedBox(
              width: _isDeleteMode
                  ? MediaQuery.of(context).size.width * 0.07
                  : MediaQuery.of(context).size.width * 0.04,
            ),
            ClipRRect(
              // 자식요소 크기 강제 설정
              borderRadius: BorderRadius.circular(17),
              child: Image.network(
                imgPath,
                width: MediaQuery.of(context).size.width * 0.20,
                height: MediaQuery.of(context).size.width * 0.10,
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
            // 약 이름
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: Text(
                itemName,
                overflow: TextOverflow.ellipsis, // 길이 초과하면 ...
                style: const TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 약 봉투안에 약 리스트 가져오기
    var pill = context.watch<PillBagStore>().pillBagDetail;
    print("pill : $pill");
    // 이걸 pillPriview로 넘기기? 그럼 삭제는????

    return Scaffold(
      backgroundColor: Palette.BG_BLUE,
      appBar: AppBar(
        title: Text(
          // 약 봉투 이름
          widget.envelopName,
          style: const TextStyle(
            color: Palette.MAIN_BLACK,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500,
            fontSize: 16,
            backgroundColor: Palette.BG_BLUE,
          ),
        ),
        actions: <Widget>[
          if (pill["count"] != 0)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _toggleDeleteMode, // 삭제 모드 토글 버튼
            ),
        ],
        backgroundColor: Palette.BG_BLUE,
        centerTitle: true,
        toolbarHeight: 55,
      ),
      body: pill['count'] == 0
          ? const Center(
              child: Text(
                "담겨진 약이 없어요.",
                style: TextStyle(
                  color: Palette.SUB_BLACK,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            )
          : SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.02,
                  horizontal: MediaQuery.of(context).size.height * 0.02,
                ),
                child: Column(
                  children: pill["count"] != 0
                      ? pill["result"].map<Widget>((pillInfo) {
                          var imgPath = pillInfo["imgPath"];
                          var itemName = pillInfo["itemName"];
                          var medicineSeq = pillInfo["medicineSeq"];

                          return SizedBox(
                              // 현재 페이지의 너비의 90%로 설정
                              child: _pillComponent(
                            medicineSeq,
                            imgPath,
                            itemName,
                          ));
                        }).toList()

                      // PillPreviews 출력

                      // 약 봉투에 약이 없을 때
                      // 로티 바꾸기 ?????
                      : [
                          // 로티
                          // const Column(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: [
                          //     Lottie.asset(
                          //       'assets/lotties/no_search.json',
                          //       alignment: Alignment.center,
                          //       width: MediaQuery.of(context).size.width * 0.750,
                          //       height: MediaQuery.of(context).size.height * 0.40,
                          //       // fit: BoxFit.fill,
                          //     ),
                          //     Center(
                          //       child: Text(
                          //         "담겨있는 약이 없어요",
                          //         style: TextStyle(
                          //           color: Palette.SUB_BLACK,
                          //           fontFamily: 'Pretendard',
                          //           fontWeight: FontWeight.w400,
                          //           fontSize: 20,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ],
                ),
              ),
            ),
      // 약 삭제 버튼
      floatingActionButton: _isDeleteMode
          ? Container(
              width: 45,
              height: 43,
              margin: const EdgeInsets.only(bottom: 10),
              child: FloatingActionButton(
                backgroundColor: Palette.MAIN_BLUE,
                elevation: 3,
                onPressed: () {
                  // @@ 진짜 삭제하시겠습니까? 다이얼로그 출력????
                  print("약 삭제 버튼 클릭");
                  // checkedPillBags에 있는 Seq들을 삭제
                  for (int medicineSeq in _checkedPills) {
                    context.read<PillBagStore>().deleteMedicine(
                          context,
                          widget.accountSeq,
                          medicineSeq,
                          widget.envelopSeq,
                        );
                  }
                  _showSnackbar("약 봉투가 삭제되었습니다.", 'red');
                  // 삭제 모드 종료
                  _toggleDeleteMode();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 23,
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
