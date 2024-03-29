import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/chat_screen/main_chatscreen/chatscreen.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';

class ChatLists extends StatefulWidget {
  const ChatLists({Key? key}) : super(key: key);

  @override
  State<ChatLists> createState() => _ChatListsState();
}

class _ChatListsState extends State<ChatLists> {
  List<dynamic> followingList = [];
  TextEditingController _searchController = TextEditingController();
  String? username;

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    await getFollowingList();
    print(username.toString());
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

  Stream<QuerySnapshot> getUnreadMessagesStreamForUser(String userId) {
    return FirebaseFirestore.instance
        .collection('Chats')
        .where('receiveruid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('senderuid', isEqualTo: userId)
        .where('seen', isEqualTo: false)
        .snapshots();
  }

  bool swipedBackToHomeScreen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          username.toString(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onPanUpdate: (details) async {
          if (details.delta.dx > 0) {
            log("right swiped");
            if (swipedBackToHomeScreen) {
              Navigator.pop(context);
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  setState(() {}); // Trigger rebuild on text change
                },
                decoration: InputDecoration(
                  hintText: " \"Enter username\" ",
                  contentPadding: EdgeInsets.zero,
                  filled: true,
                  fillColor: const Color.fromRGBO(90, 90, 90, 0.35),
                  labelStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(14, 0, 12, 12),
              child: Text(
                "Messages",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ),
            // List of chats
            Expanded(
              child: followingList.isEmpty
                  ? Center(
                      child: SizedBox(
                        height: 356.sp,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 200,
                              child: Image.asset(
                                "assets/images/connect_with_friends-removebg-preview.png",
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
                              "and start chatting with them",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.white60),
                            ),
                          ],
                        ),
                      ),
                    )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("RegisteredUsers")
                          .where('uid', whereIn: followingList)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.grey[900],
                            ),
                          );
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text(
                              'No users found.',
                              style: TextStyle(color: Colors.white38),
                            ),
                          );
                        }
                        var userList = snapshot.data!.docs;
                        // Filter the user list based on the search query
                        var filteredUsers = userList.where((userDoc) {
                          var user = userDoc.data();
                          return user['username']
                              .toString()
                              .toLowerCase()
                              .contains(_searchController.text.toLowerCase());
                        }).toList();
                        return ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (BuildContext context, int index) {
                            var user = filteredUsers[index].data();
                            return StreamBuilder<QuerySnapshot>(
                              stream:
                                  getUnreadMessagesStreamForUser(user['uid']),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Center(child: Text("Error"));
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator(
                                    color: Colors.grey[900],
                                  ));
                                }
                                /* else if(snapshot.data!.size == 0 ){
                                  return const Center(
                                    child: Text(
                                      'No users found.',
                                      style: TextStyle(color: Colors.white38),
                                    ),
                                  );
                                }*/
                                else {
                                  int unreadCount =
                                      snapshot.data?.docs.length ?? 0;
                                  return ListTile(
                                      splashColor: Colors.grey[900],
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            Colors.grey.withOpacity(0.3),
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                user['profileurl']),
                                      ),
                                      title: Text(user['username']),
                                      onTap: () async {
                                        await Future.delayed(
                                            const Duration(milliseconds: 200));
                                        if (!context.mounted) return;
                                        Navigator.push(
                                          context,
                                          CustomPageRouteRightToLeft(
                                            child: ChatScreen(
                                              touid: user['uid'],
                                            ),
                                          ),
                                        );
                                      },
                                      trailing: unreadCount > 0
                                          ? Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.grey[900],
                                                shape: BoxShape.circle,
                                              ),
                                              child: Text(
                                                unreadCount.toString(),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            )
                                          : const Icon(
                                              CupertinoIcons.chevron_right,
                                              size: 20,
                                            ));
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
