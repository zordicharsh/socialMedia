part of 'profile_bloc.dart';

@immutable
abstract class ProfileState {}

abstract class ProfileActionState extends ProfileState{}

class ProfileInitial extends ProfileState {}

class PostFromProfileClickedActionState extends ProfileActionState{}
