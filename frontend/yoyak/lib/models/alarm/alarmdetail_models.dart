class AlarmDetailModel {
  int? accountSeq;
  int? notiSeq;
  String? name;
  String? startDate;
  String? endDate;
  List<String>? period;
  List<String>? time;

  AlarmDetailModel(
      {this.accountSeq,
      this.notiSeq,
      this.name,
      this.startDate,
      this.endDate,
      this.period,
      this.time});

  AlarmDetailModel.fromJson(Map<String, dynamic> json) {
    accountSeq = json['accountSeq'];
    notiSeq = json['notiSeq'];
    name = json['name'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    period = json['period'].cast<String>();
    time = json['time'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['accountSeq'] = accountSeq;
    data['notiSeq'] = notiSeq;
    data['name'] = name;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['period'] = period;
    data['time'] = time;
    return data;
  }
}
