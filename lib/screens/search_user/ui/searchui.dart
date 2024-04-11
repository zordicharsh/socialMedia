import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import 'package:socialmedia/screens/search_user/ui/searched_profile/anotherprofile.dart';

import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';



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

  CachedVideoPlayerController? controller;
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
                    log("emmiting users");
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
                                  leading: snapshot
                                              .data!.docs[index]['profileurl']
                                              .toString() !=
                                          ""
                                      ? CircleAvatar(
                                          radius: 20.1,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            backgroundColor: Colors.grey,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['profileurl']
                                                        .toString()),
                                            radius: 20,
                                          ),
                                        )
                                      : CircleAvatar(
                                          radius: 20.1,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.black.withOpacity(0.8),
                                            radius: 20,
                                            child: Icon(Icons.person,
                                                color: Colors.black
                                                    .withOpacity(0.5),size: 30,),
                                          ),
                                        ),
                                  title: Text(
                                    snapshot.data!.docs[index]['username']
                                        .toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    snapshot.data!.docs[index]['name']
                                        .toString(),
                                    style:
                                        const TextStyle(color: Colors.white70),
                                  ),
                                );
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        });
                  } else if (state is NouserAvailable) {
                    return Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Center(
                        child: SizedBox(
                          height:240.sp,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 200,
                                width: double.infinity,
                                child: Image.asset(
                                    "assets/images/noUsersFound.png"),
                              ),
                              const Text(
                                "Uh-oh!",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                               Text(
                                "No user available as \"${search.text.toString()}\". ",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white60,),
                                 textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Center(
                        child: SizedBox(
                          height:200.sp,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 180,
                                width: double.infinity,
                                child: Image.asset(
                                    "assets/images/searchUsersInitImage.png"),
                              ),
                              const Text(
                                "Search, Follow, Engage, Chat",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                              const Text(
                                "expand your SocialRizz circle",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white60),
                              ),
                            ],
                          ),
                        ),
                      ),
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
