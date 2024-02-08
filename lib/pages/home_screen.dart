import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:kampus_connect/constants/app_styles.dart';
import 'package:kampus_connect/constants/size_config.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:kampus_connect/models/information.dart';
import 'package:kampus_connect/models/news.dart';
import 'package:kampus_connect/models/notification.dart';
import 'package:kampus_connect/models/post.dart';
import 'package:kampus_connect/pages/chat_detail_page.dart';
import 'package:kampus_connect/pages/event.dart';
import 'package:kampus_connect/pages/feed_page.dart';
import 'package:kampus_connect/pages/job/job_screen.dart';
import 'package:kampus_connect/pages/login.dart';
import 'package:kampus_connect/pages/news_detail_screen.dart';
import 'package:kampus_connect/pages/news_list.dart';
import 'package:kampus_connect/pages/post_information.dart';
import 'package:kampus_connect/pages/profile.dart';
import 'package:kampus_connect/pages/social.dart';
import 'package:kampus_connect/widgets/announcement_modal.dart';
import 'package:kampus_connect/widgets/edit.dart';
import 'package:kampus_connect/widgets/feed_card.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  FirestoreDatabase database = FirestoreDatabase();
  String role = '';
  bool isAdmin = false;

  @override
  void initState() {
    database.checkUser().then((value) {
      setState(() {
        role = value;
        if (role == 'admin') {
          isAdmin = true;
        }
        print(isAdmin);
      });
    });

    super.initState();
  }

  int _currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kLighterWhite,
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.resolveWith<TextStyle>(
                (Set<MaterialState> states) => const TextStyle(
                      color: Color.fromARGB(255, 95, 93, 93),
                    )),
          ),
          child: NavigationBar(
            onDestinationSelected: (int index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            elevation: 32,
            height: 64,
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            shadowColor: Colors.black,
            selectedIndex: _currentPageIndex,
            destinations: const <Widget>[
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.group_outlined),
                label: 'Community',
              ),
              NavigationDestination(
                icon: Icon(Icons.rss_feed_outlined),
                label: 'Feed',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outlined),
                label: 'Profile',
              ),
            ],
          ),
        ),
        body: [
          // Home
          const HomePage(),
          // Community
          const SocialPage(),
          // Feed
          FeedPage(),
          // Profile
          const ProfileScreen()
        ][_currentPageIndex],
        extendBody: true,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirestoreDatabase database = FirestoreDatabase();

  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String date = '';
  DateFormat dateFormat = DateFormat('E, d LLLL   H:m a');
  DateFormat secondFormatter = DateFormat('d LLLL y');

  String role = '';
  bool isAdmin = false;

  // Helper method to load the current post content
  Future<void> loadPost(postId) async {
    CollectionReference posts =
        FirebaseFirestore.instance.collection('Annoucements');
    DocumentReference postRef = posts.doc(postId);
    DocumentSnapshot postSnapshot = await postRef.get();

    print(postSnapshot.data());
    if (postSnapshot.exists) {
      Map<String, dynamic> postData =
          postSnapshot.data() as Map<String, dynamic>;

      titleController = TextEditingController(text: postData['title']);
      descController = TextEditingController(text: postData['content']);

      // Perform the update
      // await postRef.update(postData);
    } else {
      print('Post does not exist');
    }
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }

  @override
  void initState() {
    Timestamp timestamp = Timestamp.now();
    DateTime dateTime = timestamp.toDate();
    DateFormat dateFormatter = DateFormat('EEEE, d LLLL yyyy');
    date = dateFormatter.format(dateTime);
    DateFormat formatter = DateFormat('d LLL');

    database.checkUser().then((value) {
      setState(() {
        role = value;
        if (role == 'admin') {
          isAdmin = true;
        }
        print(isAdmin);
      });
    });
    super.initState();
  }

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 51,
                      width: 51,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kBorderRadius),
                        color: kLightBlue,
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://cdn3d.iconscout.com/3d/premium/thumb/man-avatar-6299539-5187871.png',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome Back!',
                          style: kPoppinsBold.copyWith(
                            fontSize: SizeConfig.blockSizeHorizontal! * 4,
                          ),
                        ),
                        Text(
                          date,
                          style: kPoppinsRegular.copyWith(
                            color: kGrey,
                            fontSize: SizeConfig.blockSizeHorizontal! * 3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    icon: const Icon(Icons.logout))
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
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
                image: const DecorationImage(
                  image: AssetImage('assets/images/connect-image.png'),
                  alignment: Alignment.centerRight,
                ),
              ),
              height: 170,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Join The \nCommunity',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SocialPage()));
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
                      child: const Text(
                        'Join now',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _cardMenu(
                  icon: 'assets/images/job-offer2.png',
                  title: 'Jobs',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const JobScreen(),
                      ),
                    );
                  },
                ),
                _cardMenu(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EventScreen(),
                      ),
                    );
                  },
                  icon: 'assets/images/events.png',
                  title: 'Events',
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kBorderRadius),
                color: kWhite,
                boxShadow: [
                  BoxShadow(
                    color: kDarkBlue.withOpacity(0.051),
                    offset: const Offset(0.0, 3.0),
                    blurRadius: 24.0,
                    spreadRadius: 0.0,
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: kPoppinsRegular.copyWith(
                        color: kBlue,
                        fontSize: SizeConfig.blockSizeHorizontal! * 3,
                      ),
                      controller: TextEditingController(),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 13,
                        ),
                        hintText: 'Search for article...',
                        border: kBorder,
                        errorBorder: kBorder,
                        disabledBorder: kBorder,
                        focusedBorder: kBorder,
                        focusedErrorBorder: kBorder,
                        hintStyle: kPoppinsRegular.copyWith(
                          color: kLightGrey,
                          fontSize: SizeConfig.blockSizeHorizontal! * 3,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(kBorderRadius),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        'assets/images/search_icon.svg',
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20,),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     Text(
            //       'Latest Feed',
            //       style: kPoppinsBold.copyWith(
            //         fontSize: SizeConfig.blockSizeHorizontal! * 4.5,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            // SizedBox(
            //     height: 200,
            //     child: StreamBuilder(
            //         stream: FirebaseFirestore.instance
            //             .collection("Posts")
            //             .orderBy('timeStamp', descending: true)
            //             .snapshots(),
            //         builder: (context, snapshot) {
            //           if (snapshot.connectionState == ConnectionState.waiting) {
            //             return const CircularProgressIndicator();
            //           }

            //           if (snapshot.hasError) {
            //             return Text('Error: ${snapshot.error}');
            //           }

            //           List<Post> posts =
            //               snapshot.data!.docs.map((DocumentSnapshot document) {
            //             Map<String, dynamic> data =
            //                 document.data() as Map<String, dynamic>;
            //             Timestamp currentTime = Timestamp.now();
            //             return Post(
            //                 date: data['timeStamp'] ?? currentTime,
            //                 postId: data['postId'],
            //                 userId: data['userId'],
            //                 username: data['username'],
            //                 content: data['content'],
            //                 likes: data['likes'],
            //                 comments: data['comments']);
            //           }).toList();

            //           return ListView.builder(
            //               shrinkWrap: true,
            //               itemCount: posts.length,
            //               scrollDirection: Axis.horizontal,
            //               itemBuilder: (context, index) {
            //                 Post post = posts[index];

            //                 DateTime now = DateTime.now();
            //                 final postDate = post.date.toDate();
            //                 if (postDate.year == now.year &&
            //                     postDate.month == now.month &&
            //                     postDate.day == now.day) {
            //                   date = 'Today';
            //                 } else if (postDate.year == now.year &&
            //                     postDate.month == now.month &&
            //                     postDate.day == now.day - 1) {
            //                   date = 'Yesterday';
            //                 } else {
            //                   DateFormat formatter = DateFormat('d LLL');
            //                   date = formatter.format(
            //                       DateTime.fromMicrosecondsSinceEpoch(
            //                           post.date.microsecondsSinceEpoch));
            //                 }

            //                 return FeedCard(
            //                   date: date,
            //                   username: post.username,
            //                   content: post.content,
            //                   userId: post.userId,
            //                   postId: post.postId,
            //                   likes: post.likes,
            //                   comments: post.comments,
            //                 );
            //               });
            //         })),
            // const SizedBox(
            //   height: 20,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Articles',
                  style: kPoppinsBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 4.5,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => InformationListPage(
                                  isAdmin: isAdmin,
                                )));
                  },
                  child: Text(
                    'View all',
                    style: kPoppinsMedium.copyWith(
                      color: kBlue,
                      fontSize: SizeConfig.blockSizeHorizontal! * 3,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 304,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Informations')
                      .orderBy("timestamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    List<DocumentSnapshot> documents = [];
                    if (snapshot.data != null && snapshot.data!.docs != null) {
                      documents = snapshot.data!.docs as List<DocumentSnapshot>;
                    }

                    if (documents.isEmpty) {
                      return const Center(
                        child: Text('No post yet....'),
                      );
                    }

                    List<Information> informations =
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      return Information(
                        infoId: data['postId'],
                        date: data['timestamp'],
                        imgUrl: data['imgUrl'],
                        title: data['title'],
                        desc: data['desc'],
                      );
                    }).toList();
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: informations.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        Information information = informations[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewsDetailScreen(
                                          date: secondFormatter.format(DateTime
                                              .fromMicrosecondsSinceEpoch(
                                                  information.date
                                                      .microsecondsSinceEpoch)),
                                          imgUrl: information.imgUrl,
                                          title: information.title,
                                          desc: information.desc,
                                        )));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(
                              right: 20,
                            ),
                            height: 304,
                            width: 255,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(kBorderRadius),
                              color: kWhite,
                              boxShadow: [
                                BoxShadow(
                                  color: kDarkBlue.withOpacity(0.051),
                                  offset: const Offset(0.0, 3.0),
                                  blurRadius: 24.0,
                                  spreadRadius: 0.0,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 164,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(kBorderRadius),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        information.imgUrl,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 18,
                                ),
                                Flexible(
                                  child: Text(
                                    information.desc,
                                    style: kPoppinsBold.copyWith(
                                      fontSize:
                                          SizeConfig.blockSizeHorizontal! * 3.5,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Posted:',
                                              style: kPoppinsSemibold.copyWith(
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal! *
                                                    3,
                                              ),
                                            ),
                                            Text(
                                              dateFormat.format(DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                      information.date
                                                          .microsecondsSinceEpoch)),
                                              style: kPoppinsRegular.copyWith(
                                                color: kGrey,
                                                fontSize: SizeConfig
                                                        .blockSizeHorizontal! *
                                                    3,
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Visibility(
                                      visible: isAdmin,
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            builder: (context) => AlertDialog(
                                              title:
                                                  const Text('Are you sure?'),
                                              content: const Text(
                                                  'The content will be deleted.'),
                                              actions: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () => Navigator.pop(
                                                      context), // Closes the dialog
                                                  child: const Text('No'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            "Informations")
                                                        .doc(information.infoId)
                                                        .delete();
                                                    setState(() {});

                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            ),
                                            context: context,
                                          );
                                        },
                                        child: Container(
                                          height: 38,
                                          width: 38,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                kBorderRadius),
                                            color: kLightWhite,
                                          ),
                                          child: SvgPicture.asset(
                                            'assets/images/bin_icon.svg',
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardMenu({
    required String title,
    required String icon,
    VoidCallback? onTap,
    Color color = Colors.white,
    Color fontColor = Colors.grey,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 36,
        ),
        width: 156,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            Image.asset(icon),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: fontColor),
            )
          ],
        ),
      ),
    );
  }
}
