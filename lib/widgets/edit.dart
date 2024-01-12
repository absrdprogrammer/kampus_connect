import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:gap/gap.dart';

class EditAnnouncement extends StatefulWidget {
  final newPostController;
  final postDescription;
  final postId;
  EditAnnouncement(
      {super.key,
      this.newPostController,
      this.postDescription,
      required this.postId});

  @override
  State<EditAnnouncement> createState() => _EditNewpostState();
}

class _EditNewpostState extends State<EditAnnouncement> {
  TextEditingController textController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = widget.newPostController; // Set nilai default
    contentController.text = widget.postDescription;
    title = widget.newPostController;
    post = widget.postDescription;
  }

  FirestoreDatabase database = FirestoreDatabase();

  String title = '';
  String post = '';

  void editAnnouncement() {
    if (post.isNotEmpty && title.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('Announcements')
          .doc(widget.postId)
          .update({'title': title, 'content': post});

      post = '';
      title = '';
      setState(() {});
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: double.infinity,
              child: Text(
                "New Announcement",
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
                  controller: textController,
                  maxLines: 1,
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
                  controller: contentController,
                  maxLines: null,
                  minLines: 7,
                  onChanged: (value) {
                    post = value;
                  },
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Type something to announce...",
                  ),
                ),
              ),
            ),
            const Gap(30),
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
                    onPressed: editAnnouncement,
                    child: const Text('Post'),
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
