import 'dart:io';

class Environment {
  static String apiURL = Platform.isAndroid ? 'http://10.10.2.2:3000' : 'http://192.168.1.5:3000';
  static String socketURL = 'ws://192.168.1.5:8082';
}