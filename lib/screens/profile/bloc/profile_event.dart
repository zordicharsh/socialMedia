part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent {}

class ProfilePageInitialEvent extends ProfileEvent {}

class ProfilePageFetchUserPostEvent extends ProfileEvent {
  final String userid;
  final int? postlength;

  ProfilePageFetchUserPostEvent(this.postlength, {required this.userid});
}
class ProfilePageFetchUserPostLengthEvent extends ProfileEvent{
  final String userid;

  ProfilePageFetchUserPostLengthEvent({required this.userid});
}
class OnEditButtonTappedEvent extends ProfileEvent{}

class SignOutEvent extends ProfileEvent {}

class ProfilePageOnRefreshEvent extends ProfileEvent {}
