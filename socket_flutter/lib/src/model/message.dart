import 'dart:convert';

class Message {
  final String chatRoomId;
  final String text;

  Message(this.chatRoomId, this.text);

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'text': text,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      map['chatRoomId'] ?? '',
      map['text'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));
}
