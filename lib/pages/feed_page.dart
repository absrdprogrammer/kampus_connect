import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kampus_connect/constants/app_styles.dart';
import 'package:kampus_connect/constants/size_config.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:kampus_connect/models/post.dart';
import 'package:kampus_connect/pages/view_post.dart';
import 'package:kampus_connect/widgets/edit_post.dart';
import 'package:kampus_connect/widgets/show_model.dart';

class FeedPage extends StatelessWidget {
  FeedPage({super.key});
  FirestoreDatabase database = FirestoreDatabase();
  String date = '';
  bool isCreator = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feeds"),
        actions: [
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  context: context,
                  builder: (context) => AddNewPost(),
                ),
                child: const Row(
                    children: <Widget>[
                      Icon(
                        CupertinoIcons.plus_circle,
                        color: Colors.white,
                        size: 25,
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        "Open Topic",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                ),
              )
            ],
          ),
          const SizedBox(width: 15,)
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Posts")
              .orderBy('timeStamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            List<Post> posts =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              Timestamp currentTime = Timestamp.now();
              return Post(
                  date: data['timeStamp'] ?? currentTime,
                  postId: data['postId'],
                  userId: data['userId'],
                  username: data['username'],
                  content: data['content'],
                  likes: data['likes'],
                  comments: data['comments']);
            }).toList();

            return ListView.builder(
                shrinkWrap: true,
                itemCount: posts.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Post post = posts[index];

                  if (post.userId == database.user!.uid) {
                    isCreator = true;
                  }

                  DateTime now = DateTime.now();
                  final postDate = post.date.toDate();
                  if (postDate.year == now.year &&
                      postDate.month == now.month &&
                      postDate.day == now.day) {
                    date = 'Today';
                  } else if (postDate.year == now.year &&
                      postDate.month == now.month &&
                      postDate.day == now.day - 1) {
                    date = 'Yesterday';
                  } else {
                    DateFormat formatter = DateFormat('d LLL');
                    date = formatter.format(DateTime.fromMicrosecondsSinceEpoch(
                        post.date.microsecondsSinceEpoch));
                  }

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      width: 350,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 1,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: <Widget>[
                                ListTile(
                                  leading: Container(
                                    width: 50.0,
                                    height: 50.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black45,
                                          offset: Offset(0, 2),
                                          blurRadius: 6.0,
                                        ),
                                      ],
                                    ),
                                    child: const CircleAvatar(
                                      child: ClipOval(
                                        child: Image(
                                          height: 50.0,
                                          width: 50.0,
                                          image: AssetImage(
                                              "assets/images/hello-image.png"),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    post.username,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(date),
                                  trailing: Visibility(
                                    visible: isCreator,
                                    child: PopupMenuButton(
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            showModalBottomSheet(
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              context: context,
                                              builder: (context) => EditPost(
                                                postController: post.content,
                                                postId: post.postId,
                                              ),
                                            );

                                            print("Contents loaded");
                                          } else if (value == 'delete') {
                                            FirebaseFirestore.instance
                                                .collection("Posts")
                                                .doc(post.postId)
                                                .delete();
                                            print('Delete tapped');
                                          }
                                        },
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry<String>>[
                                              const PopupMenuItem<String>(
                                                value: 'edit',
                                                child: ListTile(
                                                  leading: Icon(Icons.edit),
                                                  title: Text('Edit'),
                                                ),
                                              ),
                                              const PopupMenuItem<String>(
                                                value: 'delete',
                                                child: ListTile(
                                                  leading: Icon(Icons.delete),
                                                  title: Text('Delete'),
                                                ),
                                              ),
                                            ],
                                        child: const Icon(Icons.more_horiz)),
                                  ),
                                ),
                                InkWell(
                                  onDoubleTap: () => print('Like post'),
                                  onTap: () {
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (_) => ViewPostScreen(
                                    //       post: posts[index],
                                    //     ),
                                    //   ),
                                    // );
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(10.0),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    child: Text(
                                      post.content,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          IconButton(
                                            icon: const Icon(
                                                Icons.chat_bubble_outline),
                                            iconSize: 30.0,
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ViewPostPage(
                                                            date: date,
                                                            comments:
                                                                post.comments,
                                                            content:
                                                                post.content,
                                                            username:
                                                                post.username,
                                                            likes: post.likes,
                                                            postId: post.postId,
                                                          )));
                                            },
                                          ),
                                          Text(
                                            post.comments.toString(),
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
    );
  }
}
