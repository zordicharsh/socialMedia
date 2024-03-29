import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:socialmedia/chat_screen/chat_user_lists/chatlist.dart';
import 'package:socialmedia/chat_screen/sharelist.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import 'package:socialmedia/screens/follow_request_screen/followreuestscreen.dart';
import 'package:socialmedia/screens/profile/ui/widgets/comment.dart';
import 'package:socialmedia/screens/search_user/searchui/searched_profile/anotherprofile.dart';
import 'package:socialmedia/screens/videoscreen/ui/widgets/home_side_bar.dart';
import 'package:socialmedia/screens/videoscreen/ui/widgets/video_details.dart';
import 'package:socialmedia/screens/videoscreen/ui/widgets/video_tile.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:zoom_pinch_overlay/zoom_pinch_overlay.dart';

import '../../profile/bloc/profile_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> followingList = [];
  String? username;
  late Stream<DocumentSnapshot> _currentUserDataStream;
  TextEditingController comment = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  getCurrentUserDataStream() {
    return _currentUserDataStream = FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  void initializeData() async {
    await getFollowingList();
    await getCurrentUserDataStream();
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

  getFollowingList() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("RegisteredUsers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Access the "following" array from the document snapshot
      setState(() {
        username = snapshot.get('username');
        followingList = snapshot.data()!['following'];
      });
    } catch (error) {
      log("Error fetching following list: $error");
    }
  }

  String value = "post";
  int _snappedPageIndex = 0;
  bool swipedToChatList = true;

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
                    },
                    icon: const Icon(CupertinoIcons.chat_bubble_2_fill)),
                Positioned(
                  right: 9,
                  bottom: 28,
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      "4",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
          child: Builder(
            builder: (context) {
              if (value == "post") {
                if (followingList.isEmpty) {
                  return Center(
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
                          style: TextStyle(fontSize: 16, color: Colors.white60),
                        ),
                      ],
                    ),
                  ));
                } else {
                  return RefreshIndicator(
                    color: Colors.white.withOpacity(0.65),
                    backgroundColor: Colors.grey.withOpacity(0.15),
                    onRefresh: _onrefresh,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("UserPost")
                            .where('uid', whereIn: followingList)
                            .where('type', isEqualTo: "image")
                            .orderBy("uploadtime", descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                              child: Text("Error"),
                            );
                          } else if (snapshot.hasData) {
                            return ListView.builder(
                              itemCount: snapshot.data!.size,
                              // Replace 10 with your actual item count
                              itemBuilder: (context, index) {
                                List likes =
                                    snapshot.data!.docs[index].data()["likes"];
                                log(index.toString());
                                if (snapshot.data!.docs[index].data()["type"] ==
                                    "image") {
                                  final islike = likes.contains(
                                      FirebaseAuth.instance.currentUser!.uid);
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16,
                                            bottom: 4,
                                            right: 8,
                                            left: 12),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: () => Navigator.push(
                                                  context,
                                                  CustomPageRouteRightToLeft(child: AnotherUserProfile(uid: snapshot.data!.docs[index]
                                                      .data()["uid"], username:snapshot.data!.docs[index]
                                                      .data()["username"]),
                                                  ),),
                                                child: Row(
                                                  children: [
                                                    snapshot.data!.docs[index]
                                                                    .data()[
                                                                'profileurl'] !=
                                                            ""
                                                        ? CachedNetworkImage(
                                                            imageUrl: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .data()[
                                                                'profileurl'],
                                                            imageBuilder: (context,
                                                                    imageProvider) =>
                                                                CircleAvatar(
                                                              radius: 14.1.sp,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              child: CircleAvatar(
                                                                backgroundColor:
                                                                    Colors.grey,
                                                                backgroundImage:
                                                                    imageProvider,
                                                                radius: 14.sp,
                                                              ),
                                                            ),
                                                          )
                                                        : CircleAvatar(
                                                            radius: 14.1.sp,
                                                            backgroundColor:
                                                                Colors.white,
                                                            child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.black
                                                                      .withOpacity(
                                                                          0.8),
                                                              radius: 14.sp,
                                                              child: Icon(
                                                                  Icons.person,
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.5)),
                                                            ),
                                                          ),

                                                    const SizedBox(
                                                      width: 12,
                                                    ),
                                                    Text(
                                                      snapshot.data!.docs[index]
                                                          .data()["username"],
                                                      // Replace with actual username
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ), //username

                                                  ],
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  IconButton(
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (context) => Container(
                                                            width: double.infinity,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(16),
                                                              color: Colors.grey[900],
                                                            ),
                                                            height:
                                                            MediaQuery.of(context).size.height / 8,
                                                            child: Padding(
                                                              padding: const EdgeInsets.symmetric(
                                                                  vertical: 8, horizontal: 10),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment.start,
                                                                children: [
                                                                  GestureDetector(
                                                                      onTap: () => Navigator.pop(context),
                                                                      child: const Icon(
                                                                        CupertinoIcons.xmark_circle,
                                                                        size: 32,
                                                                        color: Colors.grey,
                                                                      )),
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(
                                                                        left: 6.0),
                                                                    child: MaterialButton(
                                                                        color: Colors.grey[900],
                                                                        padding: const EdgeInsets.only(
                                                                            top: 20),
                                                                        highlightColor:
                                                                        Colors.transparent,
                                                                        splashColor: Colors.transparent,
                                                                        elevation: 0,
                                                                        focusElevation: 0,
                                                                        highlightElevation: 0,
                                                                        onPressed: () {
                                                                          if ( snapshot.data!.docs[index].data()['uid'] == FirebaseAuth.instance.currentUser!.uid) {
                                                                            showCupertinoDialog(
                                                                              context: context,
                                                                              builder: (context) =>
                                                                                  CupertinoAlertDialog(
                                                                                    title: const Text(
                                                                                      "Alert !",
                                                                                      style: TextStyle(
                                                                                          fontSize: 20),
                                                                                    ),
                                                                                    content: const Text(
                                                                                      "Are you sure you want to delete this post?",
                                                                                      style: TextStyle(
                                                                                          fontSize: 16),
                                                                                    ),
                                                                                    actions: <CupertinoDialogAction>[
                                                                                      CupertinoDialogAction(
                                                                                          isDestructiveAction:
                                                                                          false,
                                                                                          onPressed: () {
                                                                                            Navigator.pop(
                                                                                                context);
                                                                                            Navigator.pop(
                                                                                                context);
                                                                                          },
                                                                                          child: const Text(
                                                                                            "No",
                                                                                            style: TextStyle(
                                                                                                color: Colors
                                                                                                    .white60),
                                                                                          )),
                                                                                      CupertinoDialogAction(
                                                                                          isDestructiveAction:
                                                                                          true,
                                                                                          onPressed: () {
                                                                                            BlocProvider.of<
                                                                                                ProfileBloc>(
                                                                                                context)
                                                                                                .add(
                                                                                                DeletePostEvent(
                                                                                                  snapshot.data!.docs[index].data()
                                                                                                  [
                                                                                                  'postid'],
                                                                                                ));
                                                                                            Navigator.pop(
                                                                                                context);
                                                                                            Navigator.pop(
                                                                                                context);
                                                                                          },
                                                                                          child: const Text(
                                                                                              "Yes")),
                                                                                    ],
                                                                                  ),
                                                                            );
                                                                          }
                                                                          else {
                                                                            Navigator.pop(context);
                                                                            ScaffoldMessenger.of(
                                                                                context)
                                                                                .showSnackBar(SnackBar(
                                                                                backgroundColor:
                                                                                Colors
                                                                                    .grey[900],
                                                                                duration:
                                                                                const Duration(
                                                                                    milliseconds:
                                                                                    800),
                                                                                elevation: 8,
                                                                                behavior:
                                                                                SnackBarBehavior
                                                                                    .floating,
                                                                                shape: RoundedRectangleBorder(
                                                                                    borderRadius:
                                                                                    BorderRadius
                                                                                        .circular(
                                                                                        20)),
                                                                                margin:
                                                                                EdgeInsets.only(
                                                                                  bottom: MediaQuery.of(
                                                                                      context)
                                                                                      .size
                                                                                      .height -
                                                                                      192,
                                                                                  right: 12,
                                                                                  left: 12,
                                                                                ),
                                                                                content:
                                                                                const Column(
                                                                                  crossAxisAlignment:
                                                                                  CrossAxisAlignment
                                                                                      .start,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding:
                                                                                      EdgeInsets
                                                                                          .all(
                                                                                          4.0),
                                                                                      child: Text(
                                                                                        "Oops! ",
                                                                                        style: TextStyle(
                                                                                            fontSize:
                                                                                            20,
                                                                                            fontWeight:
                                                                                            FontWeight
                                                                                                .bold,
                                                                                            color: Colors
                                                                                                .white),
                                                                                      ),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding:
                                                                                      EdgeInsets
                                                                                          .all(
                                                                                          4.0),
                                                                                      child: Text(
                                                                                        "Currently this feature is under development.",
                                                                                        style: TextStyle(
                                                                                            fontSize:
                                                                                            16,
                                                                                            color: Colors
                                                                                                .white54),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                )));
                                                                          }
                                                                        },
                                                                        child: Row(
                                                                          children: [
                                                                            snapshot.data!.docs[index].data()
                                                                            ['uid'] ==
                                                                                FirebaseAuth
                                                                                    .instance
                                                                                    .currentUser!
                                                                                    .uid
                                                                                ? const Icon(
                                                                              CupertinoIcons
                                                                                  .delete,
                                                                              color: Colors.red,
                                                                              size: 20,
                                                                            )
                                                                                : const Icon(
                                                                              CupertinoIcons
                                                                                  .exclamationmark_triangle,
                                                                              color: Colors.red,
                                                                              size: 20,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 20,
                                                                            ),
                                                                            snapshot.data!.docs[index].data()
                                                                            ['uid'] ==
                                                                                FirebaseAuth
                                                                                    .instance
                                                                                    .currentUser!
                                                                                    .uid
                                                                                ? const Text(
                                                                              "Delete Post",
                                                                              style: TextStyle(
                                                                                  color:
                                                                                  Colors.red,
                                                                                  fontSize: 16,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .w400),
                                                                            )
                                                                                : const Text(
                                                                              "Report",
                                                                              style: TextStyle(
                                                                                  color:
                                                                                  Colors.red,
                                                                                  fontSize: 16,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .w400),
                                                                            ),
                                                                          ],
                                                                        )),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          backgroundColor: Colors.transparent);
                                                    },
                                                    highlightColor: Colors.transparent,
                                                    icon: const Icon(
                                                        Icons.more_vert_sharp),
                                                    color: Colors.white,
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ), //post Title
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.45,
                                        width: double.infinity,
                                        child: ZoomOverlay(
                                          modalBarrierColor: Colors.black12,
                                          minScale: 0.5,
                                          maxScale: 3.0,
                                          animationCurve: Curves.fastOutSlowIn,
                                          animationDuration:
                                              const Duration(milliseconds: 300),
                                          twoTouchOnly: true,
                                          onScaleStart: () {},
                                          onScaleStop: () {},
                                          child: Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: Image(
                                                    fit: BoxFit.cover,
                                                    filterQuality:
                                                        FilterQuality.high,
                                                    image:
                                                        CachedNetworkImageProvider(
                                                      snapshot.data!.docs[index]
                                                          .data()["posturl"],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ), //post
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                highlightColor:
                                                    Colors.transparent,
                                                onPressed: () {
                                                  if (islike) {
                                                    DocumentReference
                                                        currentUserRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'UserPost')
                                                            .doc(snapshot.data!
                                                                    .docs[index]
                                                                    .data()[
                                                                "postid"]);
                                                    currentUserRef.update({
                                                      'likes': FieldValue
                                                          .arrayRemove([
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                      ])
                                                    });
                                                  } else {
                                                    DocumentReference
                                                        currentUserRef =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'UserPost')
                                                            .doc(snapshot.data!
                                                                    .docs[index]
                                                                    .data()[
                                                                "postid"]);
                                                    currentUserRef.update({
                                                      'likes': FieldValue
                                                          .arrayUnion([
                                                        FirebaseAuth.instance
                                                            .currentUser!.uid
                                                      ])
                                                    });
                                                  }
                                                },
                                                icon: islike
                                                    ? const Icon(
                                                        CupertinoIcons
                                                            .heart_fill,
                                                        color: Colors.redAccent,
                                                      )
                                                    : const Icon(
                                                        CupertinoIcons.heart),
                                              ),
                                              IconButton(
                                                highlightColor:
                                                    Colors.transparent,
                                                icon: const Icon(
                                                  CupertinoIcons.chat_bubble,
                                                ),
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    elevation: 0,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    context: context,
                                                    builder: (context) {
                                                      return DraggableScrollableSheet(
                                                          snap: true,
                                                          snapSizes: const [
                                                            0.71,
                                                            0.72
                                                          ],
                                                          maxChildSize: 0.96,
                                                          initialChildSize:
                                                              0.96,
                                                          minChildSize: 0.4,
                                                          builder: (context,
                                                                  scrollController) =>
                                                              CommentSection(
                                                                postId: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                        .data()[
                                                                    "postid"],
                                                                scrollController:
                                                                    scrollController,
                                                                username: snapshot
                                                                        .data!
                                                                        .docs[index]
                                                                        .data()[
                                                                    "username"],
                                                                uidofpostuploader:
                                                                    snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .data()["uid"],
                                                              ));
                                                    },
                                                  );
                                                },
                                              ),
                                              IconButton(
                                                highlightColor:
                                                    Colors.transparent,
                                                icon: const Icon(
                                                  CupertinoIcons.paperplane,
                                                ),
                                                onPressed: () {
                                                  showModalBottomSheet(
                                                      context: context,
                                                      builder: (context) =>
                                                          ShareScreen(
                                                              Postid: snapshot
                                                                      .data!
                                                                      .docs[index]
                                                                      .data()[
                                                                  "postid"],
                                                              Type: snapshot
                                                                      .data!
                                                                      .docs[index]
                                                                      .data()[
                                                                  "type"]),
                                                      constraints:
                                                          const BoxConstraints(
                                                              maxHeight: 400));
                                                },
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                highlightColor:
                                                    Colors.transparent,
                                                onPressed: () {
                                                  ScaffoldMessenger.of(
                                                      context)
                                                      .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                      Colors
                                                          .grey[900],
                                                      duration:
                                                      const Duration(
                                                          milliseconds:
                                                          800),
                                                      elevation: 8,
                                                      behavior:
                                                      SnackBarBehavior
                                                          .floating,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                          BorderRadius
                                                              .circular(
                                                              20)),
                                                      margin:
                                                      EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .height -
                                                            220,
                                                        right: 12,
                                                        left: 12,
                                                      ),
                                                      content:
                                                      const Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            EdgeInsets
                                                                .all(
                                                                4.0),
                                                            child: Text(
                                                              "Oops! ",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  20,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                            EdgeInsets
                                                                .all(
                                                                4.0),
                                                            child: Text(
                                                              "Currently bookmarking a post feature is under development.",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                  16,
                                                                  color: Colors
                                                                      .white54),
                                                            ),
                                                          )
                                                        ],
                                                      )));
                                                },
                                                icon: const Icon(
                                                  CupertinoIcons.bookmark,
                                                  size: 24,
                                                ),
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ],
                                      ), //action button
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 12),
                                        child: Text("${likes.length} likes"),
                                      ), //like stats
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12, right: 16),
                                          child: ReadMoreText(
                                            snapshot.data!.docs[index]
                                                .data()["caption"],
                                            delimiter: '...',
                                            preDataText: snapshot
                                                .data!.docs[index]
                                                .data()['username'],
                                            preDataTextStyle: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                            trimCollapsedText: 'View More',
                                            trimExpandedText: '  View Less',
                                            trimMode: TrimMode.Length,
                                            trimLength: 64,
                                            moreStyle: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.white60,
                                            ),
                                            lessStyle: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.white60,
                                            ),
                                          )), //caption
                                      snapshot.data!.docs[index]
                                                  .data()["totalcomments"] >
                                              2
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0,
                                                  right: 12,
                                                  left: 12,
                                                  bottom: 4),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      elevation: 0,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      context: context,
                                                      builder: (context) {
                                                        return DraggableScrollableSheet(
                                                            snap: true,
                                                            snapSizes: const [
                                                              0.71,
                                                              0.72
                                                            ],
                                                            maxChildSize: 0.96,
                                                            initialChildSize:
                                                                0.96,
                                                            minChildSize: 0.4,
                                                            builder: (context,
                                                                    scrollController) =>
                                                                CommentSection(
                                                                  postId: snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()[
                                                                      'postid'],
                                                                  scrollController:
                                                                      scrollController,
                                                                  username: snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()[
                                                                      'username'],
                                                                  uidofpostuploader:
                                                                      snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .data()['uid'],
                                                                ));
                                                      },
                                                    );
                                                  },
                                                  child: Text(
                                                      "View all ${snapshot.data!.docs[index].data()["totalcomments"]} comments",
                                                      style: const TextStyle(
                                                          color:
                                                              Colors.white60))),
                                            )
                                          : Row(
                                              children: [
                                                StreamBuilder(
                                                  stream:
                                                      _currentUserDataStream,
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 12.0),
                                                        child: CircleAvatar(
                                                          radius: 12.1,
                                                          backgroundColor:
                                                              Colors.white,
                                                          child: CircleAvatar(
                                                            backgroundColor:
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.8),
                                                            radius: 12,
                                                          ),
                                                        ),
                                                      );
                                                    } else if (snapshot
                                                        .hasError) {
                                                      return const Text(
                                                          "error");
                                                    } else {
                                                      var userData =
                                                          snapshot.data!.data()
                                                              as Map<String,
                                                                  dynamic>;
                                                      return userData[
                                                                  'profileurl'] !=
                                                              ""
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          12.0),
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: userData[
                                                                    'profileurl'],
                                                                imageBuilder: (context,
                                                                        imageProvider) =>
                                                                    CircleAvatar(
                                                                  radius: 12.1,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  child:
                                                                      CircleAvatar(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .grey,
                                                                    backgroundImage:
                                                                        imageProvider,
                                                                    radius: 12,
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          12.0),
                                                              child:
                                                                  CircleAvatar(
                                                                radius: 12.1,
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                child:
                                                                    CircleAvatar(
                                                                  backgroundColor: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.8),
                                                                  radius: 12,
                                                                  child: Icon(
                                                                      Icons
                                                                          .person,
                                                                      color: Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.5)),
                                                                ),
                                                              ),
                                                            );
                                                    }
                                                  },
                                                ),
                                                const SizedBox(
                                                  width: 12,
                                                ),
                                                SizedBox(
                                                  height: 40.h,
                                                  width: 224.w,
                                                  child: TextField(
                                                    style: TextStyle(
                                                        fontSize: 11.sp),
                                                    // onChanged: (value) => _showCommentShareButton(value),
                                                    controller: comment,
                                                    // autofocus: true,
                                                    readOnly: true,
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        elevation: 0,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        context: context,
                                                        builder: (context) {
                                                          return DraggableScrollableSheet(
                                                              snap: true,
                                                              snapSizes: const [
                                                                0.71,
                                                                0.72
                                                              ],
                                                              maxChildSize:
                                                                  0.96,
                                                              initialChildSize:
                                                                  0.96,
                                                              minChildSize: 0.4,
                                                              builder: (context,
                                                                      scrollController) =>
                                                                  CommentSection(
                                                                    postId: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .data()['postid'],
                                                                    scrollController:
                                                                        scrollController,
                                                                    username: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .data()['username'],
                                                                    uidofpostuploader: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .data()['uid'],
                                                                  ));
                                                        },
                                                      );
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText: snapshot.data!
                                                                      .docs[index]
                                                                      .data()[
                                                                  'uid'] ==
                                                              FirebaseAuth
                                                                  .instance
                                                                  .currentUser
                                                                  ?.uid
                                                          ? 'Add a comment...'
                                                          : 'Add a comment for ${snapshot.data!.docs[index].data()['username']}...',
                                                      hintStyle: TextStyle(
                                                          fontSize: 10.sp,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color:
                                                              Colors.white70),
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ), //total comments
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 12),
                                        child: Text(
                                            DateFormat.d().add_yMMM().format(
                                                snapshot.data!.docs[index]
                                                    .data()['uploadtime']
                                                    .toDate()),
                                            style: const TextStyle(
                                                color: Colors.white60)),
                                      ),
                                      const SizedBox(
                                        height: 16,
                                      ),
                                    ],
                                  );
                                } else {
                                  return const SizedBox();
                                }
                              },
                            );
                          } else {
                            return Center(
                                child: CircularProgressIndicator(
                                    color: Colors.grey[900]));
                          }
                        }),
                  );
                }
              } else {
                if (followingList.isEmpty) {
                  return Center(
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
                          style: TextStyle(fontSize: 16, color: Colors.white60),
                        ),
                      ],
                    ),
                  ));
                } else {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("UserPost")
                        .where('uid', whereIn: followingList)
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
                          onPageChanged: (int page) {
                            setState(() {
                              _snappedPageIndex = page;
                            });
                          },
                          scrollDirection: Axis.vertical,
                          itemCount: filteredList.length,
                          itemBuilder: (context, index) {
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                VideoTile(
                                  video: filteredList[index]['posturl'],
                                  currentIndex: index,
                                  snappedPageIndex: _snappedPageIndex,
                                  filteredList: filteredList,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                4,
                                        child: VideoDetails(
                                          username: filteredList[index]
                                              ['username'],
                                          caption: filteredList[index]
                                              ['caption'],
                                          profileUrl: filteredList[index]
                                              ['profileurl'],
                                          UploaderUid: filteredList[index]
                                              ['uid'],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                1.75,
                                        child: HomeSideBar(
                                          likes: filteredList[index]['likes'],
                                          profileUrl: filteredList[index]
                                              ['profileurl'],
                                          PostId: filteredList[index]['postid'],
                                          UploaderUid: filteredList[index]
                                              ['uid'],
                                          username: filteredList[index]
                                              ['username'],
                                          noofcomments: filteredList[index]
                                              ['totalcomments'],
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        return Container(
                          color: Colors.white,
                        );
                      }
                    },
                  );
                } // video post tile
              }
            },
          ),
        ));
  }

  Future<void> _onrefresh() {
    setState(() {});
    return Future.delayed(const Duration(seconds: 1));
  }
}
