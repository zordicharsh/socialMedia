import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import 'package:socialmedia/global_Bloc/global_bloc.dart';
import 'package:socialmedia/screens/follow_request_screen/ui/followreuestscreen.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import '../../../common_widgets/single_item_state/single(post_card)state.dart';
import '../../../model/user_model.dart';
import '../../chat_screen/chat_user_lists/chatlist.dart';
import '../../videos_screen/ui/videopage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<HomeScreen> {
  String? username;
  TextEditingController comment = TextEditingController();
  String value = "post";
  bool swipedToChatList = true;
  bool isHeartAnimating = false;

  @override
  void initState() {
    BlocProvider.of<GlobalBloc>(context)
        .add(GetUserIDEvent(uid: FirebaseAuth.instance.currentUser!.uid));
    initializeData();
    super.initState();
  }

  Stream<QuerySnapshot> getUnreadMessagesStreamForUser(
      List currentUserFollowingdata) {
    return FirebaseFirestore.instance
        .collection('Chats')
        .where('receiveruid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('senderuid', whereIn: currentUserFollowingdata)
        .where('seen', isEqualTo: false)
        .snapshots();
  }

  getCurrentUserNameForZego() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("RegisteredUsers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      setState(() {
        username = snapshot.get('name');
      });
    } catch (error) {
      log("Error fetching following list: $error");
    }
  }

  void initializeData() async {
    await getCurrentUserNameForZego();
    log(username.toString());
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 2126705599,
      appSign:
          "707fa44ab5eaa519d60ebdb6a995d847c17108c877450576574c618ba3b680e2",
      userID: FirebaseAuth.instance.currentUser!.uid,
      userName: username.toString(),
      plugins: [ZegoUIKitSignalingPlugin()],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Row(
            children: [
              const Text('SocialRizz'),
              PopupMenuButton(
                icon: const Icon(Icons.arrow_drop_down),
                color: Colors.black,
                surfaceTintColor: Colors.black54,
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: "post",
                    child: Text("Posts"),
                  ),
                  const PopupMenuItem(
                    value: "video",
                    child: Text("Videos"),
                  ),
                ],
                onSelected: (newValue) {
                  setState(() {
                    value = newValue;
                  });
                },
              )
            ],
          ),
          leading: ModalRoute.of(context)?.canPop == true ? null : null,
          surfaceTintColor: Colors.black,
          actions: [
            IconButton(
                highlightColor: Colors.transparent,
                onPressed: () {
                  Navigator.push(
                      context,
                      CustomPageRouteRightToLeft(
                        child: const Request(),
                      ));
                },
                icon: const Icon(CupertinoIcons.bell)),
            Stack(
              children: [
                IconButton(
                    highlightColor: Colors.transparent,
                    onPressed: () async {
                      await Future.delayed(const Duration(milliseconds: 100));
                      if (!context.mounted) return;
                      Navigator.push(
                          context,
                          CustomPageRouteRightToLeft(
                            child: const ChatLists(),
                          ));
                      setState(() {
                        value = 'post';
                      });
                    },
                    icon: const Icon(CupertinoIcons.chat_bubble_2_fill)),
                BlocBuilder<GlobalBloc, GlobalState>(
                  builder: (context, state) {
                    if (state is GetUserDataFromGlobalBlocState) {
                      List<UserModel> userdata = state.userData;
                      return userdata[0].Following.isEmpty
                          ? const SizedBox.shrink()
                          : StreamBuilder(
                              stream: getUnreadMessagesStreamForUser(
                                  userdata[0].Following),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const SizedBox.shrink();
                                } else if (snapshot.hasData) {
                                  return snapshot.data!.docs.isNotEmpty
                                      ? Positioned(
                                          right: 9,
                                          bottom: 28,
                                          child: Container(
                                            padding: const EdgeInsets.all(1),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 16,
                                              minHeight: 16,
                                            ),
                                            child: Text(
                                              snapshot.data?.docs.length
                                                      .toString() ??
                                                  '',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 9.sp,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      : const SizedBox.shrink();
                                } else {
                                  return const SizedBox.shrink();
                                }
                              });
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ],
            )
          ],
        ),
        body: GestureDetector(
          onPanUpdate: (details) async {
            if (details.delta.dx < 0) {
              log("left swiped");
              if (swipedToChatList && value == 'post') {
                Navigator.push(
                    context,
                    CustomPageRouteRightToLeft(
                      child: const ChatLists(),
                    ));
              }
            }
          },
          child: BlocBuilder<GlobalBloc, GlobalState>(
            builder: (context, state) {
              if (state is GetUserDataFromGlobalBlocState) {
                List<UserModel> userdata = state.userData;
                return Builder(
                  builder: (context) {
                    if (value == "post") {
                      return userdata[0].Following.isNotEmpty
                          ? StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("UserPost")
                                  .where('uid', whereIn: userdata[0].Following)
                                  .where('type', isEqualTo: "image")
                                  .orderBy('uploadtime', descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(
                                    child: Text("Error"),
                                  );
                                } else if (snapshot.hasData) {
                                  List<
                                          QueryDocumentSnapshot<
                                              Map<String, dynamic>>>
                                      followingUsersPost = snapshot.data!.docs;

                                  return followingUsersPost.isEmpty
                                      ? Center(
                                          child: SizedBox(
                                          height: 300.sp,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 200,
                                                child: Image.asset(
                                                  "assets/images/homepage_for_new_acc.png",
                                                ),
                                              ),
                                              const Text(
                                                "Follow Like-Minds",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white),
                                              ),
                                              const Text(
                                                "to see their posts here",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white60),
                                              ),
                                            ],
                                          ),
                                        ))
                                      : RefreshIndicator(
                                          color: Colors.white.withOpacity(0.65),
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.15),
                                          onRefresh: _onrefresh,
                                          child: ListView.builder(
                                            itemCount:
                                                followingUsersPost.length,
                                            itemBuilder: (context, index) {
                                              log(index.toString());

                                              if (followingUsersPost[index]
                                                      .data()["type"] ==
                                                  "image") {
                                                bool isLiked = snapshot
                                                    .data!.docs[index]['likes']
                                                    .contains(FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .uid);

                                                return SingleImagePostCardItemState(
                                                  postdata: snapshot
                                                      .data!.docs[index]
                                                      .data(),
                                                  isLiked: isLiked,
                                                  value: value,
                                                );
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                        );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              })
                          : Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              height: double.infinity,
                              child: Center(
                                  child: SizedBox(
                                height: 300.sp,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      child: Image.asset(
                                        "assets/images/homepage_for_new_acc.png",
                                      ),
                                    ),
                                    const Text(
                                      "Follow Like-Minds",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                    const Text(
                                      "to see their posts here",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white60),
                                    ),
                                  ],
                                ),
                              )),
                            );
                    } else {
                      return userdata[0].Following.isNotEmpty
                          ? StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("UserPost")
                                  .where('uid', whereIn: userdata[0].Following)
                                  .where('type', isEqualTo: "video")
                                  .orderBy("uploadtime", descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  List<DocumentSnapshot> filteredList = [];
                                  for (var doc in snapshot.data!.docs) {
                                    filteredList.add(doc);
                                  }
                                  // Concatenate the filtered list with other videos
                                  return PageView.builder(
                                    onPageChanged: (int page) {},
                                    scrollDirection: Axis.vertical,
                                    itemCount: filteredList.length,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          VideoPage(
                                            postid: filteredList[index]
                                                ['postid'],
                                            uid: filteredList[index]['uid'],
                                            fromWhere: 'homeScreen',
                                            userdata: userdata,
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            )
                          : Container(
                              color: Colors.transparent,
                              width: double.infinity,
                              height: double.infinity,
                              child: Center(
                                  child: SizedBox(
                                height: 300.sp,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      child: Image.asset(
                                        "assets/images/homepage_for_new_acc.png",
                                      ),
                                    ),
                                    const Text(
                                      "Follow Like-Minds",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                    const Text(
                                      "to see their reels here",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white60),
                                    ),
                                  ],
                                ),
                              )),
                            );
                    }
                  },
                );
              } else {
                return Center(
                    child: CircularProgressIndicator(color: Colors.grey[900]));
              }
            },
          ),
        ));
  }

  Future<void> _onrefresh() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }
}
