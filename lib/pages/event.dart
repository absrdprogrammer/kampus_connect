import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kampus_connect/database/firestore.dart';

import 'package:kampus_connect/models/date_model.dart';
import 'package:kampus_connect/models/event_type_model.dart';
import 'package:kampus_connect/models/events_model.dart';
import 'package:kampus_connect/widgets/post_event.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  FirestoreDatabase database = FirestoreDatabase();
  List<DateModel> dates = [];
  String todayDateIs = '';

  List<EventTypeModel> eventsType = [
    EventTypeModel(
        imgAssetPath: "assets/images/concert.png", eventType: "Festival"),
    EventTypeModel(
        imgAssetPath: "assets/images/education.png", eventType: "Festival"),
    EventTypeModel(
        imgAssetPath: "assets/images/sports.png", eventType: "Festival"),
  ];

  @override
  void initState() {
    super.initState();
    dates = generateWeeklyDates();
    todayDateIs = getDateNow();
  }

  List<DateModel> generateWeeklyDates() {
    List<DateModel> dates = [];
    DateTime today = DateTime.now();
    DateTime firstDayOfThisWeek =
        today.subtract(Duration(days: today.weekday - 1));

    for (int i = 0; i < 7; i++) {
      DateTime date = firstDayOfThisWeek.add(Duration(days: i));
      String weekDay = _getWeekDay(date.weekday);
      dates.add(DateModel(weekDay: weekDay, date: date.day.toString()));
    }

    return dates;
  }

  String getDateNow() {
    DateTime today = DateTime.now();
    String dayNow = today.day.toString();

    return dayNow;
  }

  String _getWeekDay(int weekDay) {
    switch (weekDay) {
      case 1:
        return 'Sun';
      case 2:
        return 'Mon';
      case 3:
        return 'Tue';
      case 4:
        return 'Wed';
      case 5:
        return 'Thu';
      case 6:
        return 'Fri';
      case 7:
        return 'Sat';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => showModalBottomSheet(
          isScrollControlled: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          context: context,
          builder: (context) => AddEvent(),
        ),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Hello! ${database.user!.displayName}",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w700,
                                fontSize: 21),
                          ),
                          SizedBox(
                            height: 6,
                          ),
                          Text(
                            "Let's explore what’s happening nearby",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  /// Dates
                  Container(
                    height: 60,
                    child: ListView.builder(
                        itemCount: dates.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return DateTile(
                            weekDay: dates[index].weekDay,
                            date: dates[index].date,
                            isSelected: todayDateIs == dates[index].date,
                          );
                        }),
                  ),

                  const SizedBox(
                    height: 25,
                  ),
                  const Text(
                    "Ongoing Events",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance
                          .collection('Events')
                          .orderBy("timeStamp", descending: true)
                          .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        List<EventsModel> events = snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          return EventsModel(
                            eventId: data['postId'],
                            date: data['date'],
                            address: data['address'],
                            title: data['title'],
                            desc: data['desc'],
                            imgeAssetPath: "assets/images/calendar.png"
                          );
                        }).toList();
                      return ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          itemCount: events.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return PopularEventTile(
                              desc: events[index].title,
                              imgeAssetPath: events[index].imgeAssetPath,
                              date: events[index].date,
                              address: events[index].address,
                            );
                          });
                    }
                  ),

                  /// Popular Events
                  // const SizedBox(
                  //   height: 16,
                  // ),
                  // const Text(
                  //   "Upcoming Events",
                  //   style: TextStyle(color: Colors.black, fontSize: 20),
                  // ),
                  // ListView.builder(
                  //     padding: EdgeInsets.only(top: 10),
                  //     itemCount: events.length,
                  //     shrinkWrap: true,
                  //     itemBuilder: (context, index) {
                  //       return PopularEventTile(
                  //         desc: events[index].desc,
                  //         imgeAssetPath: events[index].imgeAssetPath,
                  //         date: events[index].date,
                  //         address: events[index].address,
                  //       );
                  //     })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DateTile extends StatelessWidget {
  String weekDay;
  String date;
  bool isSelected;

  DateTile(
      {super.key,
      required this.weekDay,
      required this.date,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          color: isSelected ? const Color(0xffFCCD00) : Colors.blue,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            date,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            weekDay,
            style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.w600),
          )
        ],
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  String imgAssetPath;
  String eventType;
  EventTile({super.key, required this.imgAssetPath, required this.eventType});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: const Color(0xff29404E),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            imgAssetPath,
            height: 27,
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            eventType,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}

class PopularEventTile extends StatelessWidget {
  String desc;
  String date;
  String address;
  String imgeAssetPath;

  /// later can be changed with imgUrl
  PopularEventTile(
      {super.key,
      required this.address,
      required this.date,
      required this.imgeAssetPath,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.blue, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16),
              width: MediaQuery.of(context).size.width - 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    desc,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/calender.png",
                        height: 15,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        date,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/images/location.png",
                        height: 15,
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        address,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8)),
              child: Image.asset(
                imgeAssetPath,
                height: 100,
                width: 120,
                fit: BoxFit.cover,
              )),
        ],
      ),
    );
  }
}
