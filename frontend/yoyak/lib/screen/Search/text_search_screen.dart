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
  final _controller = TextEditingController(); // 검색어 초기화
  final ScrollController _scrollController =
      ScrollController(); // 스크롤 이벤트 감지(무한스크롤)
  final List<Pill> _pills = []; // 알약 데이터 저장 리스트
  int _currentPage = 1; // 현재 페이지
  bool _isLoading = false; // 로딩 여부

  @override
  void initState() {
    super.initState();
    // 초기 데이터 로드
    _fetchPills();
    // 사용자가 스크롤을 끝까지 내렸을 때 추가 데이터를 로드
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoading) {
        // 스크롤이 끝에 도달하고, 현재 데이터를 가져오고 있지 않은 경우 추가 데이터를 로드합니다.
        _fetchPills();
      }
    });
  }

  Future<void> _fetchPills() async {
    if (_isLoading) return; // 이미 데이터를 로딩 중인 경우 요청을 중복으로 보내지 않도록 합니다.
    setState(() {
      _isLoading = true;
    });
    String yoyakURL = API.yoyakUrl; // 호스트 URL
    String modifiedUrl = yoyakURL.substring(8, yoyakURL.length - 4);

    String path = '/api/medicine/full-text'; // path
    // page를 나눠야?
    // final uri = Uri.https(modifiedUrl, path,
    //     {'keyword': _controller.text, 'page': _currentPage.toString()});
    final uri = Uri.https("192.168.31.30:8080", "/api/medicine/full-text",
        {'keyword': _controller.text, 'page': _currentPage.toString()});

    try {
      var response = await http.get(
        uri,
      );
      if (response.statusCode == 200) {
        var decodedBody = utf8.decode(response.bodyBytes);

        // Pill 리스트 생성
        List<dynamic> pillsJson = json.decode(decodedBody)["result"];
        List<Pill> fetchedPills =
            pillsJson.map((json) => Pill.fromJson(json)).toList();

        setState(() {
          _currentPage++;
          _searchSuccess = true;
          // 데이터 추가
          _pills.addAll(fetchedPills);
        });

        print("알약 검색 성공 $data");
        print("총 ${fetchedPills.length}개의 알약 검색 성공");
      } else {
        print("알약 검색 실패");
      }
    } catch (e) {
      print("알약 검색 실패 에러 $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 검색 결과 유, 무
    // bool isResult = data["result"] != null && data["result"].length > 0;
    bool isResult = _pills.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('알약 검색',
            style: TextStyle(
              color: Palette.MAIN_BLACK,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
              fontSize: 15,
            )),
        backgroundColor: Palette.BG_BLUE,
        centerTitle: true,
        toolbarHeight: 55,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          // singleScrollView 되나? height 때문에..
          height: MediaQuery.of(context).size.height,
          color: Palette.BG_BLUE,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.06,
            vertical: MediaQuery.of(context).size.height * 0.04,
          ),
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
                        "텍스트로 알약 검색",
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
                      hintText: '알약 이름, 성분, 증상을 입력해주세요',
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
                          // 검색 결과 초기화
                          // setState(() {
                          //   _searchSuccess = false;
                          // });
                          _controller.clear();
                        },
                      ),
                    ),
                    // api get
                    onSubmitted: (value) {
                      print('검색어 = $value');
                      _fetchPills();
                    },
                  ),
                ),
              ),
              // 검색 성공 시 검색 결과가 나옴(조건부 렌더링)
              if (_searchSuccess)
                Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
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
                            "총 ${data["count"] ?? 0}개",
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
                      children: isResult
                          // ? data["result"].map<Widget>((pill) {
                          //     var imgPath = pill["imgPath"];
                          //     var itemName = pill["itemName"];
                          //     var entpName = pill["entpName"];
                          //     var medicineSeq = pill["medicineSeq"];
                          //     return PillPreview(
                          //         imgPath: imgPath,
                          //         itemName: itemName,
                          //         entpName: entpName,
                          //         medicineSeq: medicineSeq);
                          //   }).toList()
                          ? [
                              Expanded(
                                child: ListView.builder(
                                  controller: _scrollController, // 스크롤 이벤트 감지
                                  itemCount: _pills.length +
                                      (_isLoading ? 1 : 0), // 로딩 인디케이터를 위한 공간
                                  itemBuilder: (context, index) {
                                    if (index == _pills.length) {
                                      // 리스트 마지막에 로딩 인디케이터 표시
                                      return _isLoading
                                          ? const Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : const SizedBox();
                                    }
                                    Pill pill = _pills[index];
                                    return PillPreview(
                                      imgPath: pill.imgPath,
                                      itemName: pill.itemName!,
                                      entpName: pill.entpName,
                                      medicineSeq: pill.medicineSeq!,
                                    );
                                  },
                                ),
                              ),
                            ]

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
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
