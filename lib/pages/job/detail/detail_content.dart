import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kampus_connect/constants.dart';
import 'package:kampus_connect/models/job.dart';
import 'package:kampus_connect/widgets/job_detail_item.dart';

class DetailContent extends StatelessWidget {
  const DetailContent({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Job data;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: kSpacingUnit * 4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(kSpacingUnit * 5),
            topRight: Radius.circular(kSpacingUnit * 5),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: kSpacingUnit * 5),
              Center(
                child: Column(
                  children: [
                    SvgPicture.asset(
                      data.imgUrl!,
                      height: 50.sp,
                      width: 50.sp,
                    ),
                    SizedBox(height: kSpacingUnit * 2),
                    Text(
                      data.companyName!,
                      style: kTitleTextStyle,
                    ),
                    SizedBox(height: kSpacingUnit),
                    Text(
                      data.location!,
                      style: kCaptionTextStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(height: kSpacingUnit * 5),
              Text(
                'Responsibilities',
                style: kSubTitleTextStyle,
              ),
              SizedBox(height: kSpacingUnit * 2),
              if (data.responsibilities != null &&
                  data.responsibilities!.isNotEmpty)
                ...data.responsibilities!
                    .map((responsibility) => DetailItem(data: responsibility))
                    .toList(),
              SizedBox(height: kSpacingUnit),
              Text(
                'Qualifications',
                style: kSubTitleTextStyle,
              ),
              SizedBox(height: kSpacingUnit * 2),
              if (data.qualifications != null &&
                  data.qualifications!.isNotEmpty)
                ...data.qualifications!
                    .map((qualification) => DetailItem(data: qualification))
                    .toList(),
              SizedBox(height: kSpacingUnit * 15),
            ],
          ),
        ),
      ),
    );
  }
}
