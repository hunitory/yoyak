import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SingletonSecureStorage {
  static final SingletonSecureStorage _singleton = SingletonSecureStorage._internal();

  late FlutterSecureStorage storage;  // 'late' 키워드를 추가하여 나중에 초기화됨을 명시

  factory SingletonSecureStorage() {
    return _singleton;
  }

  SingletonSecureStorage._internal() {
    storage = FlutterSecureStorage();
  }
}