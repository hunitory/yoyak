"use client";
import * as styled from './_style'

export default function downloadButton() {
    const apkDownloadUrl = "/apk/yoyak1.0.apk"; // 'path_to_your_apk_file.apk'를 실제 파일 경로로 바꿔주세요.

    // 버튼 클릭 이벤트 핸들러
    const handleClick = () => {
      window.location.href = apkDownloadUrl;
    };


  return (
    <styled.Button onClick={handleClick}>
      <styled.ButtonText>다운로드 받기</styled.ButtonText>
    </styled.Button>
  );
}
