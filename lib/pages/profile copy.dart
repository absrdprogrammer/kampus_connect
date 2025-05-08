import 'package:flutter/material.dart';
import 'package:kampus_connect/widgets/profile_widget.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(LineAwesomeIcons.angle_left)),
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontSize: 20)),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 200,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Image(image: AssetImage('assets/images/hello-image.png'))),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.amber),
                      child: const Icon(
                        LineAwesomeIcons.alternate_pencil,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Username',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 25)),
              const SizedBox(height: 10),
              Text('Email user',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text('Edit profile',
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                ),
              ),
              const SizedBox(height: 50),

              /// -- MENU

              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                  title: "Report",
                  icon: Icons.report_problem_outlined,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Feedback",
                  icon: Icons.feedback_outlined,
                  onPress: () {}),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: LineAwesomeIcons.alternate_sign_out,
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
