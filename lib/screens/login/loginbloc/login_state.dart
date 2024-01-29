abstract class LoginState {}

class LoginStateEmail extends LoginState{}

class LoginInitailState extends LoginState {}

class VisibilityTrueState extends LoginState {}

class VisibilityFalseState extends LoginState {}


class LoginValidationErrorState extends LoginState{
  String message ;

  LoginValidationErrorState({required this.message});
}

class LoginSuccessState extends LoginState{}

class LoginLoadingSuccessState extends LoginState{}



