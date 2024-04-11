abstract class DrawerEvent {}

class PublicPrivateTrueEvent extends DrawerEvent {
  bool Checking ;

  PublicPrivateTrueEvent(this.Checking);
}

class PublicPrivateFalseEvent extends DrawerEvent {}

class SignOutEvent extends DrawerEvent{}

class FirstCheckAccTypeEvent extends DrawerEvent{}

class DeleteAccountEvent extends DrawerEvent{

}