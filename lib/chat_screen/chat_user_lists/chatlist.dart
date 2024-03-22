import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/chat_screen/main_chatscreen/chatscreen.dart';

class ChatLists extends StatefulWidget {
  const ChatLists({Key? key}) : super(key: key);

  @override
  State<ChatLists> createState() => _ChatListsState();
}

class _ChatListsState extends State<ChatLists> {
  List<dynamic> followingList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFollowingList();
  }

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
      });
    } catch (error) {
      log("Error fetching following list: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: SizedBox(
              height: 50, // Specify the desired height here
              child: TextField(
                decoration: InputDecoration(
                  fillColor: Colors.black54,
                  hintText: 'Search',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white54,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: followingList.isEmpty
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("RegisteredUsers")
                        .where('uid', whereIn: followingList)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!
                              .size, // Adjust this to your actual item count
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    snapshot.data!.docs[index]['profileurl']), // Provide your user's avatar image here
                              ),
                              title: Text(
                                  snapshot.data!.docs[index]['username']), // Provide your user's name here
                              subtitle: Text(
                                  'Last message'), // Provide the last message here
                              onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(touid: snapshot.data!.docs[index]['uid']),));
                              },
                            );
                          },
                        );
                      } else {
                        return SizedBox();
                      }
                    }),
          ),
        ],
      ),
    );
  }
}
