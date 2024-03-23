import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_bloc.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_event.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_state.dart';
import 'package:socialmedia/screens/search_user/searchui/searched_profile/anotherprofile.dart';
import 'package:video_player/video_player.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({Key? key}) : super(key: key);

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  TextEditingController search = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    search.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<SearchBloc>(context).add(SearchUsersIntialEvent());
  }

  VideoPlayerController? controller;
  bool islike = false;
  bool? ispopupremoved;

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
                      BlocProvider.of<SearchBloc>(context)
                          .add(SearchUsersIntialEvent());
                      search.clear();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 38,
                      child: TextField(
                        controller: search,
                        onTap: () {},
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
                          prefixIcon:
                              const Icon(Icons.search, color: Colors.grey),
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
                    log("emmitingus");
                    return StreamBuilder(
                        stream: state.UserLists,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            log(snapshot.data!.docs[0]['username'].toString());
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  splashColor: Colors.transparent,
                                  onTap: () async {
                                    log("anotherscreen");
                                    if (!context.mounted) return;
                                    Navigator.push(
                                        context,
                                        CustomPageRouteRightToLeft(
                                          child: AnotherUserProfile(
                                            uid: snapshot
                                                .data!.docs[index]['uid']
                                                .toString(),
                                            username: snapshot
                                                .data!.docs[index]['username']
                                                .toString(),
                                          ),
                                        ));
                                  },
                                  leading: CircleAvatar(
                                    maxRadius: 20,
                                    backgroundColor: Colors.grey,
                                    backgroundImage: snapshot.data!
                                                    .docs[index]['profileurl']
                                                    .toString() !=
                                                "" &&
                                            snapshot.data!.docs[index]
                                                    ['profileurl'] !=
                                                null
                                        ? NetworkImage(snapshot
                                            .data!.docs[index]['profileurl']
                                            .toString())
                                        : null,
                                    // Set backgroundImage to null if URL is null or empty
                                    child: snapshot.data!
                                                    .docs[index]['profileurl']
                                                    .toString() !=
                                                "" &&
                                            snapshot.data!.docs[index]
                                                    ['profileurl'] !=
                                                null
                                        ? null
                                        : const Icon(Icons.person,
                                            size: 40, color: Colors.white),
                                  ),
                                  title: Text(
                                    snapshot.data!.docs[index]['username']
                                        .toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    snapshot.data!.docs[index]['uid']
                                        .toString(),
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const Text("data");
                          }
                        });
                  } else if (state is NouserAvailable) {
                    log("nouseravailable");
                    return const Center(
                      child: Text("no user found"),
                    );
                  } else {
                    return const Center(
                      child: Text("init"),
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
