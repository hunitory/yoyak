class AlarmModel {
  int? accountSeq;
  int? notiTimeSeq;
  String? name;
  DateTime? time;
  String? taken;
  DateTime? takenTime;
  int? notiSeq;

  AlarmModel(
      {this.accountSeq,
      this.notiTimeSeq,
      this.name,
      this.time,
      this.taken,
      this.takenTime,
      this.notiSeq});

  AlarmModel.fromJson(Map<String, dynamic> json) {
    accountSeq = json['accountSeq'];
    notiTimeSeq = json['notiTimeSeq'];
    name = json['name'];
    time = json['time'] != null ? DateTime.parse(json['time']) : null;
    taken = json['taken'];
    takenTime =
        json['takenTime'] != null ? DateTime.parse(json['takenTime']) : null;
    notiSeq = json['notiSeq'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> alarm = <String, dynamic>{};
    alarm['accountSeq'] = accountSeq;
    alarm['notiTimeSeq'] = notiTimeSeq;
    alarm['name'] = name;
    alarm['time'] = time;
    alarm['taken'] = taken;
    alarm['takenTime'] = takenTime;
    alarm['notiSeq'] = notiSeq;
    return alarm;
  }
}
