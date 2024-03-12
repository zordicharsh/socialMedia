abstract class UserpostEvents {
}

class UserClickonPostbtn extends UserpostEvents{
  String caption;

  UserClickonPostbtn({required this.caption});
}

class UsergetImage extends UserpostEvents{
  // final Image;
  //
  // UsergetImage(this.Image);
}
class UserGetVideo extends UserpostEvents{

}
class UserVideoPost extends UserpostEvents{
  String caption;

  UserVideoPost(this.caption);
}
class UserRemoveViedoOrImageEvent extends UserpostEvents {

}

class UserPostInitEvent extends UserpostEvents{}