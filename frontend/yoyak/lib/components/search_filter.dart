import 'package:flutter/material.dart';
import 'package:yoyak/components/rounded_rectangle.dart';
import '../styles/colors/palette.dart';

// Filter Container 모델
// widht, height 설정하기
class FilterContainer {
  final String? imagePath;
  final String text;

  FilterContainer({this.imagePath, required this.text});
}

// 제네릭타입 <T>
class FilterComponent extends StatefulWidget {
  final List<FilterContainer> options; // 선택 가능한 모든 옵션 리스트
  final FilterContainer selectedOption; // 현재 선택된 옵션
  final ValueChanged<FilterContainer>
      onSelectionChanged; // 선택이 변경될 때, 실행될 콜백 함수
  // final Widget Function(BuildContext, FilterContainer) buildOption; // 각 옵션을 어떻게 렌더링 할 지 결정하는 함수

  const FilterComponent({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelectionChanged,
    // required this.buildOption})
  });

  @override
  State<FilterComponent> createState() => _FilterComponentState();
}

class _FilterComponentState extends State<FilterComponent> {
  late FilterContainer selectedOption;
  // 화살표 자동 스크롤
  final ScrollController _scrollController = ScrollController();
  // 화살표 유무
  bool _showLeftArrow = false;
  bool _showRightArrow = true;

  @override
  void initState() {
    super.initState();
    // 초기 상태 설정, selectedOption을 위젯의 초기값으로 설정
    selectedOption = widget.selectedOption;
    _scrollController.addListener(_updateArrowsVisibility); // 스크롤이 양 끝에 도달했나 확인
    // 레이아웃이 구축된 후 _updateArrowsVisibility를 호출하여
    // 초기 화살표 상태를 정확하게 설정
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _updateArrowsVisibility());
  }

  // 화살표 스크롤
  @override
  void dispose() {
    _scrollController.removeListener(_updateArrowsVisibility);
    _scrollController.dispose(); // 컨트롤러를 꼭 정리.
    super.dispose();
  }

  // 스크롤 위치에 따라 화살표 표시 여부 업데이트
  void _updateArrowsVisibility() {
    setState(() {
      _showLeftArrow = _scrollController.offset > 10; // 양 끝에 도달했는지 확인하는 임의의 값
      // maxScrollExtent > viewportDimension : 뷰 포트보다 스크롤 할 수 있는 영역이 더 크다(스크롤 가능)
      // offset < maxScrollExtent : 사용자가 아직 끝까지 스크롤 하지 X
      _showRightArrow = _scrollController.position.maxScrollExtent >
              _scrollController.position.viewportDimension &&
          _scrollController.offset < _scrollController.position.maxScrollExtent;
    });
  }

  // 왼쪽 화살표를 누르면 _scrollLeft() 호출
  void _scrollLeft() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.offset;
      final scrollPosition = currentPosition - 250.0; // 화살표를 눌렀을 대 스크롤 하려는 픽셀 수
      _scrollController.animateTo(
        scrollPosition > 0 ? scrollPosition : 0,
        duration: const Duration(milliseconds: 250), // 움직이는 속도
        curve: Curves.easeIn,
      );
    }
  }

// 오른쪽 화살표를 누르면 _scrollRight() 호출
  void _scrollRight() {
    if (_scrollController.hasClients) {
      final currentPosition = _scrollController.offset;
      final maxScrollExtent = _scrollController.position.maxScrollExtent;
      final scrollPosition = currentPosition + 250.0; // 화살표를 눌렀을 대 스크롤 하려는 픽셀 수
      _scrollController.animateTo(
        scrollPosition < maxScrollExtent ? scrollPosition : maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeIn,
      );
    }
  }

  void _handleTap(FilterContainer option) {
    setState(() {
      // 선택된 옵션을 사용자가 탭한 옵션으로 변경
      selectedOption = option;
    });
    // 변경된 옵션을 부모 위젯에 알림
    // onSelectionChanged 콜백 함수를 호출하여 선택된 옵션을 전달(변경했어요!)
    widget.onSelectionChanged(option);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
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
              margin: EdgeInsets.only(
                left: _showLeftArrow ? 35 : 10,
                right: _showRightArrow ? 45 : 10,
              ),
              child: ListView.builder(
                controller: _scrollController,
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
                            : Colors.white,
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

                          if (option.text == '모양 전체')
                            Column(
                              children: [
                                Text(
                                  '모양',
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

                          if (option.text == '색상 전체')
                            Column(
                              children: [
                                Text(
                                  '색상',
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

            // 화살표 고정 & 속성
            if (_showLeftArrow)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  color: Palette.SHADOW_GREY,
                  onPressed: _scrollLeft,
                ),
              ),
            if (_showRightArrow)
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  color: Palette.SHADOW_GREY,
                  onPressed: _scrollRight,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
