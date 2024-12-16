import 'package:cloud_firestore/cloud_firestore.dart';

class CommentPost {
  final String commentId;
  final String email;
  final String comment;
  final int likes;
  final Timestamp date;

  CommentPost({
    required this.commentId,
    required this.email,
    required this.comment,
    required this.likes,
    required this.date
  });
}
