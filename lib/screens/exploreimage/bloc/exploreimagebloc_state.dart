import 'package:cloud_firestore/cloud_firestore.dart';

class exploreimageState{}


class exploreimageinitstate extends exploreimageState{

}

class exploreimageshowState extends exploreimageState{
  final Stream<QuerySnapshot<Map<String, dynamic>>> UserPostData;

  exploreimageshowState(this.UserPostData);
}




