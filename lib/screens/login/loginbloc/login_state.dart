abstract class LoginState {}

class LoginStateEmail extends LoginState{}

class LoginInitailState extends LoginState {}

class VisibilityTrueState extends LoginState {}

class VisibilityFalseState extends LoginState {}


class LoginValidationState extends LoginState{
  String message ;

  LoginValidationState(this.message);
}

class LoginSuccessState extends LoginState{}



