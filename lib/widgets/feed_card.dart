import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kampus_connect/constants/app_styles.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:kampus_connect/pages/view_post.dart';
import 'package:kampus_connect/widgets/edit_post.dart';

class FeedCard extends StatefulWidget {
  final String username;
  final String content;
  final String postId;
  final String userId;
  final int likes;
  final int comments;
  final String date;
  FeedCard(
      {super.key,
      required this.username,
      required this.content,
      required this.postId,
      required this.userId,
      required this.likes,
      required this.comments,
      required this.date});

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool isCreator = false;
  FirestoreDatabase database = FirestoreDatabase();

  @override
  void initState() {
    if (widget.userId == database.user!.uid) {
      isCreator = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
              padding: const EdgeInsets.symmetric(vertical: 10),
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
                            image: AssetImage("assets/images/hello-image.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(widget.date),
                    trailing: Visibility(
                      visible: isCreator,
                      child: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'edit') {
                              showModalBottomSheet(
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                context: context,
                                builder: (context) => EditPost(
                                  postController: widget.content,
                                  postId: widget.postId,
                                ),
                              );

                              print("Contents loaded");
                            } else if (value == 'delete') {
                              FirebaseFirestore.instance
                                  .collection("Posts")
                                  .doc(widget.postId)
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
                          child: Icon(Icons.more_horiz)),
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
                      child: Text(widget.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: const Icon(Icons.chat_bubble_outline),
                              iconSize: 30.0,
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ViewPostPage(
                                              date: widget.date,
                                              comments: widget.comments,
                                              content: widget.content,
                                              username: widget.username,
                                              likes: widget.likes,
                                              postId: widget.postId,
                                            )));
                              },
                            ),
                            Text(
                              widget.comments.toString(),
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
  }
}
