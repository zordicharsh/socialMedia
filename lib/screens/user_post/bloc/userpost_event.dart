abstract class UserpostEvents {
}

class UserClickonPostbtn extends UserpostEvents{
  String profileurl;
  String caption;

  UserClickonPostbtn({required this.profileurl,required this.caption});
}

class UsergetImage extends UserpostEvents{
  // final Image;
  //
  // UsergetImage(this.Image);
}
class UserGetVideo extends UserpostEvents{

}
class UserVideoPost extends UserpostEvents{
  String profileurl;
  String caption;

  UserVideoPost(this.caption,this.profileurl);
}
class UserRemoveViedoOrImageEvent extends UserpostEvents {

}