import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kampus_connect/pages/login.dart';

class ChatDetailPageAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  void logout(BuildContext context) {
    FirebaseAuth.instance.signOut();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              // IconButton untuk kembali
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  // FirebaseAuth.instance.signOut();

                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const LoginPage(),
                  //   ),
                  // );
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 2),
              // CircleAvatar untuk profil grup
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue, // Sesuaikan dengan warna grup
                child: Icon(
                  Icons.group,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              // Expanded untuk memberikan ruang bagi nama grup dan status
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Text untuk nama grup
                    Text(
                      "Nama Grup",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 6),
                    // Text untuk status grup (Online, dll.)
                    Text(
                      "Online",
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                  ],
                ),
              ),
              // Icon untuk menu lebih banyak
              Icon(
                Icons.more_vert,
                color: Colors.grey.shade700,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
