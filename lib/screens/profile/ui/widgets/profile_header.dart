import 'package:flutter/material.dart';
import 'package:socialmedia/screens/profile/ui/widgets/elevated_button.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({super.key});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage("assets/images/cat_pic.jpg"),
                radius: 40,
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 24,
                    ),
                    buildStatColumn(15, "Posts"),
                    const SizedBox(
                      width: 16,
                    ),
                    buildStatColumn(105, "Followers"),
                    const SizedBox(
                      width: 16,
                    ),
                    buildStatColumn(311, "Following"),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
          child: Text("Sussy Baka",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
          child: Text("Meow Meow😸",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              )),
        ),
        const SizedBox(
          height: 16,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ProfileManipulationButton(
                  text: "Edit profile", height: 32, width: 184),
              ProfileManipulationButton(
                  text: "Share profile", height: 32, width: 184),
            ],
          ),
        ),
      ],
    );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(),
            style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.normal))
      ],
    );
  }
}
