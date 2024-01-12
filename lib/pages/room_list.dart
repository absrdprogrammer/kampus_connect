import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:kampus_connect/models/user.dart';
import 'package:kampus_connect/pages/room_screen.dart';

class ListRoomPage extends StatelessWidget {
  FirestoreDatabase database = FirestoreDatabase();
  ListRoomPage({super.key});

  List<User> users = User.getAllUsers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return CreateGroupDialog();
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.add,
                  size: 21.0,
                  color: Colors.white,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Start a room',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
        appBar: AppBar(
          title: const Text("Room List"),
          elevation: 0,
          leading: IconButton(
            icon: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              iconSize: 28,
            ),
            onPressed: () {},
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: StreamBuilder(
                stream: database.getRoomsStream(),
                builder: (context, snapshot) {
                  // show loading circle
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
            
                  List<Room> rooms =
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return Room(
                        name: data['groupName'], groupId: data['groupId']);
                  }).toList();
            
                  // get each room
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: rooms.length,
                    itemBuilder: (context, index) {
                      final room = rooms[index];
                      String name = room.name;
                      String id = room.groupId;
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 10,
                                spreadRadius: 3,
                                offset: Offset(0, 10),
                              ),
                            ],
                            image: const DecorationImage(
                              image: AssetImage('assets/images/team-image.png'),
                              alignment: Alignment.centerRight,
                            ),
                          ),
                          height: 170,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                constraints: const BoxConstraints(maxWidth: 180),
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RoomScreen(
                                              room: Room(
                                                groupId: id,
                                                  name: name,
                                                  others: List<User>.from(
                                                      users)))));
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.only(top: 10, left: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        spreadRadius: 3,
                                        offset: const Offset(
                                          0,
                                          10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'Enter room',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          ),
        ),
        );
  }
}

class CreateGroupDialog extends StatefulWidget {
  @override
  _CreateGroupDialogState createState() => _CreateGroupDialogState();
}

class _CreateGroupDialogState extends State<CreateGroupDialog> {
  final FirestoreDatabase database = FirestoreDatabase();
  TextEditingController groupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Create Room',
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: groupNameController,
            decoration: const InputDecoration(
              hintText: 'Enter room name',
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if(groupNameController.text.trim().isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Warning',
                        textAlign: TextAlign.center,
                      ),
                      content: const Text('Konten masih kosong'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  });
            } else {
              createGroup(groupNameController.text.trim());
              Navigator.of(context).pop();
            }
          },
          child: const Text('OK'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }

  // Function to create a group
  Future<void> createGroup(String groupName) async {
    if (groupNameController.text != "" || groupNameController.text.isNotEmpty) {
      database.addNewRoom(groupName);
    }
    groupNameController.clear();

    setState(() {});
  }
}
