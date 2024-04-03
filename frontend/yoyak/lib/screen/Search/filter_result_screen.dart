import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:yoyak/components/pill_preview.dart';
import '../../styles/colors/palette.dart';

class FilterResult extends StatefulWidget {
  final Map<String, dynamic> data;

  const FilterResult({super.key, required this.data});

  @override
  State<FilterResult> createState() => _FilterResultState();
}

class _FilterResultState extends State<FilterResult> {
  final ScrollController _scrollController = ScrollController(); //  스크롤 위치 감지
  final List<dynamic> _displayedDataList = []; // 화면에 표시될 알약 리스트
  int _currentPage = 0; // 현재 페이지
  final int _perPage = 20; // 한 페이지에 표시될 알약 수
  bool _hasMoreData = true; // 더 불러올 데이터가 있는지 여부

  // 초기 데이터 로드
  @override
  void initState() {
    super.initState();
    if (widget.data["result"] != null) {
      _loadMoreData(); // 초기 데이터 로드
    }
    // 스크롤 이벤트 리스너 추가: 사용자가 리스트의 끝에 도달하면 추가 데이터 로드
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("끝까지 왔다.");
        _loadMoreData();
      }
    });
  }

  void _loadMoreData() {
    // 추가 데이터 로드
    if (_hasMoreData) {
      int startIndex = _currentPage * _perPage; // 시작 인덱스
      int endIndex =
          min(startIndex + _perPage, widget.data["result"].length); // 종료 인덱스
      List<dynamic> newDataList =
          widget.data["result"].sublist(startIndex, endIndex); // 추가 데이터

      setState(() {
        _displayedDataList.addAll(newDataList); // 화면에 표시될 데이터 리스트에 추가
        _currentPage++; // 페이지 번호 증가
      });

      if (endIndex == widget.data['result'].length) {
        // 모든 데이터를 로드했는지 확인(종료 인덱스 == 데이터 길이)
        _hasMoreData = false; // 더 이상 로드할 데이터가 없음
      }
    }
  }

  // data가 알약 데이터
  @override
  Widget build(BuildContext context) {
    // 검색 결과가 없을 때, 있을 때 분기
    bool isResult =
        widget.data["result"] != null && widget.data["result"].length > 0;
    print(isResult);

    // PillPreview 위젯 생성
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
        controller: _scrollController,
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
                      child: const Text(
                        "필터로 약 검색",
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
                        "총 ${widget.data["count"] ?? 0}개",
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
                      ? _displayedDataList.map<Widget>((pill) {
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
                if (isResult && _hasMoreData) // 더 로드할 데이터가 있으면 로딩 인디케이터 표시
                  const Center(
                    child: CircularProgressIndicator(
                      color: Palette.MAIN_BLUE,
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
