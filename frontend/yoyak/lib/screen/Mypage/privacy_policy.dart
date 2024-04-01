import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yoyak/styles/colors/palette.dart';
import 'package:yoyak/styles/screenSize/screen_size.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.BG_BLUE,
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0.0,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Palette.MAIN_BLACK,
            size: 18,
          ),
        ),
        title: const Text(
          "개인정보 처리방침",
          style: TextStyle(
            color: Palette.MAIN_BLACK,
            fontSize: 16,
            fontFamily: "Pretendard",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 제목 및 서문
              SizedBox(
                width: ScreenSize.getWidth(context),
                child: const Center(
                  child: Text(
                    "<요약> 개인정보 처리방침",
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 23,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                '  <요약>은 정보주체의 자유와 권리 보호를 위해 「개인정보 보호법」 및 관계 법령이 정한바를 준수하여, 적법하게 개인정보를 처리하고 안전하게 관리하고 있습니다. 이에 「개인정보 보호법」제30조에 따라 정보주체에게 개인정보 처리에 관한 절차 및 기준을 안내하고, 이와 관련한 고충을신속하고 원활하게 처리할 수 있도록 하기 위하여 다음과 같이 개인정보 처리방침을 수립·공개합니다.',
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              // 개인정보의 처리 목적
              SizedBox(
                width: ScreenSize.getWidth(context),
                child: const Center(
                  child: Text(
                    "개인정보의 처리목적",
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Pretendard",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                "  <요약>은 다음의 목적을 위하여 개인정보를 처리합니다. 처리하고 있는 개인정보는다음의 목적 이외의 용도로는 이용되지 않으며, 이용 목적이 변경되는 경우에는 「개인정보 보호법」제18조에 따라 별도의 동의를 받는 등 필요한 조치를 이행할 예정입니다. ",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const SizedBox(
                child: Text(
                  "  - 회원 가입 및 관리 : 회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용방지, 만 14세 미만 아동의 개인정보 처리 시 법정대리인의 동의여부 확인, 각종 고지·통지, 고충처리목적으로 개인정보를 처리합니다. ",
                  style: TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Pretendard",
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: '앱에서 사용하는 제3자 서비스 제공업체의 개인정보 보호정책 ',
                      style: TextStyle(
                        color: Palette.MAIN_BLACK,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Pretendard",
                      ),
                    ),
                    TextSpan(
                      text: '링크',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Pretendard",
                        color: Palette.MAIN_BLUE, // 하이퍼링크 색상
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final url = Uri.parse(
                              'https://www.google.com/policies/privacy/');
                          if (await canLaunchUrl(url)) {
                            launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          }
                        },
                    ),
                  ],
                ),
              ),
              //로그 데이터
              const SizedBox(
                height: 14,
              ),
              //정보 수집 및 사용
              const SizedBox(
                width: 400,
                child: Center(
                  child: Text(
                    "개인 정보의 처리 및 보유 기간",
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Pretendard",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                "   ① <요약>은 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의 받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다. ",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   ② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   1. 홈페이지 회원 가입 및 관리 : 사업자/단체 홈페이지 탈퇴 시까지",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   다만, 다음의 사유에 해당하는 경우에는 해당 사유 종료 시까지 ",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   1) 관계 법령 위반에 따른 수사·조사 등이 진행 중인 경우에는 해당 수사·조사 종료 시까지",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   2) 홈페이지 이용에 따른 채권·채무관계 잔존 시에는 해당 채권·채무관계 정산 시까지",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   3) <예외 사유> 시에는 1년까지",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),

              const SizedBox(
                height: 14,
              ),
              //쿠키
              const SizedBox(
                width: 400,
                child: Center(
                  child: Text(
                    "처리하는 개인정보의 항목",
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Pretendard",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                "   <요약>은 다음의 개인정보 항목을 처리하고 있습니다.",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   1. 회원 가입 및 관리",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   - 필수항목 : 이메일, 비밀번호, 닉네임, 생년월일, 성별",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   - 선택항목 : 주요증상",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              // 개인정보의 파기 절차 및 방법에 관한 사항
              const SizedBox(
                width: 400,
                child: Center(
                  child: Text(
                    "개인정보의 파기 절차 및 방법",
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Pretendard",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                "   <요약>은 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체 없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   - 파기절차",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   <요약>은 파기 사유가 발생한 개인정보를 선정하고, <요약>의 개인정보 보호책임자의 승인을 받아 개인정보를 파기합니다.",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   - 파기기한",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   <요약>은 개인정보의 처리목적 달성, 해당 서비스의 폐지, 사업 종료 등 그 개인정보가 불필요하게 되었을 때에는 지체 없이 파기합니다.",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   - 파기방법",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   <요약>은 전자적 파일 형태로 기록·저장된 개인정보는 기록을 재생할 수 없는 기술적 방법을 사용하여 파기하며, 종이 문서에 기록·저장된 개인정보는 분쇄기로 분쇄하거나 소각하여 파기합니다.",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              //개인정보의 안전성 확보 조치
              const SizedBox(
                width: 400,
                child: Center(
                  child: Text(
                    "개인정보의 안전성 확보 조치",
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Pretendard",
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 14,
              ),
              const Text(
                "   <요약>은 개인정보의 안전성 확보를 위해 다음과 같은 조치를 취하고 있습니다.",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   1. 관리적 조치 : 내부관리계획 수립·시행, 정기적 직원 교육 등",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   2. 기술적 조치 : 개인정보처리시스템 접근권한 관리, 접근통제시스템 설치, 비인가자에 대한 접근 통제 등",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   3. 물리적 조치 : 전산실, 자료보관실 등의 접근통제",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const SizedBox(
                height: 14,
              ),

              //개인정보 보호책임자
              const SizedBox(
                width: 400,
                child: Center(
                  child: Text(
                    "개인정보 보호책임자",
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Pretendard",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                "   <요약>은 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만 처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   ▶ 개인정보 보호책임자",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   성명 : 오지훈",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   직책 : 개발자",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   연락처 : 010-2575-2397",
                style: TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Pretendard"),
              ),
              const Text(
                "   이메일 : gfsd2397@gmail.com",
                style: TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Pretendard"),
              ),
              const Text(
                '② 정보주체는 <요약>의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보보호관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의할 수있습니다. <요약> 은 정보주체의 문의에 대해 지체없이 답변 및 처리해드릴 것입니다.',
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              // 권익침해 구제방법
              const SizedBox(
                width: 400,
                child: Center(
                  child: Text(
                    "권익침해 구제방법",
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Pretendard",
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              const Text(
                "   정보주체는 개인정보침해에 대한 피해구제를 받기 위하여 개인정보분쟁조정위원회, 한국인터넷진흥원 개인정보침해신고센터 등에 분쟁해결이나 상담 등을 신청할 수 있습니다. 아래는 개인정보분쟁조정위원회의 연락처입니다.",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   1. 개인정보분쟁조정위원회 : (국번없이) 1833-6972 (www.kopico.go.kr)",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   2. 개인정보침해신고센터 : (국번없이) 118 (privacy.kisa.or.kr)",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   3. 대검찰청 : (국번없이) 1301 (www.spo.go.kr)",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   4. 경찰청 : (국번없이) 182 (ecrm.cyber.go.kr) ",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                '② <개인정보처리자명>은(는) 정보주체의 개인정보자기결정권을 보장하고, 개인정보침해로 인한상담 및 피해 구제를 위해 노력하고 있으며, 신고나 상담이 필요한 경우 아래의 담당부서로 연락해주시기 바랍니다.',
                style: TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Pretendard"),
              ),
              const Text(
                "   ‣ 개인정보보호 관련 고객 상담 및 신고 ",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   담당자 : 김성현",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   연락처 : 010-2717-6906",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const SizedBox(
                height: 14,
              ),

              //개인정보 처리방침 변경
              const SizedBox(
                width: 400,
                child: Center(
                  child: Text(
                    "개인정보 처리방침 변경",
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 22,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Pretendard",
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              const Text(
                "   ① 이 개인정보 처리방침은 2024년 4월 1일부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const Text(
                "   ② 이 개인정보 처리방침은 2024년 4월 1일부터 시행됩니다.",
                style: TextStyle(
                  color: Palette.MAIN_BLACK,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Pretendard",
                ),
              ),
              const SizedBox(
                height: 14,
              ),

              //문의하기
              const SizedBox(
                width: 400,
                child: Center(
                  child: Text(
                    "문의하기",
                    style: TextStyle(
                      color: Palette.MAIN_BLACK,
                      fontSize: 25,
                      fontWeight: FontWeight.w400,
                      fontFamily: "Pretendard",
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                child: Text(
                  "   우리 개인정보 보호정책에 대해 질문이나 제안 사항이 있는 경우 주저하지 말고 yjw5602@naver.com으로 문의하십시오.",
                  style: TextStyle(
                    color: Palette.MAIN_BLACK,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Pretendard",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
