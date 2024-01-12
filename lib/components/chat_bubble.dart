import 'package:kampus_connect/models/chat_message.dart';
import 'package:kampus_connect/pages/chat_detail_page.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  ChatMessage chatMessage;
  ChatBubble({super.key, required this.chatMessage});
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
      child: Align(
        alignment: (widget.chatMessage.type == MessageType.Receiver
            ? Alignment.topLeft
            : Alignment.topRight),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: (widget.chatMessage.type == MessageType.Receiver
                ? Colors.white
                : Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.chatMessage.username, style: const TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 7,),
              Text(widget.chatMessage.message),
            ],
          ),
        ),
      ),
    );
  }
}
