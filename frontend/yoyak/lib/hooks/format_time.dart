String formatTime(DateTime time) {
  String period = time.hour < 12 ? '오전' : '오후';
  int hour = time.hour;

  // 오전 12:00 (자정)과 오후 12:00 (정오) 처리
  if (time.hour == 0 || time.hour == 12) {
    period = time.hour == 0 ? '오전' : '오후';
    hour = 12; // 0시와 12시는 모두 12시로 표시
  } else {
    period = time.hour < 12 ? '오전' : '오후';
    hour = time.hour % 12;
  }
  String minute = time.minute.toString().padLeft(2, '0');
  return '$period $hour:$minute';
}


