import 'dart:io';

class Environment {
  static String apiUrl =
      Platform.isAndroid ? '192.168.100.3:3000' : 'localhost:3000';

  static String socketUrl = Platform.isAndroid
      ? 'http://192.168.100.3:3000'
      : 'http://localhost:3000';
}
