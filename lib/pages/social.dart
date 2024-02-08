import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kampus_connect/constants/app_styles.dart';
import 'package:kampus_connect/constants/size_config.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:kampus_connect/models/post.dart';
import 'package:kampus_connect/pages/chat_detail_page.dart';
import 'package:kampus_connect/pages/home_screen.dart';
import 'package:kampus_connect/pages/room_list.dart';
import 'package:kampus_connect/widgets/feed_card.dart';
import 'package:kampus_connect/widgets/show_model.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({Key? key}) : super(key: key);

  @override
  State<SocialPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<SocialPage> {
  final isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                Text("Social Room"),
              ],
            ),
          ),
          backgroundColor: kLighterWhite,
          body: const SocialHomePage(),
        );
  }
}

class SocialHomePage extends StatefulWidget {
  const SocialHomePage({Key? key}) : super(key: key);

  @override
  State<SocialHomePage> createState() => _SocialHomePageState();
}

class _SocialHomePageState extends State<SocialHomePage> {
  DateFormat formatter = DateFormat('d LLL');

  String date = '';

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Material(
      child: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'General Community',
                  style: kPoppinsBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 4.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const CommunityCard(
              title: "  Join The\nCommunity",
              text: "Join now",
              page: ChatDetailPage(),
              imagePath: 'assets/images/connect-image.png',
            ),
            const SizedBox(
              height: 10,
            ),
            CommunityCard(
              title: "Find Your\n   Team",
              text: "Find now",
              page: ListRoomPage(),
              imagePath: 'assets/images/team-image.png',
            ),
          ],
        ),
      ),
    );
  }
}

class CommunityCard extends StatefulWidget {
  final String title;
  final String text;
  final page;
  final String imagePath;
  const CommunityCard(
      {super.key,
      required this.title,
      required this.text,
      required this.page,
      required this.imagePath});

  @override
  State<CommunityCard> createState() => _CommunityCardState();
}

class _CommunityCardState extends State<CommunityCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blue,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 3,
            offset: Offset(0, 10),
          ),
        ],
        image: DecorationImage(
            image: AssetImage(widget.imagePath),
            alignment: Alignment.centerLeft,
            fit: BoxFit.fitHeight),
      ),
      height: 150,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => widget.page));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 3,
                          offset: const Offset(
                            0,
                            10,
                          ),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
