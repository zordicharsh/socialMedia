class UserPostStates {}

class UserPostinitState extends UserPostStates {}

class UserPostUploadSuccessState extends UserPostStates {}

class UserPostUnSuccessState extends UserPostStates {}

class SuccessFullySelectedImage extends UserPostStates {
  final sentimage;
  SuccessFullySelectedImage(this.sentimage);
}

class UnSuccessFullySelectedImage extends UserPostStates {}

class UnabletoUplaodImage extends UserPostStates {}

class AbletoUplaodImage extends UserPostStates {}

class LoadingComeState extends UserPostStates {}

class LoadingGoState extends UserPostStates {}
