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

  // int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   _selectedIndex = index;
  //   print(_selectedIndex);

  //   setState(() {
  //     switch (_selectedIndex) {
  //       case 0:
  //         Navigator.push(context,
  //             MaterialPageRoute(builder: (context) => const HomePage()));
  //         break;
  //       case 1:
  //         {
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => const SocialPage()));
  //         }
  //         break;
  //     }
  //   });
  // }

  // final List<Widget> _pages = [
  //   const InformationPage(),
  //   const SocialHomePage(),
  //   const Center(
  //     child: Text("Test"),
  //   ),
  //   const Center(
  //     child: Text("Test"),
  //   )
  // ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text("Social Room"),
              ],
            ),
          ),
          backgroundColor: kLighterWhite,
          body: const SocialHomePage(),
          // bottomNavigationBar: BottomNavigationBar(
          //   elevation: 0,
          //   type: BottomNavigationBarType.fixed,
          //   backgroundColor: kWhite,
          //   items: <BottomNavigationBarItem>[
          //     BottomNavigationBarItem(
          //       icon: _selectedIndex == 0
          //           ? SvgPicture.asset('assets/images/home_selected_icon.svg')
          //           : SvgPicture.asset(
          //               'assets/images/home_unselected_icon.svg'),
          //       label: '',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: _selectedIndex == 1
          //           ? Icon(CupertinoIcons.chat_bubble_2_fill)
          //           : Icon(CupertinoIcons.chat_bubble_2),
          //       label: '',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: _selectedIndex == 2
          //           ? Icon(CupertinoIcons.info_circle_fill)
          //           : Icon(CupertinoIcons.info_circle),
          //       label: '',
          //     ),
          //     BottomNavigationBarItem(
          //       icon: _selectedIndex == 3
          //           ? Icon(Icons.logout)
          //           : Icon(Icons.logout),
          //       label: '',
          //     ),
          //   ],
          //   currentIndex: _selectedIndex,
          //   onTap: _onItemTapped,
          // ),
        ));
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
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Discuss Section',
                    style: kPoppinsBold.copyWith(
                      fontSize: SizeConfig.blockSizeHorizontal! * 4.5,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      context: context,
                      builder: (context) => AddNewPost(),
                    ),
                    child: Container(
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.blue[100],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              color: Colors.blue,
                              size: 20,
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              "Open Topic",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Posts")
                    .orderBy('timeStamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }

                  List<Post> posts =
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    Timestamp currentTime = Timestamp.now();
                    return Post(
                        date: data['timeStamp'] ?? currentTime,
                        postId: data['postId'],
                        userId: data['userId'],
                        username: data['username'],
                        content: data['content'],
                        likes: data['likes'],
                        comments: data['comments']);
                  }).toList();

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: posts.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Post post = posts[index];

                        DateTime now = DateTime.now();
                        final postDate = post.date.toDate();
                        if (postDate.year == now.year &&
                            postDate.month == now.month &&
                            postDate.day == now.day) {
                          date = 'Today';
                        } else if (postDate.year == now.year &&
                            postDate.month == now.month &&
                            postDate.day == now.day - 1) {
                          date = 'Yesterday';
                        } else {
                          date = formatter.format(
                              DateTime.fromMicrosecondsSinceEpoch(
                                  post.date.microsecondsSinceEpoch));
                        }

                        return FeedCard(
                          date: date,
                          username: post.username,
                          content: post.content,
                          userId: post.userId,
                          postId: post.postId,
                          likes: post.likes,
                          comments: post.comments,
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}

class CommunityCard extends StatelessWidget {
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
            image: AssetImage(imagePath),
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
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context, MaterialPageRoute(builder: (context) => page)),
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
                      text,
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
