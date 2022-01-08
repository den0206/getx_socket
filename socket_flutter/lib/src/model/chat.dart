import 'dart:convert';

class Chat {
  final String chatRoomId;
  final String text;

  Chat(this.chatRoomId, this.text);

  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'text': text,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      map['chatRoomId'] ?? '',
      map['text'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));
}
