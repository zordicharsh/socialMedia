import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShareScreen extends StatefulWidget {
  final Postid;
  final Type;

  const ShareScreen({Key? key, required this.Postid, required this.Type})
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
        backgroundColor: Colors.white.withOpacity(0.15),
        title: const Text('Share'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Colors.grey[900],),
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
                              index == 0 ?  const SizedBox(
                                height: 16,
                              ): const SizedBox(
                                height: 8,
                              ),
                              index == 0 ? const Padding(
                                padding: EdgeInsets.fromLTRB(14, 8, 12, 12),
                                child: Text(
                                  "Friends",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ) : const SizedBox.shrink(),
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  backgroundImage: CachedNetworkImageProvider(doc[
                                      'profileurl']), // You can use a default image if profile picture is not available
                                ),
                                title: Text(
                                  doc['username'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  Map<String, dynamic> messageData = {
                                    'receiveruid': doc['uid'],
                                    'postid': widget.Postid,
                                    'posttype': widget.Type,
                                    'senderuid':
                                        FirebaseAuth.instance.currentUser!.uid,
                                    'timestamp': Timestamp.now(),
                                    'seen': false,
                                  };
                                  FirebaseFirestore.instance
                                      .collection('Chats')
                                      .add(messageData)
                                      .then((value) {})
                                      .catchError((error) {
                                    print("Failed to send message: $error");
                                  });

                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text("No data available"),
                      );
                    }
                  },
                )
              : const Center(
                  child: Text("Following list is empty"),
                ),
    );
  }
}
