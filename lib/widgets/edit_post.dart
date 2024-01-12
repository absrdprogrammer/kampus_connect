import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:gap/gap.dart';

class EditPost extends StatefulWidget {
  final postController;
  final postId;
  EditPost({super.key, this.postController, this.postId});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final editPostController = TextEditingController();
  FirestoreDatabase database = FirestoreDatabase();

  @override
  void initState() {
    super.initState();
    editPostController.text = widget.postController; // Set nilai default
    post = widget.postController;
  }

  String post = '';

  void editPost() {
    if (post.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('Posts')
          .doc(widget.postId)
          .update({'content': post});

      post = '';
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
                "New Post",
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
                  controller: editPostController,
                  maxLines: null,
                  minLines: 5,
                  onChanged: (value) {
                    post = value;
                  },
                  decoration: const InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "Type something to post...",
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
                    onPressed: editPost,
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
