import 'package:flutter_dotenv/flutter_dotenv.dart';

class API {
  static String yoyakUrl = dotenv.get('Yoyak_URL');
}