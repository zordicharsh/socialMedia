part of 'comment_bloc.dart';

@immutable
abstract class CommentState {}

class CommentInitial extends CommentState {}

class FetchCommentsOfUserPostSuccessState extends CommentState{
  final Stream<QuerySnapshot<Map<String, dynamic>>> commentdata;

  FetchCommentsOfUserPostSuccessState(
     this.commentdata,);
}

class UploadCommentsOfUserPostSuccessState extends CommentState{
  String postid;String text;

  UploadCommentsOfUserPostSuccessState(
      this.postid, this.text,);
}