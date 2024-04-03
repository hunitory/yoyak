import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../styles/colors/palette.dart';
import 'package:yoyak/apis/url.dart';
import 'package:lottie/lottie.dart';
import 'package:yoyak/components/pill_preview.dart';

class Pill {
  final String? imgPath;
  final String? itemName;
  final String? entpName;
  final int? medicineSeq;

  Pill({this.imgPath, this.itemName, this.entpName, this.medicineSeq});

  factory Pill.fromJson(Map<String, dynamic> json) {
    return Pill(
      imgPath: json['imgPath'],
      itemName: json['itemName'],
      entpName: json['entpName'],
      medicineSeq: json['medicineSeq'],
    );
  }
}

class TextSearchScreen extends StatefulWidget {
  const TextSearchScreen({super.key});

  @override
  State<TextSearchScreen> createState() => _TextSearchScreenState();
}

class _TextSearchScreenState extends State<TextSearchScreen> {
  bool _searchSuccess = false; // 검색 성공 여부(UI 업데이트)
  var data = {}; // 검색 결과
  Map<String, dynamic> resultPills = {}; // 검색 결과 약
  final _controller = TextEditingController(); // 검색어 초기화
  final ScrollController _scrollController =
      ScrollController(); // 스크롤 이벤트 감지(무한스크롤)
  final List<dynamic> _pills = []; // 화면에 표시될 알약 리스트
  int _currentPage = 0; // 현재 페이지
  bool _isLoading = false; // 로딩 여부
  bool _hasMoreData = true; // 더 불러올 데이터가 있는지 여부
  bool end = false; // 끝!
  bool isResult = false; // 검색 결과 유, 무

  // 초기 데이터 로드
  @override
  void initState() {
    super.initState();
    end = false;
    // @ 검색 결과가 null이 아닐때 분기?
    // _fetchPills();
    // 사용자가 스크롤을 끝까지 내렸을 때 추가 데이터를 로드
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent
          // &&
          // !_isLoading) {
          ) {
        print("###### 로딩 아이콘 end : $end");
        print("@@@@@@@@ Bottom reached");
        // 스크롤이 끝에 도달하고, 현재 데이터를 가져오고 있지 않은 경우 추가 데이터를 로드합니다.
        // if (_hasMoreData && !end) {
        if (_hasMoreData) {
          print("왜 돼? : $_hasMoreData");
          _isLoading = false;
          _fetchPills(showDialog: false); // 스크롤일때는 다이얼로그 안띄움
        }
        // _fetchPills();
      }
    });
  }

  // 검색어 초기화
  void _resetSearch() {
    setState(() {
      _currentPage = 1; // 현재 페이지를 1로 초기화
      _pills.clear(); // 화면에 표시될 알약 리스트를 비움
      _hasMoreData = true; // 더 불러올 데이터가 있다고 가정
      _searchSuccess = false; // 검색 성공 여부를 false로 초기화
      // end = true; // 끝 X
      isResult = false; // 검색 결과 유, 무
    });
  }

  // 로딩 다이얼로그
  Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 다른 곳을 터치해도 닫히지 않음
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Palette.WHITE_BLUE,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lotties/loading.json',
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.15,
                  height: MediaQuery.of(context).size.height * 0.10,
                  fit: BoxFit.fill,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                const Text(
                  "해당하는 약을 찾는 중 입니다..",
                  style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 알약 검색 api 호출
  Future<void> _fetchPills({bool showDialog = false}) async {
    // if (_isLoading) {
    //   print("isLoding이 true라서 안되네@@@");
    // }

    if (!_isLoading) {
      print("isLoding이 false라서 되네@@@");
      print("_hasMoreDate : $_hasMoreData");
    }
// 이미 데이터를 로딩 중인 경우 요청을 중복으로 보내지 X
    if (_hasMoreData) {
      print("데이터 로딩 중이라서 안되네@@@");
      setState(() {
        _isLoading = true;
      });

      if (showDialog) {
        // 로딩 다이얼로그 표시
        showLoadingDialog(context);
        print("로딩 다이얼로그 띄우기 : $showDialog");
      }

      // API 호출
      String yoyakURL = API.yoyakUrl; // 호스트 URL
      String modifiedUrl = yoyakURL.substring(8, yoyakURL.length - 4);

      String path = '/api/medicine/full-text'; // path
      // page를 나눠야?
      // final uri = Uri.https(modifiedUrl, path,
      //     {'keyword': _controller.text, 'page': _currentPage.toString()});
      final uri = Uri.https(modifiedUrl, path,
          {'keyword': _controller.text, 'page': _currentPage.toString()});
      print("page 어디로감 ... : $_currentPage");

      try {
        var response = await http.get(
          uri,
        );
        if (response.statusCode == 200) {
          var decodedBody = utf8.decode(response.bodyBytes);
          resultPills = jsonDecode(decodedBody);
          isResult = true;

          // // 로딩 다이얼로그 닫기
          if (showDialog) {
            // 로딩 다이얼로그 닫기
            Navigator.of(context).pop();
            print("로딩 다이얼로그 닫기?????????????");
          }

          // Pill 리스트 생성
          List<dynamic> pillsJson = resultPills["result"];
          // @@@ 뭐지? print
          // List<Pill> fetchedPills =
          //     pillsJson.map((json) => Pill.fromJson(json)).toList();
          List<dynamic> fetchedPills = pillsJson;

          print("텍스트 검색 api????? fetchedPills : $fetchedPills");
          print("얼른 되랏@@ : pillsJson : $pillsJson");

          // 마지막 처리
          if (fetchedPills.isEmpty) {
            setState(() {
              _hasMoreData = false;
              end = true;
            });
            print("@@@@@@끝@@@@@@");
            print(_hasMoreData);
            print("제발 끝: $end");
            return;
          }

          if (fetchedPills.length < 10) {
            setState(() {
              // _hasMoreData = false;
              end = true;
              _currentPage++;
              _searchSuccess = true;
              // 화면에 보여질 데이터 추가
              _pills.addAll(fetchedPills);
            });
            print("@@@@@@끝@@@@@@");
            return;
          }

          setState(() async {
            _currentPage++;
            _searchSuccess = true;
            // 화면에 보여질 데이터 추가
            _pills.addAll(fetchedPills);
            _isLoading = false;
            _hasMoreData = fetchedPills.isNotEmpty; // 더 불러올 데이터가 있는지 여부
            end = fetchedPills.length < 10; // 마지막 페이지인지 확인
            isResult =
                _pills.isNotEmpty || fetchedPills.isEmpty; // 검색 결과 유무 업데이트

            // end = false;
          });

          print("텍스트 검색????? :  $_pills");

          print("알약 검색 성공 $data");
          print("총 ${fetchedPills.length}개의 알약 검색 성공");
          print(
              "isLoding : $_isLoading, _hasMoreData : $_hasMoreData, _currentPage : $_currentPage");
        } else {
          print("알약 검색 실패");
        }
      } catch (e) {
        print("알약 검색 실패 에러 $e");
      } finally {
        setState(() {
          _isLoading = false;
          _hasMoreData = true;
        });
        print("@@@ 보여줄 데이터 끝!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 검색 결과 유, 무
    // bool isResult = data["result"] != null && data["result"].length > 0;
    // bool isResult = _pills.isNotEmpty;
    print("isResult : $isResult");

    return Scaffold(
      appBar: AppBar(
        title: const Text('약 검색',
            style: TextStyle(
              color: Palette.MAIN_BLACK,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              fontSize: 16,
            )),
        backgroundColor: Palette.MAIN_WHITE,
        centerTitle: true,
        toolbarHeight: 55,
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: Palette.BG_BLUE,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.06,
          vertical: MediaQuery.of(context).size.height * 0.04,
        ),
        // @@ 싱글컨트롤?
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Container(
                    // padding: const EdgeInsets.only(left: 7),
                    child: const Text(
                      "텍스트로 약 검색",
                      style: TextStyle(
                          color: Palette.MAIN_BLACK,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          fontSize: 24),
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
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 0.1,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Palette.SHADOW_GREY,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: TextField(
                  controller: _controller,
                  cursorColor: Palette.MAIN_BLUE,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 11,
                    ),
                    border: InputBorder.none,
                    hintText: '약 이름, 성분, 증상을 입력해주세요',
                    filled: true,
                    fillColor: Palette.MAIN_WHITE,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: const TextStyle(
                      color: Palette.SUB_BLACK,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Palette.MAIN_BLUE,
                      size: MediaQuery.of(context).size.width * 0.075,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Palette.SUB_BLACK,
                        size: MediaQuery.of(context).size.width * 0.065,
                      ),
                      onPressed: () {
                        _controller.clear();
                        _resetSearch(); // 검색 결과 초기화
                      },
                    ),
                  ),
                  // api get
                  // 검색하기
                  onSubmitted: (value) async {
                    print('검색어 = $value');
                    _resetSearch(); // 검색 결과 초기화
                    _fetchPills(showDialog: true); // 검색을 할 때 다이얼로그 출력
                  },
                ),
              ),
            ),
            // 로딩 다이얼로그 닫기
            // Navigator.of(context).pop();

            // 검색 성공 시 "검색 결과"가 나옴(조건부 렌더링)
            if (isResult)
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
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
                              "총 ${resultPills["count"] ?? 0}개",
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
                      Column(
                        children: resultPills["count"] != 0
                            ? _pills.map<Widget>((pill) {
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
                            // ? [
                            //     Expanded(
                            //       child: ListView.builder(
                            //         controller: _scrollController, // 스크롤 이벤트 감지
                            //         itemCount: _pills.length +
                            //             (_isLoading ? 1 : 0), // 로딩 인디케이터를 위한 공간
                            //         itemBuilder: (context, index) {
                            //           if (index == _pills.length) {
                            //             // 리스트 마지막에 로딩 인디케이터 표시
                            //             return _isLoading
                            //                 ? const Center(
                            //                     child:
                            //                         CircularProgressIndicator())
                            //                 : const SizedBox();
                            //           }
                            //           Pill pill = _pills[index];
                            //           return PillPreview(
                            //             imgPath: pill.imgPath,
                            //             itemName: pill.itemName!,
                            //             entpName: pill.entpName,
                            //             medicineSeq: pill.medicineSeq!,
                            //           );
                            //         },
                            //       ),
                            //     ),
                            //   ]

                            // PillPreviews 출력
                            : [
                                // 검색 결과 없음
                                Lottie.asset(
                                  'assets/lotties/no_search.json',
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * 0.750,
                                  height:
                                      MediaQuery.of(context).size.height * 0.40,
                                  // fit: BoxFit.fill,
                                ),
                                const Text(
                                  "검색 결과가 없습니다.",
                                  style: TextStyle(
                                    color: Palette.SUB_BLACK,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                      ),
                      if (isResult && _hasMoreData && !end)
                        // if (!end) //// 더 로드할 데이터가 있으면 로딩 인디케이터 표시
                        const Center(
                          child: CircularProgressIndicator(
                            color: Palette.MAIN_BLUE,
                          ),
                        )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
