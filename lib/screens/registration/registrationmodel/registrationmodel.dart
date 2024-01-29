class RegistrationModel {
  String Uid;
  String Username;
  String Email;
  String Password;
  List Following = [];
  List Follower = [];
  DateTime datetime;

  RegistrationModel(this.Uid, this.Username, this.Email, this.Password,
      this.Follower, this.Following, this.datetime);

  Map<String, dynamic> toMap() {
    return {
      'uid': Uid,
      'username': Username,
      'email': Email,
      'password': Password,
      'following': Following,
      'follower': Follower,
      'datetime': datetime
    };
  }
}
