// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class SearchView extends StatefulWidget {
  SearchView({super.key});
  @override
  State<SearchView> createState() => _SearchViewState();
}
class _SearchViewState extends State<SearchView> {
  var searchName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: SizedBox(
          height: 40,
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchName = value;
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none),
                contentPadding:
                EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                filled: true,
                fillColor: Color.fromARGB(255, 39, 39, 39),
                hintText: 'Search',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                )),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('RegisteredUsers')
              .orderBy('username')
              .startAt([searchName]).endAt([searchName + "\uf8ff"]).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return ListTile(
                    onTap: () {
                    },
                    leading: CircleAvatar(
                      radius: 24,

                    ),
                    title: Text(data['username']),
                    subtitle: Text(data['email']),

                  );
                });
          }),
    );
  }
}