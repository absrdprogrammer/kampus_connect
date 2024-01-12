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
import 'package:kampus_connect/pages/chat_detail_page.dart';
import 'package:kampus_connect/pages/login.dart';
import 'package:kampus_connect/pages/news_detail_screen.dart';
import 'package:kampus_connect/pages/news_list.dart';
import 'package:kampus_connect/pages/post_information.dart';
import 'package:kampus_connect/pages/social.dart';
import 'package:kampus_connect/widgets/announcement_modal.dart';
import 'package:kampus_connect/widgets/edit.dart';

class InformationPage extends StatefulWidget {
  const InformationPage({Key? key}) : super(key: key);

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  FirestoreDatabase database = FirestoreDatabase();
  // int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;

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
  //   const HomePage(),
  //   const SocialPage(),
  //   const Center(
  //     child: Text("Test"),
  //   ),
  //   const Center(
  //     child: Text("Test"),
  //   )
  // ];
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor: kLighterWhite,
          body: const HomePage(),
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
          floatingActionButton: Visibility(
            visible: isAdmin,
            child: SpeedDial(
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  child: const Icon(Icons.newspaper),
                  label: "Post Information",
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => PostPage()));
                  },
                  labelStyle:
                      const TextStyle(fontSize: 18, color: Colors.white),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  labelBackgroundColor: Colors.green,
                ),
                SpeedDialChild(
                  child: const Icon(Icons.info),
                  label: "Post Announcement",
                  onTap: () => showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    context: context,
                    builder: (context) => AddAnnouncement(),
                  ),
                  labelStyle:
                      const TextStyle(fontSize: 18, color: Colors.white),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  labelBackgroundColor: Colors.red,
                ),
              ],
            ),
          )),
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
    print(date);

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
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const LoginPage()));
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Information',
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
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Announcement',
                  style: kPoppinsBold.copyWith(
                    fontSize: SizeConfig.blockSizeHorizontal! * 4.5,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Announcements')
                      .orderBy("timeStamp", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    List<Announcement> announcements =
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;

                      Timestamp currentTime = Timestamp.now();
                      return Announcement(
                        date: data['timeStamp'] ?? currentTime,
                        id: data['postId'],
                        title: data['title'],
                        desc: data['content'],
                      );
                    }).toList();

                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        Announcement info = announcements[index];
                        return Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(
                            bottom: 20,
                          ),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            color: kWhite,
                            boxShadow: [
                              BoxShadow(
                                color: kDarkBlue.withOpacity(0.051),
                                offset: const Offset(0.0, 3.0),
                                blurRadius: 24.0,
                                spreadRadius: 0.0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                info.title,
                                style: kPoppinsBold.copyWith(
                                  color: Colors.blue,
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              const Divider(
                                thickness: 1,
                                color: Colors.black54,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                info.desc,
                                style: kPoppinsBold.copyWith(
                                  fontSize: 15,
                                ),
                                maxLines: 50,
                                overflow: TextOverflow.ellipsis,
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
                                              fontSize: 12,
                                            ),
                                          ),
                                          Text(
                                            dateFormat.format(DateTime
                                                .fromMicrosecondsSinceEpoch(info
                                                    .date
                                                    .microsecondsSinceEpoch)),
                                            style: kPoppinsRegular.copyWith(
                                              color: kGrey,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: isAdmin,
                                    child: PopupMenuButton(
                                      onSelected: (value) {
                                        if (value == 'edit') {
                                          print(info.id);
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            context: context,
                                            builder: (context) =>
                                                EditAnnouncement(
                                              newPostController: info.title,
                                              postDescription: info.desc,
                                              postId: info.id,
                                            ),
                                          );
                                          loadPost(info.id);

                                          print("Contents loaded");
                                        } else if (value == 'delete') {
                                          FirebaseFirestore.instance
                                              .collection("Announcements")
                                              .doc(info.id)
                                              .delete();
                                          print('Delete tapped');
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: 'edit',
                                          child: ListTile(
                                            leading: Icon(Icons.edit),
                                            title: Text('Edit'),
                                          ),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'delete',
                                          child: ListTile(
                                            leading: Icon(Icons.delete),
                                            title: Text('Delete'),
                                          ),
                                        ),
                                      ],
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
                                          'assets/images/dots.svg',
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
}
