
abstract class DrawerState {}

class DrawerInitial extends DrawerState {}

class PublicPrivateTrueState extends DrawerState {
  bool CheckState ;

  PublicPrivateTrueState(this.CheckState);
}

class PublicPrivateFaleState extends DrawerState {
  bool CheckState ;

  PublicPrivateFaleState(this.CheckState);
}

class SignOutState extends DrawerState {}