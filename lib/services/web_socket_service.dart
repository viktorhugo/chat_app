import 'dart:convert';
import 'dart:io';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';
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

  get serverStatus => _webSocketServerStatus;

  WebSocketService() {
    // init start connection
  }

  void startWSSConnection() async {
    print('_startConnection WSS');
    // in test Ipconfig IP
    final wsUrl = Uri.parse(Environment.socketURL);
    // final wsUrl = Uri.parse('wss://bands-socket-server.onrender.com:8082');
    channel = WebSocketChannel.connect(wsUrl);

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
        _webSocketServerStatus = WebSocketServerStatus.offline;
        notifyListeners();
        _handleLostConnection();
      })
    );
    
  }

  handleSendMessage(String event, data) {
    // send data.
    channel.sink.add(
      jsonEncode(
        {
          "event": event, 
          "data": data
        },
      ),
    );
  }

  void _handleLostConnection() {
    _webSocketServerStatus = WebSocketServerStatus.reconnecting;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      startWSSConnection();
    });
  }

  void closeWSSConnection() {
    channel.sink.close(status.goingAway);
    _webSocketServerStatus = WebSocketServerStatus.offline;
    notifyListeners();
  }

}