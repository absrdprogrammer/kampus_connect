import 'package:kampus_connect/pages/chat_detail_page.dart';

class ChatMessage {
  String message;
  MessageType type;
  String username;
  ChatMessage({required this.message, required this.type, required this.username});
}
