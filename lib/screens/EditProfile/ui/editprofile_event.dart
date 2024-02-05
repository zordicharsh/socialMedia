import 'dart:io';

abstract class EditProfileEvent {}

class EditProfileDataPassEvent extends EditProfileEvent {
  File? imageFile;
  String? username;
  String? name;
  String? bio;
  EditProfileDataPassEvent(this.imageFile, this.username, this.name, this.bio);
}

/////////////////////////////  this event is for whene url is empty //////////////////////////////////
class EditProfileDataPassEvent2 extends EditProfileEvent {
  String kuchnahi;
  String? username;
  String? name;
  String? bio;
  EditProfileDataPassEvent2(this.kuchnahi, this.username, this.name, this.bio);
}

class EditProfilUserNameCheckEvent extends EditProfileEvent {
  String Username;
  EditProfilUserNameCheckEvent(this.Username);
}

