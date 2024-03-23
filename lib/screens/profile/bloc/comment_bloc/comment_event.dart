part of 'comment_bloc.dart';

@immutable
abstract class CommentEvent {}

class FetchCommentsOfUserPost extends CommentEvent{
  final String postid;

  FetchCommentsOfUserPost(
      this.postid);
}
class UploadCommentsOfUserPost extends CommentEvent{
  final String postid;final String text;

  UploadCommentsOfUserPost(
      this.postid, this.text);
}
class DeleteCommentsOfUserPost extends CommentEvent {
  final String commentid;
  final String postid;

  DeleteCommentsOfUserPost(this.commentid, this.postid);
}

class PostCardCommentSectionDoubleTapLikedAnimOnCommentEvent extends CommentEvent {
  final String postId;
  final String commentId;

  PostCardCommentSectionDoubleTapLikedAnimOnCommentEvent (this.postId, this.commentId);
}

class PostCardCommentSectionOnPressedLikedAnimOnCommentEvent extends CommentEvent {
  final String postId;
  final String commentId;

  PostCardCommentSectionOnPressedLikedAnimOnCommentEvent(this.postId, this.commentId);
}
