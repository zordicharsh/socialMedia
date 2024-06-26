import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile.dart';
import 'package:socialmedia/screens/profile/ui/widgets/elevated_button.dart';
import '../../../../global_Bloc/global_bloc.dart';
import '../../../../model/user_model.dart';
import '../../../chat_screen/sharelist.dart';
import '../../../followings_and_followers/ui/Followers.dart';
import '../../../followings_and_followers/ui/Followings.dart';

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
                    if (userdata[0].Profileurl.toString() != "") {
                      return CachedNetworkImage(
                        imageUrl: userdata[0].Profileurl.toString(),
                        filterQuality: FilterQuality.low,
                        placeholder: (context, url) => CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          radius: 36.sp,
                        ),
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(0.4),
                          backgroundImage: imageProvider,
                          radius: 36.sp,
                        ),
                      );
                    } else {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            CustomPageRouteRightToLeft(
                              child: const EditProfile(),
                            )),
                        child: Stack(children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            radius: 36.sp,
                            child: Icon(Icons.person,size: 66,color: Colors.black.withOpacity(0.5),),
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
                      onTap: () => Navigator.push(
                          context,
                          CustomPageRouteRightToLeft(
                            child: const EditProfile(),
                          )),
                      child: Stack(children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          radius: 36.sp,
                          child: Icon(Icons.person,size: 66,color: Colors.black.withOpacity(0.5),),
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
                          buildStatColumn(userdata[0].TotalPosts, "Posts"),
                          const SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            child: buildStatColumn(
                                userdata[0].Follower.length, "Followers"),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CustomPageRouteRightToLeft(
                                          child: Followers(userdata[0].Uid))).then((value) => setState((){}));
                            },
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            child: buildStatColumn(
                                userdata[0].Following.length, "Following"),
                            onTap: () {
                              userdata[0].Uid;
                              Navigator.push(
                                  context,
                                  CustomPageRouteRightToLeft(
                                    child:
                                        Following(userdata[0].Uid),
                                  )).then((value) => setState((){}));
                            },
                          ),
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
                          buildStatColumn(0, "Posts"),
                          const SizedBox(
                            width: 16,
                          ),
                          buildStatColumn(0, "Followers"),
                          const SizedBox(
                            width: 16,
                          ),
                          buildStatColumn(0, "Following"),
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
                return Text(userdata[0].Name.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold));
              } else {
                return Text("",
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
                List<UserModel> userdata = state.userData;
                /* BlocProvider.of<ProfileBloc>(context).add(
                    ProfilePageFetchUserPostEvent(userid: userdata[0].Uid));*/
                if (userdata[0].Bio.toString() != "") {
                  return Text(userdata[0].Bio.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ));
                } 
                else {
                  return const SizedBox.shrink();
                }
              } else {
                return const SizedBox.shrink();
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
                        text: "Edit profile",
                        height: 32,
                        width: 160.sp,
                        onTap: () => Navigator.push(
                            context,
                            CustomPageRouteRightToLeft(
                              child: const EditProfile(),
                            ))),
                    BlocBuilder<GlobalBloc, GlobalState>(
  builder: (context, state) {
    if (state is GetUserDataFromGlobalBlocState) {
      List<UserModel> userdata = state.userData;
      return ProfileManipulationButton(
        text: "Share profile",
        height: 32,
        width: 160.sp,
        onTap: () {
          showModalBottomSheet(
              useSafeArea: true,
              context: context,
              builder: (context) =>
                  ShareScreen(
                      Profileid: userdata[0].Uid,
                    Profileurl: userdata[0].Profileurl,
                    Username:userdata[0].Username ,
                    name: userdata[0].Name,
                  ),
              constraints: const BoxConstraints(maxHeight: 400));
        },

      );
    }else{
      return ProfileManipulationButton(
        text: "Share profile",
        height: 32,
        width: 160.sp,
        onTap: () {},
      );
    }
  },
)
                  ],
                ),
              )
            ])),
      ],
    );
  }

  Column buildStatColumn(int? num, String label) {
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
