import 'dart:convert';
import 'dart:io';

import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/users_message.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

enum WebSocketServerStatus  {
  online,
  offline,
  connecting,
  reconnecting
}

class WebSocketServerState {

  final WebSocketServerStatus webSocketServerStatus;
  List<User>? users = [];
  final IOWebSocketChannel? channel;
  // WebSocketServerStatus get  serverStatus => webSocketServerStatus;

  WebSocketServerState({
    this.webSocketServerStatus = WebSocketServerStatus.offline, 
    this.users, 
    this.channel
  });

  WebSocketServerState copyWith({
    WebSocketServerStatus? webSocketServerStatus,
    List<User>? users,
    IOWebSocketChannel? channel
  }) => WebSocketServerState(
    webSocketServerStatus: webSocketServerStatus ?? this.webSocketServerStatus,
    users: users ?? this.users,
    channel: channel ?? this.channel
  );
}


class WebSocketServerNotifier extends StateNotifier<WebSocketServerState> {

  WebSocketServerNotifier() : super(
    WebSocketServerState() //* CREATION INITIAL STATE
  );

  void startWSSConnection() async {

    final token = await AuthService.getToken();

    if (state.webSocketServerStatus == WebSocketServerStatus.online) return;
    
    if (token.isEmpty) return;

    print('_startConnection WSS');
    // in test Ipconfig IP
    final wsUrl = Uri.parse(Environment.socketURL);
    // final wsUrl = Uri.parse('wss://bands-socket-server.onrender.com:8082');
    //* create Web socket server channel connection
    final channelConn = IOWebSocketChannel.connect( wsUrl, headers: { 'x-token': token } ); 

    try {
      await channelConn.ready;
      print('Web Socket Server Connected to $wsUrl');
      state = state.copyWith( 
        channel: channelConn,
        webSocketServerStatus:  WebSocketServerStatus.online
      );
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

    //* Listen WSS messages 
    state.channel!.stream.listen((message) {
        final Map<String, dynamic > messageDecode = jsonDecode(message);
        print(messageDecode['event']);
        if (messageDecode['event'] == 'get-all-users-connected') {
          print(messageDecode);
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

  handleSendMessage( { required String event,  required UsersRequestMessage data }) {
    // send Message
    state.channel!.sink.add(
      jsonEncode(
        {
          "event": event, 
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
    if (state.webSocketServerStatus != WebSocketServerStatus.offline) {
      state = state.copyWith( 
        webSocketServerStatus:  WebSocketServerStatus.reconnecting
      );
      Future.delayed(const Duration(seconds: 3), () {
        startWSSConnection();
      });
    }
  }

  void closeWSSConnection() {
    state = state.copyWith( 
      webSocketServerStatus:  WebSocketServerStatus.offline,
    );
    state.channel!.sink.close(status.goingAway);
  }
}

final webSocketServerProvider = StateNotifierProvider<WebSocketServerNotifier, WebSocketServerState>((ref){

  return WebSocketServerNotifier();
});
