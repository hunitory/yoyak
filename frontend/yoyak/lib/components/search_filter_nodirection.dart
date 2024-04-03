import 'package:flutter/material.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import '../styles/colors/palette.dart';

// Filter Container 모델
// widht, height 설정하기
class FilterContainerNoDi {
  final String? imagePath;
  final String text;

  FilterContainerNoDi({this.imagePath, required this.text});
}

// 제네릭타입 <T>
class FilterComponentNoDi extends StatefulWidget {
  final List<FilterContainerNoDi> options; // 선택 가능한 모든 옵션 리스트
  final FilterContainerNoDi selectedOption; // 현재 선택된 옵션
  final ValueChanged<FilterContainerNoDi>
      onSelectionChanged; // 선택이 변경될 때, 실행될 콜백 함수
  // final Widget Function(BuildContext, FilterContainer) buildOption; // 각 옵션을 어떻게 렌더링 할 지 결정하는 함수

  const FilterComponentNoDi({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelectionChanged,
    // required this.buildOption})
  });

  @override
  State<FilterComponentNoDi> createState() => _FilterComponentState();
}

class _FilterComponentState extends State<FilterComponentNoDi> {
  late FilterContainerNoDi selectedOption;

  @override
  void initState() {
    super.initState();
    // 초기 상태 설정, selectedOption을 위젯의 초기값으로 설정
    selectedOption = widget.selectedOption;
    // 레이아웃이 구축된 후 _updateArrowsVisibility를 호출하여
    // 초기 화살표 상태를 정확하게 설정
  }

  void _handleTap(FilterContainerNoDi option) {
    setState(() {
      // 선택된 옵션을 사용자가 탭한 옵션으로 변경
      selectedOption = option;
    });
    // 변경된 옵션을 부모 위젯에 알림
    widget.onSelectionChanged(option);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: RoundedRectangle(
        width: MediaQuery.of(context).size.width * 0.90,
        height: MediaQuery.of(context).size.width * 0.25,
        boxShadow: const [
          BoxShadow(
            color: Palette.SHADOW_GREY,
            blurRadius: 3,
            offset: Offset(0, 2),
          )
        ],
        child: Stack(
          children: [
            Container(
              // 0.6을 곱하면 3개만
              width: MediaQuery.of(context).size.width * 0.80,
              margin: const EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.options.length,
                itemBuilder: (BuildContext context, int index) {
                  final option = widget.options[index];
                  // bool isSelected = selectedOption == option;

                  // 이미지가 없을 때(ex. 모양 전체)
                  Widget imageWidget = option.imagePath != null
                      ? Image(
                          image: AssetImage(option.imagePath!),
                          width: MediaQuery.of(context).size.width * 0.06,
                          height: 30,
                        )
                      : const SizedBox();

                  return GestureDetector(
                    onTap: () => _handleTap(widget.options[index]),
                    // 옵션 하나의 컨테이너
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 2,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3,
                      ),
                      width: MediaQuery.of(context).size.width * 0.16,
                      decoration: BoxDecoration(
                        // 현재 선택된 옵션이면 배경을 파란색.
                        color: selectedOption == widget.options[index]
                            ? Palette.BG_BLUE
                            : Palette.MAIN_WHITE,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // const SizedBox(
                          //     // height: 5,
                          //     ),
                          // 이미지가 있을 때
                          if (option.imagePath != null) imageWidget,
                          if (option.imagePath != null)
                            const SizedBox(height: 3),

                          if (option.text == '제형 전체')
                            Column(
                              children: [
                                Text(
                                  '제형',
                                  style: TextStyle(
                                    color:
                                        selectedOption == widget.options[index]
                                            ? Palette.MAIN_BLUE
                                            : Palette.MAIN_BLACK,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                                Text(
                                  '전체',
                                  style: TextStyle(
                                    color:
                                        selectedOption == widget.options[index]
                                            ? Palette.MAIN_BLUE
                                            : Palette.MAIN_BLACK,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              ],
                            ),

                          if (option.text == '분할선 전체')
                            Column(
                              children: [
                                Text(
                                  '분할선',
                                  style: TextStyle(
                                    color:
                                        selectedOption == widget.options[index]
                                            ? Palette.MAIN_BLUE
                                            : Palette.MAIN_BLACK,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                                Text(
                                  '전체',
                                  style: TextStyle(
                                    color:
                                        selectedOption == widget.options[index]
                                            ? Palette.MAIN_BLUE
                                            : Palette.MAIN_BLACK,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: 'Pretendard',
                                  ),
                                ),
                              ],
                            ),

                          if (option.imagePath != null)
                            Text(
                              option.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                  color: selectedOption == widget.options[index]
                                      ? Palette.MAIN_BLUE
                                      : Palette.MAIN_BLACK),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
