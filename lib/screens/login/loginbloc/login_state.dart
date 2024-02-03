abstract class LoginState {}

class LoginStateEmail extends LoginState {}

class LoginInitialState extends LoginState {}

class VisibilityTrueState extends LoginState {}

class VisibilityFalseState extends LoginState {}

class LoginValidationErrorState extends LoginState {
  String message;

  LoginValidationErrorState({required this.message});
}

class LoginSuccessState extends LoginState {
  String? uid;

  LoginSuccessState({required this.uid});
}

class LoginLoadingSuccessState extends LoginState {}
