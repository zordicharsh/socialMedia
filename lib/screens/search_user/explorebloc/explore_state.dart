part of 'explore_bloc.dart';

@immutable
abstract class ExploreState {}

class ExploreInitial extends ExploreState {}


class showliking extends ExploreState{
  bool Islike;
  showliking(this.Islike);
}
