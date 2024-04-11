import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShareScreen extends StatefulWidget {
  final String Postid;
  final String Profileid;
  final String Type;
  final String? Profileurl;
  final String Username;
  final String? name;

  const ShareScreen(
      {Key? key,
      this.Type = "",
      this.Postid = "",
      this.Profileid = "",
      this.Profileurl = "",
      this.Username = "",
      this.name = ""})
      : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  List<dynamic> followingList = [];
  bool isLoading = true;

  void getFollowingList() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection("RegisteredUsers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      // Access the "following" array from the document snapshot
      setState(() {
        followingList = snapshot.data()!['following'];
        isLoading = false;
      });
    } catch (error) {
      log("Error fetching following list: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getFollowingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white.withOpacity(0.15),
        title: const Text('Share'),
      ),
      body: isLoading
          ? const Center(
              child: SizedBox.shrink(),
            )
          : followingList.isNotEmpty
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("RegisteredUsers")
                      .where('uid', whereIn: followingList)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var doc = snapshot.data!.docs[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              index == 0
                                  ? const SizedBox(
                                      height: 16,
                                    )
                                  : const SizedBox(
                                      height: 8,
                                    ),
                              index == 0
                                  ? const Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(14, 8, 12, 12),
                                      child: Text(
                                        "Friends",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              ListTile(
                                leading: doc['profileurl'] != ""
                                    ? CachedNetworkImage(
                                        imageUrl: doc['profileurl'],
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                CircleAvatar(
                                          radius: 18.1.sp,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            backgroundImage: imageProvider,
                                            radius: 18.sp,
                                          ),
                                        ),
                                        placeholder: (context, url) =>
                                            CircleAvatar(
                                          radius: 18.1.sp,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey[900],
                                            radius: 18.sp,
                                          ),
                                        ),
                                      )
                                    : CircleAvatar(
                                        radius: 18.1.sp,
                                        backgroundColor: Colors.white,
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.black.withOpacity(0.8),
                                          radius: 18.sp,
                                          child: Icon(Icons.person,
                                              color: Colors.black
                                                  .withOpacity(0.5)),
                                        ),
                                      ),
                                title: Text(
                                  doc['name'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  doc['username'],
                                  style: const TextStyle(
                                      color: Colors.white54, fontSize: 12),
                                ),
                                onTap: widget.Postid != "" && widget.Type != ""
                                    ? () {
                                        Navigator.pop(context);
                                        Map<String, dynamic> messageData = {
                                          'receiveruid': doc['uid'],
                                          'postid': widget.Postid,
                                          'posttype': widget.Type,
                                          'senderuid': FirebaseAuth
                                              .instance.currentUser!.uid,
                                          'timestamp': Timestamp.now(),
                                          'seen': false,
                                        };
                                        FirebaseFirestore.instance
                                            .collection('Chats')
                                            .add(messageData)
                                            .then((value) {})
                                            .catchError((error) {});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor: Colors
                                                    .grey[900]!
                                                    .withOpacity(0.8),
                                                duration: const Duration(
                                                    milliseconds: 800),
                                                elevation: 8,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                margin: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.5,
                                                  right: 172,
                                                  left: 172,
                                                ),
                                                content: const Text(
                                                  "Sent",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                )));
                                      }
                                    : () {
                                        Navigator.pop(context);
                                        Map<String, dynamic> messageData = {
                                          'receiveruid': doc['uid'],
                                          'profileid': widget.Profileid,
                                          'profileurl': widget.Profileurl,
                                          'username': widget.Username,
                                          'name': widget.name,
                                          'senderuid': FirebaseAuth
                                              .instance.currentUser!.uid,
                                          'timestamp': Timestamp.now(),
                                          'seen': false,
                                        };
                                        FirebaseFirestore.instance
                                            .collection('Chats')
                                            .add(messageData)
                                            .then((value) {})
                                            .catchError((error) {});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                backgroundColor: Colors
                                                    .grey[900]!
                                                    .withOpacity(0.8),
                                                duration: const Duration(
                                                    milliseconds: 800),
                                                elevation: 8,
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8)),
                                                margin: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2.5,
                                                  right: 172,
                                                  left: 172,
                                                ),
                                                content: const Text(
                                                  "Sent",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                  textAlign: TextAlign.center,
                                                )));
                                      },
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
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.08),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 128,
                            child: Image.asset(
                              "assets/images/connect_with_friends.png",
                            ),
                          ),
                          const Text(
                            "Make Friends",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                          const Text(
                            "and share posts with them",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white60),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
