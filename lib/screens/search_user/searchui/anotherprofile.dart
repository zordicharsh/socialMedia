import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnotherUserProfile extends StatefulWidget {
  final String uid;

  const AnotherUserProfile({Key? key, required this.uid}) : super(key: key);

  @override
  State<AnotherUserProfile> createState() => _AnotherUserProfileState();
}

class _AnotherUserProfileState extends State<AnotherUserProfile> {
  late Stream<DocumentSnapshot> _userDataStream;
  late DocumentReference _currentUserRef; // Reference to current user's document
  late DocumentReference _anotherUserRef; // Reference to current user's document
  bool _isFollowing = false; // Track whether the current user is following

  @override
  void initState() {
    super.initState();
    _userDataStream = FirebaseFirestore.instance
        .collection('RegisteredUsers')
        .doc(widget.uid)
        .snapshots();

    // Get reference to current user's document
    _currentUserRef = FirebaseFirestore.instance.collection('RegisteredUsers').doc(FirebaseAuth.instance.currentUser!.uid);
    _anotherUserRef = FirebaseFirestore.instance.collection('RegisteredUsers').doc(widget.uid);

    // Check if the current user is already following the user
    _currentUserRef.get().then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        final userData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _isFollowing = userData['following'].contains(widget.uid);
        });
      }
    });
  }

  // Function to handle the follow button press
  void _handleFollow() {
    if (_isFollowing) {
      // Unfollow the user
      _currentUserRef.update({
        'following': FieldValue.arrayRemove([widget.uid])
      }).then((_) {
        print('User unfollowed successfully');
      }).catchError((error) {
        print('Failed to unfollow user: $error');
      });


      _anotherUserRef.update({
        'follower': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      }).then((_) {
        print('User unfollowed successfully');
        setState(() {
          _isFollowing = false;
        });
      }).catchError((error) {
        print('Failed to unfollow user: $error');
      });


    } else {
      // Follow the user
      _currentUserRef.update({
        'following': FieldValue.arrayUnion([widget.uid])
      }).then((_) {
        print('User followed successfully');
        setState(() {
          _isFollowing = true;
        });
      }).catchError((error) {
        print('Failed to follow user: $error');
      });


      _anotherUserRef.update({
        'follower': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      }).then((_) {
        print('User followed successfully');
      }).catchError((error) {
        print('Failed to follow user: $error');
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: StreamBuilder(
        stream: _userDataStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('User Not Found'));
          }
          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                          radius: 50,
                          // backgroundImage: NetworkImage(userData['profileurl']),
                          backgroundImage: userData['profileurl'] != ""
                              ? NetworkImage(userData['profileurl']) : null,
                        child: userData['profileurl'] == "" ?Icon(Icons.person,size: 50,
                        ):null,
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 28),
                              Text(
                                '${userData['follower'].length != null ? userData['follower'].length : 0}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 69),
                              Text(
                                '${userData['following'].length != null ? userData['following'].length : 0}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Followers',
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(width: 16),
                              Text(
                                'Following',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Replace ElevatedButton widget with a custom button
                  Container(
                    width: 400, // Adjust width according to your preference
                    child: TextButton(
                      onPressed: _handleFollow, // Call function to handle follow
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(_isFollowing ? Colors.grey : Colors.blue),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: Text(_isFollowing ? 'Following' : 'Follow'),
                    ),
                  ),
                  Divider(),
                  // You can add user posts or other content here
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
