
import 'package:chat_app/global/enviroment.dart';
import 'package:chat_app/models/conversation_messages_response.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/services.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ChatService with ChangeNotifier {
  
  late User userJustChatting;
  late final Dio dio;

  ChatService(): dio = Dio ( //* INIT DIO
    BaseOptions(
      baseUrl: Environment.apiURL,
      headers: {
        'Content-type': 'application/json',
      }
    )
  );


  // LOGIN METHOD
  Future<List<Msg>> getConversationMessages({required String from, required int skip}) async {
    try {
      final response = await dio.post(
        '/messages/get-conversations',
        options: Options(
            headers: {
            'Content-type': 'application/json',
            'x-token': await AuthService.getToken()
          },
        ),
        data: {
          'from': from,
          'to': userJustChatting.uuid,
          'skip': skip
        }
      );
      final usersResponse = ConversationsMessagesResponse.fromJson(response.data);
      return usersResponse.msg;
    } catch (e) {
      print(e);
      throw Exception(e);
    }
    
  
  }
}