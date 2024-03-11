part of 'heart_bloc.dart';


abstract class HeartEvent {}

class ProfilePagePopUpDialogLikedAnimOnPostEvent extends HeartEvent {
  bool isHeartAnimating;
  bool isLiked;

  ProfilePagePopUpDialogLikedAnimOnPostEvent(this.isHeartAnimating, this.isLiked);
}

class ProfilePagePostCardDoubleTapLikedAnimOnPostEvent extends HeartEvent {
  final String postId;

  ProfilePagePostCardDoubleTapLikedAnimOnPostEvent(this.postId);
}

class ProfilePagePostCardOnPressedLikedAnimOnPostEvent extends HeartEvent {
  final String postId;

  ProfilePagePostCardOnPressedLikedAnimOnPostEvent(this.postId);
}