abstract class LoginEvent {}


class  VisibilityButtonEvent  extends LoginEvent {
  var visi ;
  VisibilityButtonEvent({required this.visi});
}

class LoginValidationError extends LoginEvent{
  String Email ;
  String Password ;
  LoginValidationError({required this.Email,required this.Password});
}