import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:kampus_connect/pages/edit_profile.dart';
import 'package:kampus_connect/pages/login.dart';
import 'package:kampus_connect/widgets/profile_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FirestoreDatabase database = FirestoreDatabase();
  late ScrollController _scrollController;
  bool lastStatus = true;
  double height = 160;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController.hasClients &&
        _scrollController.offset > (height - kToolbarHeight);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var sWidth = MediaQuery.of(context).size.width;
    var sHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        body: SafeArea(
            top: false,
            child: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/bg_profile.jpg'),
                        fit: BoxFit.cover)),
                child: NestedScrollView(
                    controller: _scrollController,
                    headerSliverBuilder: (context, innerBoxIsScrolled) => [
                          SliverAppBar(
                            leading: IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  LineAwesomeIcons.angle_left,
                                  color: Colors.white,
                                )),
                            pinned: true,
                            floating: true,
                            backgroundColor: _isShrink
                                ? const Color.fromARGB(255, 35, 148, 253)
                                : Colors.transparent,
                            expandedHeight: height,
                            flexibleSpace: FlexibleSpaceBar(
                              title: _isShrink
                                  ? const Text('Profile',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20))
                                  : const SizedBox(),
                            ),
                          )
                        ],
                    body: BottomSheet()))));
  }
}

class BottomSheet extends StatefulWidget {
  BottomSheet({super.key});

  @override
  State<BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  FirestoreDatabase database = FirestoreDatabase();
  String profileImg = '';

  @override
  void initState() {
    super.initState();
    getProfileImg();
  }

  Stream<DocumentSnapshot> getProfileImg() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(database.user!.email)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var sWidth = MediaQuery.of(context).size.width;
    var sHeight = MediaQuery.of(context).size.height;
    var margin = 8.0;
    return Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: margin),
            padding: const EdgeInsets.fromLTRB(16.0, 65, 16.0, 16.0),
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 241, 250, 255),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(32),
                    topLeft: Radius.circular(32))),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(database.user!.displayName.toString(),
                      style: TextStyle(
                          color: Color.fromARGB(255, 25, 25, 34),
                          fontSize: 32,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 24.0),
                  Container(
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 35, 148, 253),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(
                                LineAwesomeIcons.eye,
                                color: Colors.white,
                              ),
                              Text("Views",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.65),
                                      fontSize: 18)),
                              const Text("15",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          SizedBox(
                              height: 40,
                              child: VerticalDivider(
                                width: 36,
                                thickness: 2,
                                color: Colors.white.withOpacity(0.65),
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const Icon(
                                LineAwesomeIcons.alternate_comment,
                                color: Colors.white,
                              ),
                              Text("Posts",
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(0.65),
                                      fontSize: 18)),
                              const Text("10",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        ],
                      )),
                  const SizedBox(height: 28.0),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfilePage())),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 16.0,
                                        color: Colors.black.withOpacity(0.04),
                                        spreadRadius: 16.0,
                                        offset: const Offset(0, 2))
                                  ],
                                  color: Colors.white),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 16.0),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: 32,
                                        height: 32,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)),
                                            color: Color.fromARGB(
                                                48, 35, 148, 253)),
                                        child: const Icon(
                                          LineAwesomeIcons.pen,
                                          color:
                                              Color.fromARGB(255, 35, 148, 253),
                                        )),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                        child: Text("Edit Profile",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 25, 25, 34),
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold))),
                                    const Icon(
                                      LineAwesomeIcons.angle_right,
                                      color: Color.fromARGB(255, 35, 148, 253),
                                    )
                                  ])),
                        ),
                        const SizedBox(height: 18.0),
                        Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 16.0,
                                      color: Colors.black.withOpacity(0.04),
                                      spreadRadius: 16.0,
                                      offset: const Offset(0, 2))
                                ],
                                color: Colors.white),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 16.0),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          color:
                                              Color.fromARGB(48, 35, 148, 253)),
                                      child: const Icon(
                                        LineAwesomeIcons.alternate_sign_out,
                                        color:
                                            Color.fromARGB(255, 35, 148, 253),
                                      )),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                      child: Text("Logout",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 25, 25, 34),
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold))),
                                  GestureDetector(
                                    onTap: () {
                                      FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    },
                                    child: const Icon(
                                      LineAwesomeIcons.angle_right,
                                      color: Color.fromARGB(255, 35, 148, 253),
                                    ),
                                  )
                                ]))
                      ])
                ]),
          ),
          StreamBuilder(
              stream: getProfileImg(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Text(
                      'Document does not exist'); // Menangani kasus dokumen tidak ada
                } else {
                  profileImg = snapshot.data!['profileImg'] ?? '';
                  return Positioned(
                    top: -65,
                    width: 128,
                    height: 128,
                    child: Stack(
                      children: [
                        Container(
                          width: 130.0,
                          height: 130.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Container(
                              color: Colors
                                  .white, // Menambahkan latar belakang putih di sekitar gambar
                              child: Image(
                                image: NetworkImage(profileImg),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );

                }
              }),
        ]);
  }
}
