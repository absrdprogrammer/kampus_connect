import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:kampus_connect/constants/my_text_style.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:kampus_connect/helper/helper_function.dart';
import 'package:kampus_connect/pages/home_screen.dart';
import 'package:kampus_connect/services/crud.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kampus_connect/widgets/textfield_widget.dart';
import 'package:random_string/random_string.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  FirestoreDatabase database = FirestoreDatabase();

  bool isTapped = false;
  String title = '';
  String description = '';

  File selectedImage = File('');
  CrudMethods crudMethods = CrudMethods();

  void getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void uploadInformation() async {
    if (title.trim() == "" ||
        description.trim() == "" ||
        selectedImage.isAbsolute != true) {
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
      showDialog(
        barrierDismissible: false,
          context: context,
          builder: (context) => const Center(
                child: CircularProgressIndicator(
                ),
              ));
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child("images/${randomAlphaNumeric(9)}.jpg");
      await storageReference.putFile(selectedImage);
      String imageUrl = await storageReference.getDownloadURL();

      print("this is url $imageUrl");

      CollectionReference postsCollection =
          FirebaseFirestore.instance.collection("Informations");

      final DocumentReference newPostRef = postsCollection.doc();

      await newPostRef.set({
        'postId': newPostRef.id,
        'creatorId': database.user!.uid,
        'imgUrl': imageUrl,
        'title': title,
        'desc': description,
        'timestamp': Timestamp.now().toDate()
      });

      // Membuat referensi untuk dokumen creator
      DocumentReference creatorRef = FirebaseFirestore.instance
          .collection("Creators")
          .doc(database.user!.uid);

      // Mengecek apakah dokumen sudah ada atau belum
      creatorRef.get().then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          // Jika dokumen sudah ada, lakukan increment pada totalPost
          creatorRef.update({
            'totalPosts': FieldValue.increment(1),
          }).then((_) {
            print('Total posts updated successfully!');
          }).catchError((error) {
            print('Error updating total posts: $error');
          });
        } else {
          // Jika dokumen belum ada, buat dokumen baru
          creatorRef.set({
            'username': database.user!.displayName,
            'totalViews': 0,
            'totalPosts': 1,
            'profileImg':
                'https://cdn3d.iconscout.com/3d/premium/thumb/man-avatar-6299539-5187871.png'
          }).then((_) {
            print('Creator document created successfully!');
          }).catchError((error) {
            print('Error creating creator document: $error');
          });
        }
      }).catchError((error) {
        print('Error getting creator document: $error');
      });

      setState(() {});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const InformationPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Post Article",
          style: TextStyle(fontSize: 22),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: GestureDetector(
                  onTap: getImage,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    height: 170,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child:
                        selectedImage != null && selectedImage.path.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  selectedImage,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.add_a_photo,
                                color: Colors.black45,
                              ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                padding: const EdgeInsets.all(30),
                // height: MediaQuery.of(context).size.height * 0.60,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Title",
                        style: MyTextStyle.headingOne,
                      ),
                      const Gap(6),
                      TextFieldWidget(
                        maxLine: 1,
                        hintText: 'Add title',
                        controller: titleController,
                        onTextChanged: (value) {
                          setState(() {
                            title = value;
                          });
                        },
                      ),
                      const Gap(12),
                      const Text(
                        "Description",
                        style: MyTextStyle.headingOne,
                      ),
                      const Gap(6),
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            onChanged: (value) {
                              description = value;
                            },
                            maxLines: null,
                            minLines: 5,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: "Add Description",
                            ),
                          )),
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
                                    borderRadius: BorderRadius.circular(8)),
                                side: BorderSide(
                                  color: Colors.blue.shade800,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          )),
                          const Gap(20),
                          Expanded(
                              child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                side: const BorderSide(
                                  color: Colors.blue,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14)),
                            onPressed: uploadInformation,
                            child: const Text('Upload'),
                          )),
                        ],
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
