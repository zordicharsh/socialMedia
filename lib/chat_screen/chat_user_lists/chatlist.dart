import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:socialmedia/chat_screen/main_chatscreen/chatscreen.dart';

class ChatLists extends StatefulWidget {
  const ChatLists({Key? key}) : super(key: key);

  @override
  State<ChatLists> createState() => _ChatListsState();
}

class _ChatListsState extends State<ChatLists> {
  List<dynamic> followingList = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getFollowingList();
  }

  void getFollowingList() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection("RegisteredUsers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      setState(() {
        followingList = snapshot.data()!['following'];
      });
    } catch (error) {
      print("Error fetching following list: $error");
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
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                prefixIcon:
                const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: Colors.transparent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(color: Colors.transparent),
                ),
              ),
            ),
          ),
          // List of chats
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text('No users found.'),
                  );
                }
                var userList = snapshot.data!.docs;
                // Filter the user list based on the search query
                var filteredUsers = userList.where((userDoc) {
                  var user = userDoc.data();
                  return user['username'].toString().toLowerCase().contains(_searchController.text.toLowerCase());}).toList();
                return ListView.builder(
                  itemCount: filteredUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    var user = filteredUsers[index].data();
                    return StreamBuilder<QuerySnapshot>(
                      stream: getUnreadMessagesStreamForUser(user['uid']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        int unreadCount = snapshot.data?.docs.length ?? 0;
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user['profileurl']),
                          ),
                          title: Text(user['username']),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  touid: user['uid'],
                                ),
                              ),
                            );
                          },
                          trailing: unreadCount > 0
                              ? Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              unreadCount.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                              ),
                            ),
                          )
                              : null,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
