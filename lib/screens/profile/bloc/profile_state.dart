part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

abstract class ProfileActionState extends ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfilePageFetchUserDataState extends ProfileState {}

class ProfilePageFetchUserPostSuccessState extends ProfileState{
  final Stream<QuerySnapshot<Map<String, dynamic>>> postdata;
  final int? postlength;

  ProfilePageFetchUserPostSuccessState(this.postlength, {required this.postdata});
}
class ProfilePageFetchUserPostLengthSuccessState extends ProfileState{
   final int? postlength;

  ProfilePageFetchUserPostLengthSuccessState({required this.postlength});
}
class  ProfilePageFetchUserPostLoadingState extends ProfileState{}
class SignOutState extends ProfileState {}


class ProfilePageFetchUserDataLoadingState extends ProfileState {}

class ProfilePageRefreshActionState extends ProfileActionState {}
/*
class ProfilePagePopUpDialogPostLikedActionState extends ProfileActionState {
  final bool isHeartAnimating;
  final bool isLiked;

  ProfilePagePopUpDialogPostLikedActionState(
      this.isHeartAnimating, this.isLiked);
}*/
