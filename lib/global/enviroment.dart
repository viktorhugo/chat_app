import 'dart:io';

class Environment {
  static String Ip = '192.168.1.5';
  static String apiURL = Platform.isAndroid ? 'http://10.10.2.2:3000' : 'http://$Ip:3000';
  static String socketURL = 'ws://$Ip:8082';
}