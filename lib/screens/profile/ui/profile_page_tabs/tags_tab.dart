import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileTagSection extends StatefulWidget {
  const ProfileTagSection({super.key});

  @override
  State<ProfileTagSection> createState() => _ProfileTagSectionState();
}

class _ProfileTagSectionState extends State<ProfileTagSection> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 42,
              child: Icon(
                CupertinoIcons.person_crop_square,
                size: 38,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            "No posts yet",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
