import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kampus_connect/database/firestore.dart';
import 'package:kampus_connect/pages/home_screen.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({Key? key}) : super(key: key);

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  FirestoreDatabase database = FirestoreDatabase();
  bool isVerified = false;

  Future<bool> checkEmailVerification() async {
    if (database.user != null) {
      if (database.user!.emailVerified) {
        print('Email sudah diverifikasi');
        return true;
      } else {
        print('Email belum diverifikasi');
        return false;
      }
    } else {
      print('Tidak ada pengguna yang sedang masuk');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();

    checkEmailVerification();
    print(isVerified);
  }

  void sendEmail(BuildContext context) async {
    try {
      await database.user!.sendEmailVerification();
      // Tampilkan dialog setelah email berhasil dikirim
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Email Sent'),
            content:
                const Text('Verification email has been sent successfully.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InformationPage()));
                },
              ),
            ],
          );
        },
      );
    } catch (error) {
      print('Error sending email: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify Email"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: isVerified == false
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.email,
                      size: 100,
                      color: Colors.blue,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      "Verify Your Email Address",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      "We will send you the verification email link. Please click the button below",
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(
                            color: Colors.blue,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () =>
                            sendEmail(context), // Perubahan di sini
                        child: const Text(
                          'Send Link',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                )
              : const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      CupertinoIcons.check_mark_circled,
                      size: 100,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Your email has been verified",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
        ),
      ),
    );
  }
}
