import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShareScreen extends StatefulWidget {
  final Postid;
  final Type;
  const ShareScreen({Key? key, required this.Postid, required this.Type}) : super(key: key);

  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  List<dynamic> followingList = [];
  bool isLoading = true;

  void getFollowingList() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
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
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Chats'),
      ),
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : followingList.isNotEmpty
          ? StreamBuilder(
        stream: FirebaseFirestore.instance.collection("RegisteredUsers").where('uid', whereIn: followingList).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var doc = snapshot.data!.docs[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        doc['profileurl']
                    ), // You can use a default image if profile picture is not available
                  ),
                  title: Text(
                    doc['username'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                        Map<String, dynamic> messageData = {
                          'receiveruid': doc['uid'],
                          'postid':widget.Postid,
                          'posttype': widget.Type,
                          'senderuid': FirebaseAuth.instance.currentUser!.uid,
                          'timestamp': Timestamp.now(),
                          'seen': false,
                        };
                        FirebaseFirestore.instance.collection('Chats').add(messageData).then((value) {
                        }).catchError((error) {
                          print("Failed to send message: $error");
                        });

                    Navigator.pop(context);
                  },
                );
              },
            );
          } else {
            return Center(
              child: Text("No data available"),
            );
          }
        },
      )
          : Center(
        child: Text("Following list is empty"),
      ),
    );
  }
}
