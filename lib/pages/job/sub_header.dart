import 'package:flutter/material.dart';
import 'package:kampus_connect/constants.dart';
import 'package:kampus_connect/widgets/job_search_control.dart';
import 'package:kampus_connect/widgets/job_search_tag.dart';

class HomeSubHeader extends StatelessWidget {
  const HomeSubHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: kSpacingUnit * 3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: SearchControl(),
              ),
              SizedBox(width: kSpacingUnit * 2),
              CircleAvatar(
                radius: kSpacingUnit * 2,
                backgroundImage: const AssetImage('assets/images/avatar.png'),
              ),
            ],
          ),
          SizedBox(height: kSpacingUnit * 2),
          const SearchTag(tag: 'Singapore'),
        ],
      ),
    );
  }
}
