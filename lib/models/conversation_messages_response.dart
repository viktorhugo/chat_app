// To parse this JSON data, do
//
//     final conversationsMessagesResponse = conversationsMessagesResponseFromJson(jsonString);

import 'dart:convert';

ConversationsMessagesResponse conversationsMessagesResponseFromJson(String str) => ConversationsMessagesResponse.fromJson(json.decode(str));

String conversationsMessagesResponseToJson(ConversationsMessagesResponse data) => json.encode(data.toJson());

class ConversationsMessagesResponse {
    bool ok;
    List<Msg> msg;

    ConversationsMessagesResponse({
        required this.ok,
        required this.msg,
    });

    factory ConversationsMessagesResponse.fromJson(Map<String, dynamic> json) => ConversationsMessagesResponse(
        ok: json["ok"],
        msg: List<Msg>.from(json["msg"].map((x) => Msg.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "msg": List<dynamic>.from(msg.map((x) => x.toJson())),
    };
}

class Msg {
    String from;
    String to;
    String message;
    DateTime createdAt;
    DateTime updatedAt;
    String uuid;

    Msg({
        required this.from,
        required this.to,
        required this.message,
        required this.createdAt,
        required this.updatedAt,
        required this.uuid,
    });

    factory Msg.fromJson(Map<String, dynamic> json) => Msg(
        from: json["from"] ?? "",
        to: json["to"] ?? "",
        message: json["message"] ?? "",
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        uuid: json["_id"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "message": message,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "_id": uuid,
    };
}
