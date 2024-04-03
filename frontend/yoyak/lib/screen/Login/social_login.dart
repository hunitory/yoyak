// 카카오 Api로 할 수 있는 메소드를 구현하기 위한 추상 클래스
abstract class SocialLogin {
  Future<bool> login(); // 로그인
  Future<bool> logout(); // 로그아웃
}
