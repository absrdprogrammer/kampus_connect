import 'package:cloud_firestore/cloud_firestore.dart';

class Information {
  // final String creatorId;
  final String infoId;
  final String imgUrl;
  final String title;
  final String desc;
  final Timestamp date;

  Information(
      {
      // required this.creatorId, 
      required this.infoId,
      required this.imgUrl,
      required this.title,
      required this.desc,
      required this.date});
}
