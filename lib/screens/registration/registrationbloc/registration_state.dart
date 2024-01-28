abstract class RegistrationStaste {}

class RegistrationInitalState extends RegistrationStaste {}

class FirebaseAuthErrorState extends RegistrationStaste {
  String AuthErrorMessage;
  FirebaseAuthErrorState({required this.AuthErrorMessage});
}

class FirebaseAuthSuccessState extends RegistrationStaste {
  String AuthSuccessMessage;

  FirebaseAuthSuccessState({required this.AuthSuccessMessage});
}

class AuthSuccessLoading extends RegistrationStaste {}

class obsecureTrue extends RegistrationStaste {
  bool Obsecure;
  obsecureTrue({required this.Obsecure});
}

class obsecureFalse extends RegistrationStaste {
  bool Obsecure;
  obsecureFalse({required this.Obsecure});
}

class NavigateToLoginScreen extends RegistrationStaste {}
