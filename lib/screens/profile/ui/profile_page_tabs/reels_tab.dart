import 'package:flutter/material.dart';

class ProfileReelSection extends StatefulWidget {
  const ProfileReelSection({super.key});

  @override
  State<ProfileReelSection> createState() => _ProfileReelSectionState();
}

class _ProfileReelSectionState extends State<ProfileReelSection> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
          "Reels tab",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }
}
