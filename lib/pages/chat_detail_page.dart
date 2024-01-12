import 'package:flutter/cupertino.dart';
import 'package:kampus_connect/components/chat_bubble.dart';
import 'package:kampus_connect/components/chat_detail_page_appbar.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:kampus_connect/models/chat_message.dart';
import 'package:kampus_connect/models/send_menu_items.dart';
import 'package:flutter/material.dart';

enum MessageType {
  Sender,
  Receiver,
}

class ChatDetailPage extends StatefulWidget {
  const ChatDetailPage({super.key});

  @override
  _ChatDetailPageState createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  FirestoreDatabase database = FirestoreDatabase();

  String message = '';

  List<ChatMessage> chatMessage = [];

  List<SendMenuItems> menuItems = [
    SendMenuItems(
        text: "Photos & Videos", icons: Icons.image, color: Colors.amber),
    SendMenuItems(
        text: "Document", icons: Icons.insert_drive_file, color: Colors.blue),
    SendMenuItems(text: "Audio", icons: Icons.music_note, color: Colors.orange),
    SendMenuItems(
        text: "Location", icons: Icons.location_on, color: Colors.green),
    SendMenuItems(text: "Contact", icons: Icons.person, color: Colors.purple),
  ];

  void sendMessage() {
    if (message.isNotEmpty) {
        chatMessage.add(
          ChatMessage(message: message, type: MessageType.Sender, username: database.user!.displayName ?? 'Anonymous',
          ),
        );

      database.addMessage(message);

      // Bersihkan teks pada TextField
      messageController.clear();
      message = '';

      setState(() {
        // Pindahkan fokus ke pesan terakhir
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } else {}
  }


    // void scrollBottom() {
    //   // Setelah widget diinisialisasi, geser ke bawah atau ke konten terakhir
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    //   });

    //   _scrollController.animateTo(
    //     _scrollController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 300),
    //     curve: Curves.easeOut,
    //   );
    // }

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    }

  void showModal() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 2,
            color: const Color(0xff737373),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
              ),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 16,
                  ),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      color: Colors.grey.shade200,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                    itemCount: menuItems.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: ListTile(
                          leading: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: menuItems[index].color.shade50,
                            ),
                            height: 50,
                            width: 50,
                            child: Icon(
                              menuItems[index].icons,
                              size: 20,
                              color: menuItems[index].color.shade400,
                            ),
                          ),
                          title: Text(menuItems[index].text),
                        ),
                      );
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 500,
        leading: TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
          label: const Text(
            'General Community',
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, size: 28.0),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: database.getMessagesStream(),
            builder: (context, snapshot) {
              // handle no data
              if (!snapshot.hasData) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No message.."),
                  ),
                );
              }
          
              final messages = snapshot.data!.docs;

              WidgetsBinding.instance!.addPostFrameCallback((_) {
                _scrollController
                    .jumpTo(_scrollController.position.maxScrollExtent);
              });
          
              return ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 10, bottom: 70),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  String messageText = message['message'];
          
                  return ChatBubble(
                    chatMessage: ChatMessage(
                      message: messageText,
                      type: database.user!.uid != message['senderId']
                          ? MessageType.Receiver
                          : MessageType.Sender,
                          username: message['username'] ?? 'Anonymous',
                    ),
                  );
                },
              );
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 16, bottom: 10, right: 16),
              height: 80,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      showModal();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        setState(() {
                          message = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Type message...",
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: sendMessage,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
