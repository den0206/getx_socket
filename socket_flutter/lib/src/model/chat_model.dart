class ChatModel {
  final int id;
  final String name;
  final String icon;
  final String time;
  final String currentMessage;
  final String status;
  final bool isGroup;
  bool select = false;

  ChatModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.time,
    required this.currentMessage,
    required this.status,
    required this.isGroup,
    required this.select,
  });
}
