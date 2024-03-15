// To parse this JSON data, do
//
//     final usersRequestMessage = usersRequestMessageFromJson(jsonString);

import 'dart:convert';

enum EventMessages { userMessage  }

UsersRequestMessage usersRequestMessageFromJson(String str) => UsersRequestMessage.fromJson(json.decode(str));

String usersRequestMessageToJson(UsersRequestMessage data) => json.encode(data.toJson());

class UsersRequestMessage {
    final String message;
    final String from;
    final String to;
    final EventMessages event;

    UsersRequestMessage({
        required this.message,
        required this.from,
        required this.to,
        required this.event,
    });

    factory UsersRequestMessage.fromJson(Map<String, dynamic> json) => UsersRequestMessage(
        message: json["message"],
        from: json["from"],
        to: json["to"],
        event: json["event"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "from": from,
        "to": to,
        "event": event,
    };
}
