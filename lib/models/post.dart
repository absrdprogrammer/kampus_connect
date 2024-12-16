import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String profileImg;
  final String postId;
  final String userId;
  final String content;
  final int likes;
  final int comments;
  final Timestamp date;

  Post(
      {required this.profileImg,
        required this.postId,
      required this.userId,
      required this.content,
      required this.likes,
      required this.comments,
      required this.date});
}
