import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPostImageModel {
  String Username;
  String Uid;
  List Likes;
  String? Caption;
  String PostUrl;
  Timestamp datetime;

  UserPostImageModel(
      {required this.Username,
      required this.Uid,
      required this.Likes,
      this.Caption,
      required this.PostUrl,required this.datetime});

  Map<String, dynamic> tomap() {
    return {
      'username': Username,
      'uid': Uid,
      'likes': Likes,
      'caption': Caption,
      'posturl': PostUrl,
      'uploadtime':datetime
    };
  }

  // factory UserPostImageModel.fromSnapshot(
  //     DocumentSnapshot<Map<String, dynamic>> document){
  //   final data = document.data()!;
  //   return UserPostImageModel(
  //     Username: ,
  //     Uid: ,
  //     Likes: ,
  //     PostUrl: ,
  //   );
  // }

}
