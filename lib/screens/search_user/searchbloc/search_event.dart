class Searchevents {}
class SearchUsersIntialEvent extends Searchevents{}
class SearchTextFieldChangedEvent extends Searchevents{
  String SearchingValue;
  SearchTextFieldChangedEvent(this.SearchingValue);
}

