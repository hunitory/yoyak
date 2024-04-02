import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:yoyak/components/base_button.dart';
import 'package:yoyak/components/pill_description.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import 'package:yoyak/screen/Search/pill_bag_modal.dart';
import 'package:yoyak/store/login_store.dart';
import 'package:yoyak/store/pill_bag_store.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';
import '../../styles/colors/palette.dart';

class PillDetailScreen extends StatefulWidget {
  final Map<String, dynamic> medicineInfo;

  const PillDetailScreen({
    super.key,
    required this.medicineInfo,
  });

  @override
  State<PillDetailScreen> createState() => _PillDetailScreenState();
}

class _PillDetailScreenState extends State<PillDetailScreen> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> Logined = context.watch<LoginStore>().accountList;
    if (Logined.isNotEmpty) {
      context.read<PillBagStore>().getPillBagDatas(
            context,
            medicineSeq: widget.medicineInfo["medicineSeq"]!,
          );
    }

    // medicineSeq를 이용해서 DB에서 알약 정보를 가져오기
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Palette.BG_BLUE,
        appBar: AppBar(
          title: const Text(
            '알약 상세 정보',
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
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            child: Column(children: [
              // 알약 카드
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 20,
                ),
                child: RoundedRectangle(
                  width: double.infinity,
                  height: Logined.isNotEmpty
                      ? MediaQuery.of(context).size.width * 0.90
                      : MediaQuery.of(context).size.width * 0.80,
                  boxShadow: const [
                    BoxShadow(
                      color: Palette.SHADOW_GREY,
                      blurRadius: 3,
                      offset: Offset(0, 2),
                    )
                  ],
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.08,
                      ),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(17),
                          child: widget.medicineInfo["imagePath"] != null
                              ? Image.network(
                                  widget.medicineInfo["imagePath"],
                                  width:
                                      MediaQuery.of(context).size.width * 0.60,
                                  height:
                                      MediaQuery.of(context).size.width * 0.30,
                                  fit: BoxFit.cover, // 모서리 각진거 이걸로 해결
                                )
                              : Image.asset(
                                  'assets/images/pillbox.jpg',
                                  width:
                                      MediaQuery.of(context).size.width * 0.60,
                                  height:
                                      MediaQuery.of(context).size.width * 0.30,
                                  fit: BoxFit.cover,
                                )),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.07,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 35),
                        child: Text(
                          widget.medicineInfo["itemName"],
                          style: const TextStyle(
                            color: Palette.MAIN_BLACK,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Text(
                        widget.medicineInfo["entpName"],
                        style: const TextStyle(
                          color: Palette.SUB_BLACK,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.07,
                      ),
                      // 저장하기 버튼
                      // 로그인 안됐을 때는 로그인 창으로 이동
                      if (Logined.isNotEmpty)
                        BaseButton(
                          onPressed: () {
                            // 약 봉투 api get 요청
                            // context.read<PillBagStore>().getPillBagDatas(
                            //       context,
                            //       widget.medicineInfo["medicineSeq"]!,
                            //     );
                            // 약 봉투 모달창 띄우기
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  var screenHigh =
                                      ScreenSize.getHeight(context);
                                  return StatefulBuilder(builder:
                                      (BuildContext context,
                                          StateSetter setState) {
                                    return PillBagModal(
                                        sceenHeight: screenHigh,
                                        medicineSeq:
                                            widget.medicineInfo["medicineSeq"]);
                                  });
                                });
                          },
                          text: "저장하기",
                          colorMode: "blue",
                          width: 104,
                          height: 35,
                        )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              // 약 정보, 주의사항 탭
              const TabBar(
                tabs: [
                  Tab(
                    text: "약 정보",
                  ),
                  Tab(
                    text: "주의사항",
                  ),
                ],
                dividerColor: Palette.SHADOW_GREY,
                indicatorColor: Palette.MAIN_BLUE,
                unselectedLabelColor: Palette.SUB_BLACK,
                labelColor: Palette.MAIN_BLUE,
                overlayColor: MaterialStatePropertyAll(
                    Palette.BG_BLUE), // 탭 바 클릭 시 나오는 splash 컬러
              ),
              // TabBarView
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                height: MediaQuery.of(context).size.width *
                    1.3, // 컨텐츠에 FIT하게 바꿀 수 있나..
                child: TabBarView(
                  children: [
                    // 약 정보
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 요약
                          if (widget.medicineInfo["summary"] != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 13, top: 10, bottom: 10),
                              child: Container(
                                padding: const EdgeInsets.only(
                                  right: 10,
                                  top: 8,
                                  bottom: 8,
                                ),
                                width: MediaQuery.of(context).size.width * 0.9,
                                // height: 40,
                                decoration: BoxDecoration(
                                  color: Palette.MAIN_BLUE,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    // 사진 너무 작아.. 그냥 원래 사진 파일을 좀 더 크게 가져와야하나?
                                    Image.asset(
                                      "assets/images/logo.png",
                                      // scale: 1.7,
                                      width: 33,
                                      height: 25,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Text(
                                        widget.medicineInfo["summary"]!,
                                        style: const TextStyle(
                                          color: Palette.MAIN_WHITE,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                        softWrap: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          // 효능효과 분기
                          if (widget.medicineInfo["efficacy"] != null)
                            PillDescription(
                              title: "효능효과",
                              description: widget.medicineInfo["efficacy"],
                            ),
                          if (widget.medicineInfo["useMethod"] != null)
                            PillDescription(
                              title: "사용 방법",
                              description: widget.medicineInfo["useMethod"],
                            ),
                          if (widget.medicineInfo["depositMethod"] != null)
                            PillDescription(
                              title: "보관 방법",
                              description: widget.medicineInfo["depositMethod"],
                            ),
                        ],
                      ),
                    ),
                    // 주의사항
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 주의 키워드 바
                          if (widget.medicineInfo["keyword"] != null)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 13, top: 10, bottom: 10),
                              child: RoundedRectangle(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 40,
                                color: Palette.MAIN_BLUE,
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Image.asset(
                                      "assets/images/light.png",
                                      width: 30,
                                      height: 25,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    // API로 데이터 받기
                                    Text(
                                      widget.medicineInfo["keyword"]!,
                                      style: const TextStyle(
                                        color: Palette.MAIN_WHITE,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ), // 효능효과 분기
                          if (widget.medicineInfo["atpnWarn"] != null)
                            PillDescription(
                              title: "경과",
                              description: widget.medicineInfo["atpnWarn"],
                            ),
                          if (widget.medicineInfo["atpn"] != null)
                            PillDescription(
                              title: "주의 사항",
                              description: widget.medicineInfo["atpn"],
                            ),
                          if (widget.medicineInfo["sideEffect"] != null)
                            PillDescription(
                              title: "부작용",
                              description: widget.medicineInfo["sideEffect"],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
