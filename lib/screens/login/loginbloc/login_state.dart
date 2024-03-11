abstract class LoginState {}

class LoginStateEmail extends LoginState {}

class LoginInitialState extends LoginState {}

class VisibilityTrueState extends LoginState {
  bool Obsecure;
  VisibilityTrueState({required this.Obsecure});
}

class VisibilityFalseState extends LoginState {
  bool Obsecure;

    VisibilityFalseState({required this.Obsecure});
}

class LoginValidationErrorState extends LoginState {
  String message;

  LoginValidationErrorState({required this.message});
}

class LoginLoadingSuccessState extends LoginState {}

class LoginSuccessState extends LoginState {
  String? uid;
  LoginSuccessState({required this.uid});
}