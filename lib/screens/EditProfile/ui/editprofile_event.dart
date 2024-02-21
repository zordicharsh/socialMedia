import 'dart:io';

abstract class EditProfileEvent {}

class EditProfileDataPassEvent extends EditProfileEvent {
  File? imageFile;
  String? username;
  String? name;
  String? bio;
  EditProfileDataPassEvent(this.imageFile, this.username, this.name, this.bio);
}

/////////////////////////////  if  url is empty     //////////////////////////////////
class EditProfileDataPassEvent2 extends EditProfileEvent {
  String? kuchnahi;
  String? username;
  String? name;
  String? bio;
  EditProfileDataPassEvent2(this.kuchnahi, this.username, this.name, this.bio);
}

class EditProfilUserNameCheckEvent extends EditProfileEvent {
  String Username;
  EditProfilUserNameCheckEvent(this.Username);
}

class GetUserAlldataEvent extends EditProfileEvent{

}
class ShowingNullProfile extends EditProfileEvent {
  String? kuchnahi;
  String? username;
  String? name;
  String? bio;
  ShowingNullProfile(this.kuchnahi, this.username, this.name, this.bio);
}

