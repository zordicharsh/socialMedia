import 'package:flutter/material.dart';
import 'package:socialmedia/screens/profile/ui/widgets/elevated_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: const AssetImage("assets/images/cat_pic.jpg"),
                radius: 36.sp,
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
          child: Text("Sussy Baka",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold)),
        ),
       Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
          child: Text("Meow Meow😸",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              )),
        ),
        const SizedBox(
          height: 16,
        ),
  Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
          child: Row(
            children: [
              Expanded(flex:1,child:   Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              ProfileManipulationButton(
                  text: "Edit profile", height: 32, width: 160.sp),
                  ProfileManipulationButton(
                  text: "Share profile", height: 32, width:160.sp),
                  ],
                  ),
          )
            ]
          )
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
            style:  TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.normal))
      ],
    );
  }
}
