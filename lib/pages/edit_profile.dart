import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:kampus_connect/helper/helper_function.dart';
import 'package:kampus_connect/pages/home.dart';
import 'package:kampus_connect/pages/home_screen.dart';
import 'package:kampus_connect/pages/profile.dart';
import 'package:kampus_connect/widgets/my_textfield.dart';
import 'package:random_string/random_string.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  FirestoreDatabase database = FirestoreDatabase();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController universityNameController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String username = '';
  String userData = '';
  String universityName = '';
  String universityData = '';
  String emailUser = '';
  String emailData = '';
  String profileImg = '';

  File? selectedImage;

  void getImage() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  void loadUserData() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(database.user!.email)
          .get();

      if (userSnapshot.exists) {
        setState(() {
          userData = userSnapshot['username'] ?? '';
          usernameController.text = userData;
          universityData = userSnapshot['university'] ?? '';
          universityNameController.text = universityData;
          emailData = userSnapshot['email'] ?? '';
          emailController.text = emailData;
          profileImg = userSnapshot['profileImg'] ?? '';

          print(profileImg);
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> editProfile() async {
    if (selectedImage != null &&
        selectedImage!.isAbsolute == true &&
        selectedImage!.path.isNotEmpty) {
      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child("images/${randomAlphaNumeric(9)}.jpg");
        await storageReference.putFile(selectedImage!);
        String imageUrl = await storageReference.getDownloadURL();

        // create user document and add to firestore
        FirebaseFirestore.instance
            .collection('Users')
            .doc(emailData)
            .update({'profileImg': imageUrl});
      } on FirebaseAuthException catch (e) {
        displayMessageToUser(e.code, context);
      }
    }
    if (username.trim().isNotEmpty && username != userData) {
      try {
        await FirebaseAuth.instance.currentUser!.updateDisplayName(username);
        // create user document and add to firestore
        FirebaseFirestore.instance
            .collection('Users')
            .doc(emailData)
            .update({'username': username});
      } on FirebaseAuthException catch (e) {
        displayMessageToUser(e.code, context);
      }
    }

    if (emailUser.trim().isNotEmpty && emailUser != emailData) {
      try {
        String? password = await _showPasswordDialog();
        print(password);
        if (emailUser.trim().isNotEmpty && emailUser != emailData) {
          try {
            String? password = await _showPasswordDialog();
            print('Password entered: $password');
            if (password != null) {
              print('Reauthenticating user...');
              await FirebaseAuth.instance.currentUser!
                  .reauthenticateWithCredential(EmailAuthProvider.credential(
                      email: emailData, password: password));
              print('Updating user email...');
              await FirebaseAuth.instance.currentUser!.updateEmail(emailUser);
              print('Updating user document in Firestore...');
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(emailData)
                  .update({'email': emailUser});
              print('Email updated successfully!');
            }
          } on FirebaseAuthException catch (e) {
            print('Error updating email: $e');
            displayMessageToUser(e.code, context);
          }
        }
      } on FirebaseAuthException catch (e) {
        displayMessageToUser(e.code, context);
      }
    }

    if (universityName.trim().isNotEmpty && universityName != universityData) {
      try {
        // create user document and add to firestore
        FirebaseFirestore.instance
            .collection('Users')
            .doc(emailData)
            .update({'university': universityName});
      } on FirebaseAuthException catch (e) {
        displayMessageToUser(e.code, context);
      }
    }

    setState(() {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const InformationPage(),
      ),
    );
  }

  Future<String?> _showPasswordDialog() async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String enteredPassword =
            ''; // Tambahkan variabel untuk menyimpan nilai password

        return AlertDialog(
          title: const Text('Enter Your Password'),
          content: TextField(
            obscureText: true,
            onChanged: (value) {
              enteredPassword =
                  value; // Simpan nilai password setiap kali ada perubahan
            },
            decoration: const InputDecoration(hintText: 'Password'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Tutup dialog tanpa mengembalikan nilai password
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(
                    enteredPassword); // Kembalikan nilai password saat tombol Confirm ditekan
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Container(
        padding: const EdgeInsets.only(left: 15, top: 40, right: 15),
        child: ListView(
          children: [
            Center(
              child: Stack(children: [
                Container(
                  width: 130.0,
                  height: 130.0,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    child: selectedImage != null &&
                            selectedImage!.isAbsolute == true &&
                            selectedImage!.path.isNotEmpty
                        ? ClipOval(
                            child: Image.file(
                              selectedImage!,
                              height: 130,
                              width: 130,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipOval(
                            child: Image(
                              image: NetworkImage(
                                  'https://cdn3d.iconscout.com/3d/premium/thumb/man-avatar-6299539-5187871.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: getImage,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 4, color: Colors.white),
                          color: Colors.blue),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ]),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: usernameController,
                      maxLines: null,
                      minLines: 1,
                      onChanged: (value) {
                        username = value;
                      },
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 1),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_2_outlined,
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade200, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: universityNameController,
                      maxLines: null,
                      minLines: 1,
                      onChanged: (value) {
                        universityName = value;
                      },
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 1),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          CupertinoIcons.building_2_fill,
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade200, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: emailController,
                      maxLines: null,
                      minLines: 1,
                      onChanged: (value) {
                        emailUser = value;
                      },
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          letterSpacing: 1),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: Colors.black,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.grey.shade200, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
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
                            padding: const EdgeInsets.symmetric(vertical: 14)),
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
                            padding: const EdgeInsets.symmetric(vertical: 14)),
                        onPressed: editProfile,
                        child: const Text('Update'),
                      )),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }
}
