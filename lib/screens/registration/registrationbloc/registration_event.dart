abstract class RegistrationEvents{}

class ClickOnSignUpButton extends RegistrationEvents{
  String Password;
  String Email;
  String Username;
  String ?Bio;
  final keyofreg;

  ClickOnSignUpButton({ required this.Username, required this.Email,required this.Password,required this.Bio,required this.keyofreg});

}

class ClickOnSigninButton extends RegistrationEvents{}

