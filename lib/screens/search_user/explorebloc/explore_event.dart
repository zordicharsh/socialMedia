part of 'explore_bloc.dart';

@immutable
abstract class ExploreEvent {}


class UserClickOnLikedBtn extends ExploreEvent{

  bool getlikestate;

  UserClickOnLikedBtn(this.getlikestate);
}