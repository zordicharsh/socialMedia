abstract class RegistrationStates {}

class RegistrationInitalState extends RegistrationStates {}

class FirebaseAuthErrorState extends RegistrationStates {
  String AuthErrorMessage;
  FirebaseAuthErrorState({required this.AuthErrorMessage});
}

class FirebaseAuthSuccessState extends RegistrationStates {
  String AuthSuccessMessage;

  FirebaseAuthSuccessState({required this.AuthSuccessMessage});
}

class AuthSuccessLoading extends RegistrationStates {}

class obsecureTrue extends RegistrationStates {
  bool Obsecure;
  obsecureTrue({required this.Obsecure});
}

class obsecureFalse extends RegistrationStates {
  bool Obsecure;
  obsecureFalse({required this.Obsecure});
}

class NavigateToLoginScreen extends RegistrationStates {}
