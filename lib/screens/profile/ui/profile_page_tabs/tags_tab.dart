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
        child: Text(
          "Tags tab",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ));
  }
}
