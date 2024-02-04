import 'package:cloud_firestore/cloud_firestore.dart';

class UserPostImageModel {
  String Postid;
  String Username;
  String Uid;
  List Likes;
  String? Caption;
  String PostUrl;
  Timestamp datetime;
  String ProfileUrl;

  UserPostImageModel(
      {required this.Postid,
        required this.Username,
      required this.Uid,
      required this.Likes,
      required this.Caption,
      required this.PostUrl,required this.datetime,required this.ProfileUrl});

  Map<String, dynamic> tomap() {
    return {
      'postid' : Postid,
      'username': Username,
      'uid': Uid,
      'likes': Likes,
      'caption': Caption,
      'posturl': PostUrl,
      'uploadtime':datetime,
      'profileurl':ProfileUrl,
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
