import 'package:flutter/material.dart';
import 'package:intro_screen_onboarding_flutter/introduction.dart';
import 'package:intro_screen_onboarding_flutter/introscreenonboarding.dart';
import 'package:kampus_connect/pages/login.dart';
import 'package:kampus_connect/pages/role.dart';

class Onboarding extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Find Information',
      subTitle: 'Explore the latest and most up-to-date news information',
      imageUrl: 'assets/images/news-image.png',
    ),
    Introduction(
      title: 'Connect With Others',
      subTitle: 'Expand your network by discovering other students from your university branch',
      imageUrl: 'assets/images/connect-image.png',
    ), 
    Introduction(
      title: 'Create Your Team',
      subTitle: 'Find your team and collectively build your project with seamless collaboration',
      imageUrl: 'assets/images/team-image.png',
    ),
    Introduction(
      title: 'Report Issues',
      subTitle: 'Notify us to report any problems or concerns, allowing for prompt attention and resolution.',
      imageUrl: "assets/images/report-image.png",
    ),   
  ];

  Onboarding({super.key});
  @override
  Widget build(BuildContext context) {
    return IntroScreenOnboarding(
      backgroudColor: const Color(0xFFf9f9f9),
      foregroundColor: const Color(0xFF407BFF),
      introductionList: list,
      onTapSkipButton: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RolePage(),
          )),
      skipTextStyle: const TextStyle(
        color: Color.fromARGB(255, 52, 130, 169),
        fontSize: 10,
      ),
    );
  }
}
