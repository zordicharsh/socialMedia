import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_bloc.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_event.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_state.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log("Calling Search widget");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              TextField(
                controller: search,
                onChanged: (value) {
                  if (value.isEmpty) {
                    search.clear();
                    BlocProvider.of<SearchBloc>(context)
                        .add(SearchUsersIntialEvent());
                  } else if (value.length == 1) {
                    BlocProvider.of<SearchBloc>(context)
                        .add(SearchUsersIntialEvent());
                  } else {
                    BlocProvider.of<SearchBloc>(context)
                        .add(SearchTextFieldChangedEvent(value));
                  }
                },
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: "Enter a username",
                  labelStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(Icons.search, color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is EmittheUSers) {
                      print("emmitingus");
                      return ListView.builder(
                        itemCount: state.users.length,
                        itemBuilder: (context, index) {
                          return Card(
                            color: Colors.grey[900],
                            elevation: 2,
                            // margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: ListTile(
                              onTap: () {
                                // Handle onTap action
                              },
                              leading: CircleAvatar(
                                maxRadius: 50,
                                minRadius: 20,
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                    state.users[index].Profileurl.toString()),
                              ),
                              title: Text(
                                state.users[index].Username.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                state.users[index].Uid.toString(),
                                style: const TextStyle(color: Colors.white70),
                              ),
                              // contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            ),
                          );
                        },
                      );
                    } else if (state is NouserAvailable) {
                      print("nouseravailable");
                      return Center(
                          child: Container(
                        child: const Text("no user found"),
                      ));
                    } else {
                      print("inint");
                      return Center(
                          child: Container(
                        child: const Text("init state"),
                      ));
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
