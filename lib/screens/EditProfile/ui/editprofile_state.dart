abstract class EditProfileState {}

class EditProfileInitialState extends EditProfileState {}

class EditProfileSuccessState extends EditProfileState {

}

class EditProfileUserNameErrorState extends EditProfileState{
  String ErrorMessage ;

  EditProfileUserNameErrorState(this.ErrorMessage);
}
class EditProfileMessageSuccessState extends EditProfileState{
  String SuccessMessage;
  String Usernameeee;
  String uid;
  EditProfileMessageSuccessState(this.SuccessMessage,this.Usernameeee,this.uid);
}

class GetUserAllDataState extends EditProfileState{
 String naam;
 String Usernaam;
 String Bio;
 String profileUrl;
 GetUserAllDataState(this.naam, this.Usernaam, this.Bio, this.profileUrl);

}

class IfUserProfilePicIsNull extends EditProfileState{
  String naam;
  String Usernaam;
  String Bio;

  IfUserProfilePicIsNull(this.naam, this.Usernaam, this.Bio);

}