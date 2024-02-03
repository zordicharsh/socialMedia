abstract class EditProfileState {}

class EditProfileInitialState extends EditProfileState {}

class EditProfileSuccessState extends EditProfileState {}

class EditProfileUserNameErrorState extends EditProfileState{
  String ErrorMessage ;

  EditProfileUserNameErrorState(this.ErrorMessage);
}
