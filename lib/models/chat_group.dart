import '../pages/chat_group.dart';

class ChatMessageGroup {
  String message;
  MessageType type;
  String username;
  ChatMessageGroup(
      {required this.message, required this.type, required this.username});
}
