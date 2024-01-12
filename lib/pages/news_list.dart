import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:kampus_connect/constants/app_styles.dart';
import 'package:kampus_connect/models/information.dart';
import 'package:kampus_connect/pages/news_detail_screen.dart';

class InformationListPage extends StatefulWidget {
  final bool isAdmin;
  InformationListPage({super.key, required this.isAdmin});

  @override
  State<InformationListPage> createState() => _InformationListPageState();
}

class _InformationListPageState extends State<InformationListPage> {
  DateFormat dateFormat = DateFormat('E, d LLLL   H:m a');
  DateFormat secondFormatter = DateFormat('d LLLL y');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Information'),
      ),
      body: StreamBuilder(
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
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: informations.length,
              itemBuilder: (context, index) {
                Information information = informations[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NewsDetailScreen(
                                  date: secondFormatter.format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          information
                                              .date.microsecondsSinceEpoch)),
                                  imgUrl: information.imgUrl,
                                  title: information.title,
                                  desc: information.desc,
                                )));
                  },
                  child: Container(
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
                        Container(
                          height: 164,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(kBorderRadius),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(information.imgUrl),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Text(
                          information.desc,
                          style: kPoppinsBold.copyWith(
                            fontSize: 15,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Posted:',
                                      style: kPoppinsSemibold.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      dateFormat.format(
                                          DateTime.fromMicrosecondsSinceEpoch(
                                              information
                                                  .date.microsecondsSinceEpoch)),
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
                              visible: widget.isAdmin,
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    builder: (context) => AlertDialog(
                                      title: const Text('Are you sure?'),
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
                                                .collection("Informations")
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
                                    borderRadius:
                                        BorderRadius.circular(kBorderRadius),
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
    );
  }
}
