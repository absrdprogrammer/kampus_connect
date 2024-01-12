import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String title;
  final String desc;
  final Timestamp date;

  Announcement({
    required this.id,
    required this.title,
    required this.desc,
    required this.date
  });
}
