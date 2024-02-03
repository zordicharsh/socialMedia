import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia/models/user_model.dart';

class PostModel {
  String uid;
  String username;
  String caption;
  String posturl;
  Timestamp uploadtime;
  List<UserModel> likes;

  PostModel(
      {required this.uid,
      required this.username,
      required this.caption,
      required this.posturl,
      required this.uploadtime,
      required this.likes});

  // sending data to firebase
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'caption': caption,
      'posturl': posturl,
      'uploadtime': uploadtime,
      'likes': likes,
    };
  }

  //fetching user data from firebase
  factory PostModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return PostModel(
      uid: data["uid"],
      username: data["username"],
      caption: data['caption'],
      posturl: data['posturl'],
      uploadtime: data['uploadtime'],
      likes: data['likes'],
    );
  }
}
