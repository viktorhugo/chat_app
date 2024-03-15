import 'dart:convert';
import 'dart:io';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/users_message.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

enum WebSocketServerStatus  {
  online,
  offline,
  connecting,
  reconnecting
}

class WebSocketService with ChangeNotifier {

  WebSocketServerStatus _webSocketServerStatus = WebSocketServerStatus.connecting;

  List<User> users = [];

  late WebSocketChannel channel;

  WebSocketServerStatus get  serverStatus => _webSocketServerStatus;

  WebSocketService() {
    // init start connection
  }

  void startWSSConnection() async {

    if (_webSocketServerStatus == WebSocketServerStatus.online) return;
    
    final token = await AuthService.getToken();
    if (token.isEmpty) return;

    print('_startConnection WSS');
    // in test Ipconfig IP
    final wsUrl = Uri.parse(Environment.socketURL);
    // final wsUrl = Uri.parse('wss://bands-socket-server.onrender.com:8082');
    channel = IOWebSocketChannel.connect( wsUrl, headers: { 'x-token': token } );

    try {
      await channel.ready;
      print('Web Socket Server Connected to $wsUrl');
      _webSocketServerStatus = WebSocketServerStatus.online;
      notifyListeners();
    } on SocketException catch (e) {
      // Handle the exception.
      print('Error SocketException: ${e.message} - ( ${e.osError} )');
      _handleLostConnection();
      return;
    } on WebSocketChannelException catch (e) {
      // Handle the exception.
      print('Error WebSocketChannelException: ${e.message} ');
      return;
    }

    channel.stream.listen((message) {
        final Map<String, dynamic > messageDecode = jsonDecode(message);
        print(messageDecode['event']);
        if (messageDecode['event'] == 'get-all-users-connected') {
          users = (messageDecode['data'] as List)
            .map((band) => User.fromJson(band))
            .toList();
          print(users);
          notifyListeners();
        }
        if (messageDecode['event'] == 'add-vote-band') {

        }
        if (messageDecode['event'] == 'create-band') {

        }
        if (messageDecode['event'] == 'Delete-band') {

        }
        // channel.sink.add('received!');
        // channel.sink.close(status.goingAway);
        
      },onError: (e) {
        print(e); 
        _handleLostConnection();
      },
      onDone: (() {
        print('Error Web Socket Server DisConnected to $wsUrl');
        _handleLostConnection();
      })
    );
    
  }

  handleSendMessage( { required UsersRequestMessage data }) {
    // send Message
    channel.sink.add(
      jsonEncode(
        {
          "event": "user-message", 
          "data": {
            "from": data.from,
            "to": data.to,
            "message": data.message,
          }
        },
      ),
    );

  }

  void _handleLostConnection() {
    if (_webSocketServerStatus != WebSocketServerStatus.offline) {
      _webSocketServerStatus = WebSocketServerStatus.reconnecting;
      notifyListeners();
      Future.delayed(const Duration(seconds: 3), () {
        startWSSConnection();
      });
    }
  }

  void closeWSSConnection() {
    _webSocketServerStatus = WebSocketServerStatus.offline;
    channel.sink.close(status.goingAway);
    notifyListeners();
  }

}