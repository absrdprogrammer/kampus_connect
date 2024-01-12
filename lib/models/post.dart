import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String userId;
  final String username;
  final String content;
  final int likes;
  final int comments;
  final Timestamp date;

  Post({
    required this.postId,
    required this.userId,
    required this.username,
    required this.content,
    required this.likes,
    required this.comments,
    required this.date
  });
}
