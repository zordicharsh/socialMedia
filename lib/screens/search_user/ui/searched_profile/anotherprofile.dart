import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile.dart';
import 'package:socialmedia/screens/search_user/ui/searched_profile/searched_profile_page_tabs/searched_profile_post_gallery.dart';
import 'package:socialmedia/screens/search_user/ui/searched_profile/searched_profile_page_tabs/searched_profile_reel_gallery.dart';
import 'package:socialmedia/screens/search_user/ui/searched_profile/searched_profile_page_tabs/searched_profile_tags_gallery.dart';
import '../../../../common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import '../../../chat_screen/sharelist.dart';
import '../../../followings_and_followers/ui/Followers.dart';
import '../../../followings_and_followers/ui/Followings.dart';
import '../../../profile/ui/widgets/elevated_button.dart';

class AnotherUserProfile extends StatefulWidget {
  final String uid;
  final String username;

  const AnotherUserProfile(
      {Key? key, required this.uid, required this.username})
      : super(key: key);

  @override
  State<AnotherUserProfile> createState() => _AnotherUserProfileState();
}

class _AnotherUserProfileState extends State<AnotherUserProfile> {
  late Stream<DocumentSnapshot> _userDataStream;
  late DocumentReference
      _currentUserRef; // Reference to current user's document
  late DocumentReference
      _anotherUserRef; // Reference to current user's document
  late bool isRequested;

  @override
  void initState() {
    _userDataStream = FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(widget.uid)
        .snapshots();
    // Get reference to current user's document
    _currentUserRef = FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    _anotherUserRef = FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(widget.uid);
    log(widget.uid);

   /* BlocProvider.of<ProfileBloc>(context)
        .add(ProfilePageFetchUserPostEvent(userid: widget.uid));*/
    super.initState();
  }

  // Function to handle the follow button press
  void _handleFollow(var userData) {
    bool isFollowing =
        userData['follower'].contains(FirebaseAuth.instance.currentUser!.uid);
    bool isRequestedFromDatabase = userData['followrequest']
        .contains(FirebaseAuth.instance.currentUser!.uid);
    if (isFollowing) {
      // Unfollow the user
      _anotherUserRef.update({
        'follower':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      }).then((_) {
        log('User unfollowed successfully');
      }).catchError((error) {
        log('Failed to unfollow user: $error');
      });
      _currentUserRef.update({
        'following': FieldValue.arrayRemove([widget.uid])
      }).then((_) {
        log('User unfollowed successfully');
      }).catchError((error) {
        log('Failed to unfollow user: $error');
      });
    } else if (isRequestedFromDatabase) {
      _anotherUserRef.update({
        'followrequest':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      }).then((_) {
        log('User followed successfully');
        setState(() {
          isRequested = false;
        });
      }).catchError((error) {
        log('Failed to follow user: $error');
      });
      _anotherUserRef.update({
        'followrequestnotification':
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      }).then((_) {
        log('User followed successfully');
        setState(() {
          isRequested = false;
        });
      }).catchError((error) {
        log('Failed to follow user: $error');
      });
    } else {
      // Follow the user
      if (userData['acctype'] == 'private') {
        _anotherUserRef.update({
          'followrequest':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        }).then((_) {
          log('User followed successfully');
          setState(() {
            isRequested = true;
          });
        }).catchError((error) {
          log('Failed to follow user: $error');
        });
        _anotherUserRef.update({
          'followrequestnotification':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        }).then((_) {
          log('User follow request notification added successfully');
        }).catchError((error) {
          log('Failed to follow user: $error');
        });
      } else {
        _currentUserRef.update({
          'following': FieldValue.arrayUnion([widget.uid])
        }).catchError((error) {
          log('Failed to follow user: $error');
        });
        _anotherUserRef.update({
          'follower':
              FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
        }).then((_) {
          log('User followed successfully');
        }).catchError((error) {
          log('Failed to follow user: $error');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          scrolledUnderElevation: 0,
          title: Column(
            children: [
              Text(widget.username),
            ],
          ),
        ),
        body: NestedScrollView(
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      StreamBuilder(
                        stream: _userDataStream,
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }
                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return const SizedBox.shrink();
                          }
                          var userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          bool isFollowing = userData['follower']
                              .contains(FirebaseAuth.instance.currentUser!.uid);
                          bool isRequested = userData['followrequest']
                              .contains(FirebaseAuth.instance.currentUser!.uid);
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      userData['profileurl'] != ""
                                          ? CachedNetworkImage(
                                              imageUrl: userData['profileurl'],
                                              filterQuality: FilterQuality.low,
                                              placeholder: (context, url) =>
                                                  CircleAvatar(
                                                backgroundColor: Colors.grey
                                                    .withOpacity(0.3),
                                                radius: 36.sp,
                                              ),
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      CircleAvatar(
                                                backgroundColor: Colors.grey
                                                    .withOpacity(0.4),
                                                backgroundImage: imageProvider,
                                                radius: 36.sp,
                                              ),
                                            )
                                          : widget.uid ==
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid
                                              ? GestureDetector(
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      CustomPageRouteRightToLeft(
                                                        child:
                                                            const EditProfile(),
                                                      )),
                                                  child: Stack(children: [
                                                    CircleAvatar(
                                                      backgroundColor: Colors
                                                          .grey
                                                          .withOpacity(0.3),
                                                      radius: 36.sp,
                                                      child: Icon(
                                                        Icons.person,
                                                        size: 66,
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        top: 48.sp,
                                                        left: 48.sp,
                                                        child:
                                                            const CircleAvatar(
                                                          backgroundColor:
                                                              Colors.black,
                                                          radius: 12,
                                                          child: CircleAvatar(
                                                              backgroundColor:
                                                                  Colors.blue,
                                                              radius: 10,
                                                              child: Center(
                                                                  child: Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                                size: 16,
                                                              ))),
                                                        ))
                                                  ]),
                                                )
                                              : CircleAvatar(
                                                  backgroundColor: Colors.grey
                                                      .withOpacity(0.3),
                                                  radius: 36.sp,
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 66,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              const SizedBox(
                                                width: 24,
                                              ),
                                              buildStatColumn(
                                                  userData['totalposts'],
                                                  "Posts"),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              userData['acctype'] == 'public' ||
                                                      isFollowing ||
                                                      widget.uid ==
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                  ? GestureDetector(
                                                      child: buildStatColumn(
                                                          userData['follower']
                                                              .length,
                                                          "Followers"),
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            CustomPageRouteRightToLeft(
                                                                child: Followers(
                                                                    userData[
                                                                        'uid'])));
                                                      },
                                                    )
                                                  : buildStatColumn(
                                                      userData['follower']
                                                          .length,
                                                      "Followers"),
                                              const SizedBox(
                                                width: 16,
                                              ),
                                              userData['acctype'] == 'public' ||
                                                      isFollowing ||
                                                      widget.uid ==
                                                          FirebaseAuth.instance
                                                              .currentUser!.uid
                                                  ? GestureDetector(
                                                      child: buildStatColumn(
                                                          userData["following"]
                                                              .length,
                                                          "Following"),
                                                      onTap: () {
                                                        userData["uid"];
                                                        Navigator.push(
                                                            context,
                                                            CustomPageRouteRightToLeft(
                                                              child: Following(
                                                                  userData[
                                                                      "uid"]),
                                                            ));
                                                      },
                                                    )
                                                  : buildStatColumn(
                                                      userData["following"]
                                                          .length,
                                                      "Following"),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 16),
                                  child: Text(userData["name"],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold)),
                                ),
                                userData["bio"] != ""
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 16),
                                        child: Text(userData["bio"],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                            )),
                                      )
                                    : const SizedBox.shrink(),
                                const SizedBox(height: 16),
                                // Replace ElevatedButton widget with a custom button

                                widget.uid ==
                                        FirebaseAuth.instance.currentUser!.uid
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 16),
                                        child: Row(children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                ProfileManipulationButton(
                                                    text: "Edit profile",
                                                    height: 32,
                                                    width: 160.sp,
                                                    onTap: () => Navigator.push(
                                                        context,
                                                        CustomPageRouteRightToLeft(
                                                          child:
                                                              const EditProfile(),
                                                        ))),
                                                ProfileManipulationButton(
                                                  text: "Share profile",
                                                  height: 32,
                                                  width: 160.sp,
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) =>
                                                            ShareScreen(
                                                              Profileid:
                                                                  userData[
                                                                      'uid'],
                                                              Profileurl: userData[
                                                                  'profileurl'],
                                                              Username: userData[
                                                                  'username'],
                                                              name: userData[
                                                                  'name'],
                                                            ),
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxHeight:
                                                                    400));
                                                  },
                                                )
                                              ],
                                            ),
                                          )
                                        ]))
                                    : Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 0.0, horizontal: 16),
                                        child: Row(children: [
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                SizedBox(
                                                  height: 32,
                                                  width: 160.sp,
                                                  child: ElevatedButton(
                                                    onPressed: () =>
                                                        _handleFollow(userData),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      elevation: 0,
                                                      foregroundColor:
                                                          isFollowing
                                                              ? Colors.black12
                                                              : null,
                                                      splashFactory: NoSplash
                                                          .splashFactory,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              4),
                                                      backgroundColor:
                                                          isFollowing
                                                              ? Colors.grey
                                                                  .withOpacity(
                                                                      0.2)
                                                              : isRequested
                                                                  ? Colors.grey
                                                                      .withOpacity(
                                                                          0.2)
                                                                  : Colors.blue,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8)),
                                                    ),
                                                    child: isFollowing == false
                                                        ? Text(
                                                            isRequested
                                                                ? 'Requested   📩'
                                                                : 'Follow',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white,
                                                            ))
                                                        : Text(
                                                            isRequested
                                                                ? 'Requested'
                                                                : 'Following',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                  ),
                                                ),
                                                ProfileManipulationButton(
                                                  text: "Share profile",
                                                  height: 32,
                                                  width: 160.sp,
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (context) =>
                                                            ShareScreen(
                                                              Profileid:
                                                                  userData[
                                                                      'uid'],
                                                              Profileurl: userData[
                                                                  'profileurl'],
                                                              Username: userData[
                                                                  'username'],
                                                              name: userData[
                                                                  'name'],
                                                            ),
                                                        constraints:
                                                            const BoxConstraints(
                                                                maxHeight:
                                                                    400));
                                                  },
                                                )
                                              ],
                                            ),
                                          )
                                        ])),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: StreamBuilder(
              stream: _userDataStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox.shrink();
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.transparent,
                    child: Center(
                      child: SizedBox(
                        height: 240.sp,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              width: double.infinity,
                              child:
                                  Image.asset("assets/images/noUsersFound.png"),
                            ),
                            const Text(
                              "Uh-oh!",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            const Text(
                              "User not found. ",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white60,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                var userData = snapshot.data?.data() as Map<String, dynamic>;
                var followerRequestPending = userData['followrequest']
                    .contains(FirebaseAuth.instance.currentUser!.uid);
                bool isFollowing = userData['follower']
                    .contains(FirebaseAuth.instance.currentUser!.uid);
                if (widget.uid == FirebaseAuth.instance.currentUser!.uid) {
                  return DefaultTabController(
                    length: 3,
                    animationDuration: const Duration(milliseconds: 600),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 2),
                          child: TabBar(
                              physics: const BouncingScrollPhysics(),
                              dividerColor: Colors.white.withOpacity(0.1),
                              indicatorColor: Colors.white,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorWeight: 1.5,
                              unselectedLabelColor: Colors.grey,
                              labelColor: Colors.white,
                              splashFactory: NoSplash.splashFactory,
                              overlayColor: MaterialStateProperty.resolveWith(
                                (Set states) {
                                  return states.contains(MaterialState.focused)
                                      ? null
                                      : Colors.transparent;
                                },
                              ),
                              tabs: const [
                                Tab(
                                  child: Icon(
                                    Icons.grid_on_rounded,
                                  ),
                                ),
                                Tab(
                                  child: Icon(
                                    size: 28,
                                    Icons.video_library_outlined,
                                  ),
                                ),
                                Tab(
                                  child: Icon(
                                      size: 28,
                                      CupertinoIcons.person_crop_square),
                                ),
                              ]),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 4),
                            child: TabBarView(children: [
                              SearchedProfilePostGallery(uid: widget.uid),
                              SearchedProfileReelSection(
                                  searchedUserId: widget.uid),
                              const SearchedProfileTagSection(),
                            ]),
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  if (userData['acctype'] == 'private') {
                    if (followerRequestPending == false &&
                        isFollowing == true) {
                      return DefaultTabController(
                        length: 3,
                        animationDuration: const Duration(milliseconds: 600),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 2),
                              child: TabBar(
                                  physics: const BouncingScrollPhysics(),
                                  dividerColor: Colors.white.withOpacity(0.1),
                                  indicatorColor: Colors.white,
                                  indicatorSize: TabBarIndicatorSize.tab,
                                  indicatorWeight: 1.5,
                                  unselectedLabelColor: Colors.grey,
                                  labelColor: Colors.white,
                                  splashFactory: NoSplash.splashFactory,
                                  overlayColor:
                                      MaterialStateProperty.resolveWith(
                                    (Set states) {
                                      return states
                                              .contains(MaterialState.focused)
                                          ? null
                                          : Colors.transparent;
                                    },
                                  ),
                                  tabs: const [
                                    Tab(
                                      child: Icon(
                                        Icons.grid_on_rounded,
                                      ),
                                    ),
                                    Tab(
                                      child: Icon(
                                        size: 28,
                                        Icons.video_library_outlined,
                                      ),
                                    ),
                                    Tab(
                                      child: Icon(
                                          size: 28,
                                          CupertinoIcons.person_crop_square),
                                    ),
                                  ]),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 4),
                                child: TabBarView(children: [
                                  SearchedProfilePostGallery(uid: widget.uid),
                                  SearchedProfileReelSection(
                                      searchedUserId: widget.uid),
                                  const SearchedProfileTagSection(),
                                ]),
                              ),
                            )
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          const Divider(
                            color: Colors.white10,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 21,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.black,
                                    radius: 20,
                                    child: Center(
                                      child: Icon(
                                        CupertinoIcons.lock,
                                        size: 28,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "This account is private",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.5.sp),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "Follow ${widget.username} to see their photos and videos.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white60,
                                          fontSize: 12.5.sp),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    }
                  } else {
                    return DefaultTabController(
                      length: 3,
                      animationDuration: const Duration(milliseconds: 600),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 2),
                            child: TabBar(
                                physics: const BouncingScrollPhysics(),
                                dividerColor: Colors.white.withOpacity(0.1),
                                indicatorColor: Colors.white,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicatorWeight: 1.5,
                                unselectedLabelColor: Colors.grey,
                                labelColor: Colors.white,
                                splashFactory: NoSplash.splashFactory,
                                overlayColor: MaterialStateProperty.resolveWith(
                                  (Set states) {
                                    return states
                                            .contains(MaterialState.focused)
                                        ? null
                                        : Colors.transparent;
                                  },
                                ),
                                tabs: const [
                                  Tab(
                                    child: Icon(
                                      Icons.grid_on_rounded,
                                    ),
                                  ),
                                  Tab(
                                    child: Icon(
                                      size: 28,
                                      Icons.video_library_outlined,
                                    ),
                                  ),
                                  Tab(
                                    child: Icon(
                                        size: 28,
                                        CupertinoIcons.person_crop_square),
                                  ),
                                ]),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 4),
                              child: TabBarView(children: [
                                SearchedProfilePostGallery(uid: widget.uid),
                                SearchedProfileReelSection(
                                    searchedUserId: widget.uid),
                                const SearchedProfileTagSection(),
                              ]),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                }
              },
            )));
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
