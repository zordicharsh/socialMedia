import 'package:cloud_firestore/cloud_firestore.dart';

class UserPostImageModel {
  String Postid;
  String Username;
  String Uid;
  List Likes;
  String? Caption;
  String PostUrl;
  Timestamp datetime;
  String Thumbnail;
  String ProfileUrl;
  String Types ;
  String Acctype ;
  int TotalComments;
  int TotalLikes;

  UserPostImageModel(
      {required this.Postid,
        required this.Username,
        required this.Uid,
        required this.Likes,
        required this.Caption,
        required this.PostUrl,required this.datetime,required this.ProfileUrl,
        required this.Types,required this.Thumbnail,
      required this.Acctype,required this.TotalComments,required this.TotalLikes});

  Map<String, dynamic> tomap() {
    return {
      'postid' : Postid,
      'username': Username,
      'uid': Uid,
      'likes': Likes,
      'caption': Caption,
      'posturl': PostUrl,
      'thumbnail':Thumbnail,
      'uploadtime':datetime,
      'profileurl':ProfileUrl,
      'type':Types,
      'acctype' : Acctype,
      'totallikes': TotalLikes,
      'totalcomments': TotalComments,
    };
  }
}