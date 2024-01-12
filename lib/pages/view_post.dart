import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kampus_connect/constants/app_styles.dart';
import 'package:kampus_connect/constants/size_config.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:kampus_connect/models/comment.dart';

class ViewPostPage extends StatefulWidget {
  final String username;
  final String content;
  final String postId;
  final int likes;
  final int comments;
  final String date;

  const ViewPostPage(
      {super.key,
      required this.username,
      required this.content,
      required this.postId,
      required this.likes,
      required this.comments,
      required this.date});

  @override
  State<ViewPostPage> createState() => _ViewPostPageState();
}

class _ViewPostPageState extends State<ViewPostPage> {
  String date = '';
  FirestoreDatabase database = FirestoreDatabase();
  TextEditingController commentController = TextEditingController();

  DateFormat dayMonthFormatter = DateFormat('d LLL');
  DateFormat timeFormatter = DateFormat('H:m a');

  String commentText = '';

  void postComment() {
    if (commentText.isNotEmpty) {
      database.addComment(widget.postId, commentText);

      commentController.clear();
      commentText = '';

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Transform.translate(
          offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 75.0,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -2),
                  blurRadius: 6.0,
                ),
              ],
              color: Colors.white,
            ),
            child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                    controller: commentController,
                    onChanged: (value) {
                      commentText = value;
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.all(20.0),
                      hintText: 'Add a comment...',
                      suffixIcon: Container(
                        width: 70.0,
                        child: IconButton(
                          icon: const Icon(Icons.send),
                          color: Colors.blue,
                          onPressed: () => postComment(),
                        ),
                      ),
                    ))),
          )),
      body: Column(children: <Widget>[
        StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Posts")
                .doc(widget.postId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final post = snapshot.data!;
              if (!snapshot.hasData) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Text("No posts.. Post something!"),
                  ),
                );
              }

              return Container(
                padding: const EdgeInsets.only(top: 45, left: 15, right: 15),
                width: double.infinity,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.arrow_back),
                                iconSize: 30,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.8,
                                child: ListTile(
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
                                    post['username'],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(widget.date),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.more_horiz),
                                    color: Colors.black,
                                    onPressed: () => print('More'),
                                  ),
                                ),
                              ),
                            ],
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
                              child: Text(post['content']),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const SizedBox(width: 20.0),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: const Icon(Icons.chat),
                                      iconSize: 30.0,
                                      onPressed: () {},
                                    ),
                                    Text(
                                      post['comments'].toString(),
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
              );
            }),
        const SizedBox(height: 10.0),
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              height: 600.0,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Comments',
                      style: kPoppinsBold.copyWith(
                        fontSize: SizeConfig.blockSizeHorizontal! * 4.5,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SingleChildScrollView(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("Posts")
                              .doc(widget.postId)
                              .collection("Comments")
                              .orderBy("timeStamp")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }

                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            List<CommentPost> comments = snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;

                              Timestamp currentTime = Timestamp.now();

                              return CommentPost(
                                  date: data['timeStamp'] ?? currentTime,
                                  commentId: data['commentId'],
                                  userId: data['userId'],
                                  username: data['username'],
                                  comment: data['comment'],
                                  likes: data['likes']);
                            }).toList();

                            return SingleChildScrollView(
                              padding: const EdgeInsets.only(top: 20),
                              child: ListView.builder(
                                  padding: const EdgeInsets.only(top: 0),
                                  shrinkWrap: true,
                                  itemCount: comments.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    CommentPost comment = comments[index];
                                    DateTime now = DateTime.now();
                                    final commentsDate = comment.date.toDate();
                                    if (commentsDate.year == now.year &&
                                        commentsDate.month == now.month &&
                                        commentsDate.day == now.day) {
                                      date = timeFormatter.format(
                                          DateTime.fromMicrosecondsSinceEpoch(
                                              commentsDate
                                                  .microsecondsSinceEpoch));
                                    } else if (commentsDate.year == now.year &&
                                        commentsDate.month == now.month &&
                                        commentsDate.day == now.day - 1) {
                                      date = 'yesterday';
                                    } else {
                                      date = dayMonthFormatter.format(
                                          DateTime.fromMicrosecondsSinceEpoch(
                                              commentsDate
                                                  .microsecondsSinceEpoch));
                                    }
                                    return Column(
                                      children: [
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
                                              comment.username,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            subtitle: Text(comment.comment),
                                            trailing: Text(date)),
                                        const Divider(
                                          thickness: 1,
                                        ),
                                      ],
                                    );
                                  }),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
