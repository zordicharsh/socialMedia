import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class ExplorePageImage extends StatefulWidget {
  final uid;
  final postuid;
  const ExplorePageImage({super.key,required this.uid,required this.postuid});
  @override
  State<ExplorePageImage> createState() => _ExplorePageImageState();
}
class _ExplorePageImageState extends State<ExplorePageImage> {
  Set<String> displayedPostIds = Set<String>(); //
  final OneSnaplivedata = FirebaseFirestore.instance.collection("UserPost").where('acctype',isEqualTo: 'public').snapshots();
  var imageuid;
  var profilename;
  var imageurl;
  var caption;
  Timestamp ?time;
  var type;
  Timestamp t=Timestamp.now();
  List ?nooflikes;
  var snap1;
  @override
  Widget build(BuildContext context) {
    print(widget.postuid);
    return Scaffold(backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Explore"),
        backgroundColor: Colors.black,
        leading: IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
          Navigator.pop(context);
        }),
      ),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: OneSnaplivedata,
            builder: (context, snapshotStream) {
              if (snapshotStream.hasData) {
                List<Widget> postWidgets = [];
                for (var snapshot in snapshotStream.data!.docs) {
                  final postData = snapshot.data();
                  final postID = postData['postid'];
                  final profileUrl = postData['profileurl'];
                  final username = postData['username'];
                  final postUrl = postData['posturl'];
                  final postType = postData['type'];
                  final caption = postData['caption'];
                  final uploadTime = postData['uploadtime'];
                  final likes = postData['likes'];
                  //this is main post
                  // Check if the current post matches the provided postuid
                  if (postID == widget.postuid) {
                    // Build the UI for the main post
                    Widget mainPostWidget = Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Post header (user information)
                          ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(profileUrl),
                            ),
                            title: Text(username),
                            subtitle: Text(
                              DateFormat('MMM d, yyyy hh:mm a').format(uploadTime!.toDate().toUtc()),
                            ),
                          ),
                          // Post image or video
                          postType == "image"
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              postUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                              : SizedBox(), // Handle video case
                          // Post actions (like, comment, share, save)
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Implement like functionality
                                },
                                icon: Icon(Icons.favorite_border),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Implement comment functionality
                                },
                                icon: Icon(Icons.comment),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Implement share functionality
                                },
                                icon: Icon(Icons.share),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  // Implement save functionality
                                },
                                icon: Icon(Icons.save_outlined),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Display the number of likes
                          Text(
                            "${likes.length} likes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Display post caption
                          Text(
                            caption,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                    postWidgets.add(mainPostWidget);
                  }
                }

                // Add additional images below the main post
                for (var snapshot in snapshotStream.data!.docs) {
                  final postData = snapshot.data();
                  final postID = postData['postid'];
                  final profileUrl = postData['profileurl'];
                  final username = postData['username'];
                  final postUrl = postData['posturl'];
                  final postType = postData['type'];
                  final caption = postData['caption'];
                  final uploadTime = postData['uploadtime'];
                  final likes = postData['likes'];

                  // Check if the post is an image and not the main post
                  if (postID != widget.postuid && postType == "image") {
                    Widget mainPostWidget = Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Post header (user information)
                          ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(profileUrl),
                            ),
                            title: Text(username),
                            subtitle: Text(
                              DateFormat('MMM d, yyyy hh:mm a').format(uploadTime!.toDate().toUtc()),
                            ),
                          ),
                          // Post image or video
                          postType == "image"
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              postUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                              : SizedBox(), // Handle video case
                          // Post actions (like, comment, share, save)
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Implement like functionality
                                },
                                icon: Icon(Icons.favorite_border),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Implement comment functionality
                                },
                                icon: Icon(Icons.comment),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Implement share functionality
                                },
                                icon: Icon(Icons.share),
                              ),
                              Spacer(),
                              IconButton(
                                onPressed: () {
                                  // Implement save functionality
                                },
                                icon: Icon(Icons.save_outlined),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          // Display the number of likes
                          Text(
                            "${likes.length} likes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          // Display post caption
                          Text(
                            caption,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                    postWidgets.add(mainPostWidget);
                  }
                }

                // Return the assembled list of widgets
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: postWidgets,
                );
              } else {
                print("no data");
                return Container(); // Return an empty container if no data is available
              }
            },
          ),
        )

    );
  }
}
