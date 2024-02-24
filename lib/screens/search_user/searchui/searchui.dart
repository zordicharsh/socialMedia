import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/profile/ui/profile.dart';
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {

                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: TextField(
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
                        cursorColor: Colors.grey,
                        decoration: InputDecoration(
                          hintText: " \"Enter username\" ",
                          contentPadding: EdgeInsets.zero,
                          filled: true,
                          fillColor: const Color.fromRGBO(90, 90, 90, 0.35),
                          labelStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            const BorderSide(color: Colors.transparent),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                        return ListTile(
                          onTap: () {
                            if(FirebaseAuth.instance.currentUser!.uid == state.users[index].Uid.toString()){
                              Navigator.push(context,  MaterialPageRoute(builder: (context) => ProfilePage(),));
                            }
                            else{
                              print("anotherscreen");
                            }
                          },
                          leading: CircleAvatar(
                              maxRadius: 20,
                              backgroundColor: Colors.grey,
                              backgroundImage: state.users[index].Profileurl != ""
                                  ? NetworkImage(state.users[index].Profileurl.toString()) : NetworkImage("https://imgs.search.brave.com/S4Q092Ic9VDPZIPUc2EqH8Bvx0XVvLNErkxgHy8FpjA/rs:fit:860:0:0/g:ce/aHR0cHM6Ly9idWZm/ZXIuY29tL2xpYnJh/cnkvY29udGVudC9p/bWFnZXMvMjAyMi8w/My9hbWluYS5wbmc")
                          ),
                          title: Text(
                            state.users[index].Username.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            state.users[index].Uid.toString(),
                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      },
                    );
                  } else if (state is NouserAvailable) {
                    print("nouseravailable");
                    return const Center(
                      child: Text("no user found"),
                    );
                  } else {
                    print("inint");
                    return const Center(
                      child: Text("init state"),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}