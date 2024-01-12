import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kampus_connect/widgets/user_profile_image.dart';

class RoomUserProfile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double size;

  const RoomUserProfile({
    Key? key,
    required this.imageUrl,
    required this.name,
    this.size = 48.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(6.0),
              child: UserProfileImage(imageUrl: imageUrl, size: size),
            ),
          ],
        ),
        const SizedBox(height: 4.0),
        Flexible(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
