part of 'navigation_bloc.dart';

@immutable
abstract class NavigationState {
  final tabindex;

  NavigationState({required this.tabindex});
}

class NavigationInitial extends NavigationState {
  NavigationInitial({required super.tabindex});
}
