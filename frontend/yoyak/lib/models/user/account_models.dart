class AccountModel {
  int? seq;
  String? nickname;
  String? gender;
  String? birth;
  String? disease;
  int? profileImg;

  AccountModel({
    this.seq,
    this.nickname = '',
    this.gender = 'N',
    this.birth = '',
    this.disease = '',
    // 기본값 0으로 설정
    this.profileImg = 0,
  });

  AccountModel.fromJson(Map<String, dynamic> json) {
    seq = json['seq'];
    nickname = json['nickname'];
    gender = json['gender'];
    birth = json['birth'];
    disease = json['disease'];
    profileImg = json['profileImg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seq'] = seq;
    data['nickname'] = nickname;
    data['gender'] = gender;
    data['birth'] = birth;
    data['disease'] = disease;
    data['profileImg'] = profileImg;
    return data;
  }
}
