
abstract class FollowerFollowingEvent {}

class DeleteFollowerFollowingEvent  extends FollowerFollowingEvent {
  String FollowUserUid ;
  String UID;
  DeleteFollowerFollowingEvent(this.FollowUserUid,this.UID);
}

class DeleteFollowerFollowingEvent2  extends FollowerFollowingEvent {
  String FollowUserUid ;
  String UID;
  DeleteFollowerFollowingEvent2(this.FollowUserUid,this.UID);
}

