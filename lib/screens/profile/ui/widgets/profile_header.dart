import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/screens/profile/bloc/profile_bloc.dart';
import 'package:socialmedia/screens/profile/ui/widgets/elevated_button.dart';


import '../../../../global_Bloc/global_bloc.dart';
import '../../../../models/user_model.dart';

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
              BlocBuilder<GlobalBloc, GlobalState>(
                builder: (context, state) {
                  if (state is GetUserDataFromGlobalBlocState) {
                    List<UserModel> userdata = state.userData;
                    if (userdata[0].profileImage.toString() != "") {
                      return CircleAvatar(
                        backgroundColor: Colors.grey,
                       // backgroundImage: NetworkImage(userdata[0].profileImage.toString()),
                        radius: 36.sp,
                      );
                    } else {
                      return GestureDetector(
                        onTap: (){},
                        child: Stack(children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            radius: 36.sp,
                          ),
                          Positioned(
                              top: 48.sp,
                              left: 48.sp,
                              child: const CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 12,
                                child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 10,
                                    child: Center(
                                        child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 16,
                                    ))),
                              ))
                        ]),
                      );
                    }
                  } else {
                    return GestureDetector(
                      onTap: (){},
                      child: Stack(children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          radius: 36.sp,
                        ),
                        Positioned(
                            top: 48.sp,
                            left: 48.sp,
                            child: const CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 12,
                              child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 10,
                                  child: Center(
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 16,
                                      ))),
                            ))
                      ]),
                    );
                  }
                },
              ),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 1,
                child: BlocBuilder<GlobalBloc, GlobalState>(
                  builder: (context, state) {
                    if (state is GetUserDataFromGlobalBlocState) {
                      List<UserModel> userdata = state.userData;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            width: 24,
                          ),
                          buildStatColumn("15", "Posts"),
                          const SizedBox(
                            width: 16,
                          ),
                          buildStatColumn(
                              userdata[0].follower.length.toString(),
                              "Followers"),
                          const SizedBox(
                            width: 16,
                          ),
                          buildStatColumn(
                              userdata[0].following.length.toString(),
                              "Following"),
                        ],
                      );
                    } else {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                            width: 24,
                          ),
                          buildStatColumn("0", "Posts"),
                          const SizedBox(
                            width: 16,
                          ),
                          buildStatColumn("0", "Followers"),
                          const SizedBox(
                            width: 16,
                          ),
                          buildStatColumn("0", "Following"),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
          child: BlocBuilder<GlobalBloc, GlobalState>(
            builder: (context, state) {
              if (state is GetUserDataFromGlobalBlocState) {
                List<UserModel> userdata = state.userData;
                return Text(userdata[0].uid,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold));
              } else {
                return Text("Sussy Baka",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold));
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
          child: BlocBuilder<GlobalBloc, GlobalState>(
            builder: (context, state) {
              if (state is GetUserDataFromGlobalBlocState) {
                log("adding ProfilePageFetchUserPostEvent in bloc tree");
                BlocProvider.of<ProfileBloc>(context).add(ProfilePageFetchUserPostEvent(userid: state.userData[0].uid.toString()));
                List<UserModel> userdata = state.userData;
                return Text(userdata[0].email,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ));
              } else {
                return Text("Meow Meow😸",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.sp,
                    ));
              }
            },
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
            child: Row(children: [
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ProfileManipulationButton(
                        text: "Edit profile", height: 32, width: 160.sp),
                    ProfileManipulationButton(
                        text: "Share profile", height: 32, width: 160.sp),
                  ],
                ),
              )
            ])),
      ],
    );
  }

  Column buildStatColumn(String num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(num.toString(),
            style: TextStyle(
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
