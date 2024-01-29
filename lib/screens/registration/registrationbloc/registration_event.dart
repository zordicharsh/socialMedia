abstract class RegistrationEvents{}


class ClickOnSignUpButton extends RegistrationEvents{
  String Password;
  String Email;
  String Username;
  String ConfromPassword;


  ClickOnSignUpButton({ required this.Username, required this.Email,required this.Password,required this.ConfromPassword});
}


class ClickOnSigninButton extends RegistrationEvents{
  String GetUsername;
  String GetEmail;
  String GetPassword;
  ClickOnSigninButton(this.GetUsername, this.GetEmail, this.GetPassword);
}


class ClickOnVisibilityButton extends RegistrationEvents{
  bool Obsecure;
  ClickOnVisibilityButton({required this.Obsecure});
}


