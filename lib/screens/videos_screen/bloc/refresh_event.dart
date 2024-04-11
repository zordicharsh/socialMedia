part of 'refresh_bloc.dart';

@immutable
abstract class RefreshEvent {}

class InitEvent extends RefreshEvent{
  String uid;
  String Postid;
  InitEvent({required this.uid,required this.Postid});

}

class DoRefreshEvent extends RefreshEvent{}
