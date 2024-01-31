import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14),
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
    // border: Border(
    //   top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    // ),

    );

final kSpacingUnit = 10.00.w;

const kSilverColor = Color(0xFFF6F7FB);
const kAccentColor = Color(0xFFED5575);
const kPrimaryTextColor = Color(0xFF211D42);
const kSecondaryTextColor = Color(0xFFB9B8CD);

final kCardShadow = BoxShadow(
  color: const Color.fromRGBO(0, 0, 0, 0.05),
  blurRadius: 20.w,
  offset: Offset(10.w, 10.w),
);

final kFooterShadow = BoxShadow(
  color: const Color.fromRGBO(0, 0, 0, 0.10),
  blurRadius: 50.w,
  offset: Offset(0, -10.w),
);

final kHeadingTextStyle = TextStyle(
  color: kPrimaryTextColor,
  fontFamily: 'SF Pro Rounded',
  fontSize: 34.sp,
  fontWeight: FontWeight.w100,
);

final kTitleTextStyle = TextStyle(
  color: kPrimaryTextColor,
  fontSize: 17.sp,
  fontWeight: FontWeight.w500,
);

final kSubTitleTextStyle = TextStyle(
  color: kPrimaryTextColor,
  fontSize: 15.sp,
  fontWeight: FontWeight.w500,
);

final kCardTitleTextStyle = TextStyle(
  color: kSecondaryTextColor,
  fontSize: 13.sp,
  fontWeight: FontWeight.w500,
);

final kBodyTextStyle = TextStyle(
  color: kPrimaryTextColor,
  fontSize: 13.sp,
);

final kCaptionTextStyle = TextStyle(
  color: kSecondaryTextColor,
  fontSize: 10.sp,
);
