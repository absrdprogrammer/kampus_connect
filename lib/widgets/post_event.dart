import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:gap/gap.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({super.key});

  @override
  State<AddEvent> createState() => _AddNewpostState();
}

class _AddNewpostState extends State<AddEvent> {
  final TextEditingController newPostController = TextEditingController();
  DateTime? pickedDate;
  TimeOfDay? pickedTime;
  DateTime? _selectedDateTime;

  FirestoreDatabase database = FirestoreDatabase();

  String title = '';
  String desc = '';
  String address = '';
  String dateText = 'dd/mm/yy';
  String timeText = 'hh : mm';
  int selectedCategory = 0;

  final List<String> categories = [
    'Sport',
    'Festival',
    'Learning',
    'Competition'
  ];

  Future<void> selectedDate() async {
    pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate!.isAfter(DateTime.now())) {
      setState(() {
        dateText =
            "${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}";
      });
    }
  }

  Future<void> selectedTime() async {
    pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
    );

    if (pickedTime != null) {
      String amPm = pickedTime!.hour < 12 ? 'AM' : 'PM';
      setState(() {
        timeText = "${pickedTime!.hour} : ${pickedTime!.minute} $amPm";
      });
    }
  }

  void postEvent() {
    if (desc.trim() == '' || title.trim() == '') {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                'Warning',
                textAlign: TextAlign.center,
              ),
              content: const Text('Konten masih kosong'),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    } else {
      String amPm = pickedTime!.hour < 12 ? 'AM' : 'PM';
      String dateTimeEvent = "${pickedDate!.day} ${pickedDate!.month}, ${pickedDate!.year}  ${pickedTime!.hour} : ${pickedTime!.minute} $amPm";
      database.addEvent(title, address, desc, dateTimeEvent);
      desc = '';
      title = '';
      address = '';
      setState(() {});
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            left: 30,
            right: 30,
            top: 30,
            bottom: MediaQuery.of(context).viewInsets.bottom + 30),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                "New Event",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const Divider(
              thickness: 1.2,
              color: Colors.grey,
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                child: TextField(
                  autofocus: true,
                  maxLines: 3,
                  onChanged: (value) {
                    title = value;
                  },
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Title",
                  ),
                ),
              ),
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                child: TextField(
                  autofocus: true,
                  maxLines: 1,
                  onChanged: (value) {
                    address = value;
                  },
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Address",
                  ),
                ),
              ),
            ),
            const Gap(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                child: TextField(
                  maxLines: null,
                  minLines: 7,
                  onChanged: (value) {
                    desc = value;
                  },
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Add Description",
                  ),
                ),
              ),
            ),
            const Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: selectedDate,
                        ),
                        Text(dateText)
                      ],
                    ),
                  ),
                ),
                const Gap(22),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade200,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(CupertinoIcons.time),
                          onPressed: selectedTime,
                        ),
                        Text(timeText)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Gap(20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue.shade800,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                        color: Colors.blue.shade800,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const Gap(20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade800,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      side: BorderSide(
                        color: Colors.blue.shade800,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: postEvent,
                    child: const Text('Add'),
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
