part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {}

class NavigationInitialEvent extends NavigationEvent{
  final tabIndex;

  NavigationInitialEvent({required this.tabIndex});
}

class TabChangedEvent extends NavigationEvent{
  final tabIndex;

  TabChangedEvent({required this.tabIndex});
}
