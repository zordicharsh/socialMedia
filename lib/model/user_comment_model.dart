import 'package:cloud_firestore/cloud_firestore.dart';

class UserCommentModel{

  String Comment;
  String CommentByUid;
  String Postid;
  Timestamp Commenttime;
  String CommentBy;

  UserCommentModel(
  {required this.Comment,required this.CommentByUid, required this.Postid,required this.Commenttime,required this.CommentBy});

  Map<String,dynamic> toMap(){
    return {
      'comment':Comment,
      'postid':Postid,
      'commentbyuid' : CommentByUid,
      'commenttime':Commenttime,
      'commentby':CommentBy
    };
  }
}
