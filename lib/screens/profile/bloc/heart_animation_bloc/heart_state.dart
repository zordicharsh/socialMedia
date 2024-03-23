part of 'heart_bloc.dart';

@immutable
abstract class HeartState {}

class HeartInitial extends HeartState {}
class ProfilePagePopUpDialogPostLikedActionState extends HeartState {
  final bool isHeartAnimating;
  final bool isLiked;

  ProfilePagePopUpDialogPostLikedActionState(
      this.isHeartAnimating, this.isLiked);
}

