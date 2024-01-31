import 'package:flutter/material.dart';
import 'package:kampus_connect/constants.dart';
import 'package:kampus_connect/models/job.dart';
import 'package:kampus_connect/pages/job/detail/detail_content.dart';
import 'package:kampus_connect/pages/job/detail/detail_footer.dart';
import 'package:kampus_connect/pages/job/detail/detail_header.dart';

class DetailScreen extends StatelessWidget {
  final Job data;

  const DetailScreen({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSilverColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                DetailHeader(data: data),
                DetailContent(data: data),
              ],
            ),
            const DetailFooter(),
          ],
        ),
      ),
    );
  }
}
