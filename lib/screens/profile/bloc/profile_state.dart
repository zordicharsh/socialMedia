part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

abstract class ProfileActionState extends ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfilePageFetchUserDataState extends ProfileState {
}
class ProfilePageFetchUserPostSuccessState extends ProfileState{
  final Stream<QuerySnapshot<Map<String, dynamic>>> postdata;

  ProfilePageFetchUserPostSuccessState({required this.postdata});
}
class  ProfilePageFetchUserPostLoadingState extends ProfileState{}
class SignOutState extends ProfileState {}


class ProfilePageFetchUserDataLoadingState extends ProfileState {}

class ProfilePageRefreshActionState extends ProfileActionState {}
