abstract class RegistrationEvents {}

class ClickOnSignUpButton extends RegistrationEvents {
  String Password;
  String Email;
  String Username;
  String ConfirmPassword;

  ClickOnSignUpButton(
      {required this.Username,
      required this.Email,
      required this.Password,
      required this.ConfirmPassword});
}

class ClickOnSigninButton extends RegistrationEvents {
  String GetUsername;
  String GetEmail;
  String GetPassword;

  ClickOnSigninButton(this.GetUsername, this.GetEmail, this.GetPassword);
}

class ClickOnVisibilityButton extends RegistrationEvents {
  bool Obscure;

  ClickOnVisibilityButton({required this.Obscure});
}
