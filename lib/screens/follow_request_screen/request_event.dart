
abstract class RequestEvent {}

class AcceptFollowRequestEvent  extends RequestEvent {
  String FollowUserUid ;
  String UID;
  AcceptFollowRequestEvent(this.FollowUserUid,this.UID);
}

class DeleteFollowRequestEvent  extends RequestEvent {
  String FollowUserUid ;
  String UID;

  DeleteFollowRequestEvent(this.FollowUserUid,this.UID);
}

