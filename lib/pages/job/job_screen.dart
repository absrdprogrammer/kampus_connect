import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kampus_connect/constants.dart';
import 'package:kampus_connect/pages/job/content.dart';
import 'package:kampus_connect/pages/job/header.dart';
import 'package:kampus_connect/pages/job/sub_header.dart';

class JobScreen extends StatelessWidget {
  const JobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(414, 896), minTextAdapt: true);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kSpacingUnit * 6),
            const HomeHeader(),
            SizedBox(height: kSpacingUnit * 3),
            const HomeContent(),
          ],
        ),
      ),
    );
  }
}
