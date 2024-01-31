import 'package:flutter/material.dart';
import 'package:kampus_connect/constants.dart';
import 'package:kampus_connect/pages/job/popular_jobs.dart';
import 'package:kampus_connect/pages/job/recent_jobs.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: kSpacingUnit * 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kSpacingUnit * 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Jobs',
                    style: kSubTitleTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text('View All', style: kCardTitleTextStyle),
                ],
              ),
            ),
            const HomePopularJobs(),
            SizedBox(height: kSpacingUnit * 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kSpacingUnit * 4),
              child: Text(
                'Recently Added',
                style: kSubTitleTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const HomeRecentJobs(),
          ],
        ),
      ),
    );
  }
}
