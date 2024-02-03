class Searchevents {}

class SearchTextFieldChangedEvent extends Searchevents{
  String SearchingValue;
  SearchTextFieldChangedEvent(this.SearchingValue);
}
