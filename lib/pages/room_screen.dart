import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:kampus_connect/models/ideas.dart';
import 'package:kampus_connect/models/user.dart';
import 'package:kampus_connect/pages/chat_group.dart';
import 'package:kampus_connect/widgets/idea_card.dart';
import 'package:kampus_connect/widgets/room_user_profile.dart';
import "dart:math";

class RoomScreen extends StatelessWidget {
  final Room room;

  RoomScreen({
    Key? key,
    required this.room,
  }) : super(key: key);

  List<Color?> colors = [
    Colors.green[400],
    Colors.amber[300],
    Colors.blue[300],
    Colors.red[300]
  ];

  FirestoreDatabase database = FirestoreDatabase();
  final random = new Random();
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leadingWidth: 500,
        leading: TextButton.icon(
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(CupertinoIcons.chat_bubble_2_fill),
          label: const Text(
            'COLLABORATION ROOM',
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
      body: Container(
        padding: const EdgeInsets.all(20.0),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: CustomScrollView(
          scrollBehavior: const CupertinoScrollBehavior(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      room.name,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 40),
                child: Center(
                  child: Text(
                    "Admin Group",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.all(20.0),
              sliver: SliverGrid.count(
                mainAxisSpacing: 20.0,
                crossAxisCount: 4,
                childAspectRatio: 0.7,
                children: room.others
                    .map(
                      (e) => RoomUserProfile(
                        imageUrl: e.imageUrl,
                        size: 66.0,
                        name: e.name,
                      ),
                    )
                    .toList(),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Ideas Space",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder(
                      stream: database.getIdeasStream(room.groupId),
                      builder: (context, snapshot) {
                        // show loading circle
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        // handle no data
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(25),
                              child: Text("Empty"),
                            ),
                          );
                        }

                        List<Ideas> ideas = snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return Ideas(
                              id: data['id'],
                              userId: data['userId'],
                              title: data['title'],
                              description: data['idea']);
                        }).toList();

                        return ListView.builder(
                          controller: scrollController,
                            scrollDirection: Axis.vertical,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: ideas.length,
                            itemBuilder: (context, index) {
                              Ideas idea = ideas[index];
                              return IdeasTile(
                                title: idea.title,
                                subTitle: idea.description,
                                color: colors[random.nextInt(colors.length)],
                              );
                            });
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 12.0,
        ),
        height: 80.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CreateIdeaDialog(
                      roomId: room.groupId,
                    );
                  },
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 206, 229, 248),
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '💡  ',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      TextSpan(
                        text: 'Post Ideas ',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatGroupPage(
                                  groupId: room.groupId,
                                )));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 206, 229, 248),
                    ),
                    child: const Icon(
                      CupertinoIcons.chat_bubble,
                      size: 30.0,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CreateIdeaDialog extends StatefulWidget {
  final String roomId;
  const CreateIdeaDialog({super.key, required this.roomId});

  @override
  _CreateIdeaDialogState createState() => _CreateIdeaDialogState();
}

class _CreateIdeaDialogState extends State<CreateIdeaDialog> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  FirestoreDatabase database = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Center(child: Text('Your Idea 💡')),
      content: Container(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            // Tambahkan TextField lainnya jika diperlukan
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Batal'),
        ),
        TextButton(
          onPressed: () {
            createIdea(
                titleController.text, descController.text, widget.roomId);
            Navigator.of(context).pop();
          },
          child: const Text('Simpan'),
        ),
      ],
    );
  }

  Future<void> createIdea(String title, String desc, String groupId) async {
    print(groupId);
    if (titleController.text != "" || descController.text.isNotEmpty) {
      database.addIdeasToGroup(groupId, desc, title);
    }
    titleController.clear();
    descController.clear();

    setState(() {});
  }
}
