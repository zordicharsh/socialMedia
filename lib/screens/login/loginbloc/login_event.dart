abstract class LoginEvent {}

class VisibilityButtonEvent extends LoginEvent {
  bool visibility;
  VisibilityButtonEvent({required this.visibility});
}

class LoginValidationError extends LoginEvent {
  String Email;

  String Password;

  LoginValidationError({required this.Email, required this.Password});
}
