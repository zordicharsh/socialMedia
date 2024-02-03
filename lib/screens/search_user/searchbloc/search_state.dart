abstract class SearchState {}

class SearchInitState extends SearchState{}


class EmittheUSers extends SearchState{
  List users;
  EmittheUSers(this.users);
}

class NouserAvailable extends SearchState{}
