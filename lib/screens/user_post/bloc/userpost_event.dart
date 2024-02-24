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