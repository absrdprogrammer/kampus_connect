import 'package:cloud_firestore/cloud_firestore.dart';

class CommentPost {
  final String commentId;
  final String username;
  final String userId;
  final String comment;
  final int likes;
  final Timestamp date;

  CommentPost({
    required this.commentId,
    required this.username,
    required this.userId,
    required this.comment,
    required this.likes,
    required this.date
  });
}
