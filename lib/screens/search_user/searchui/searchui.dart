import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:socialmedia/screens/exploreimage/exploreimagepage.dart';
import 'package:socialmedia/screens/search_user/explorebloc/explore_bloc.dart';
import 'package:socialmedia/screens/search_user/searchui/anotherprofile.dart';
import 'package:socialmedia/screens/profile/ui/profile.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_bloc.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_event.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_state.dart';
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
    late OverlayEntry? popupDialog;
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
                    print("emmitingus");
                    return StreamBuilder(
                        stream: state.UserLists,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            log(snapshot.data!.docs[0]['username'].toString());
                            return ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    if (FirebaseAuth
                                            .instance.currentUser!.uid ==
                                        state.users[index].Uid.toString()) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ProfilePage(),
                                          ));
                                    } else {
                                      print("anotherscreen");
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AnotherUserProfile(
                                                    uid: snapshot.data!
                                                        .docs[index]['uid']
                                                        .toString()),
                                          ));
                                    }
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
                                        : null, // Set backgroundImage to null if URL is null or empty
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
                    print("nouseravailable");
                    return const Center(
                      child: Text("no user found"),
                    );
                  } else {
                    return Center(child: Text("init"),);
                    // return StreamBuilder(
                    //   stream: FirebaseFirestore.instance
                    //       .collection("UserPost")
                    //       .snapshots(),
                    //   builder: (context, snapshot) {
                    //     if (snapshot.hasData) {
                    //       return CustomScrollView(
                    //         slivers: [
                    //           SliverGrid(
                    //               delegate: SliverChildBuilderDelegate(
                    //                   (context, index) {
                    //                 if (snapshot.data!.docs[index]
                    //                         .get("type") ==
                    //                     "image") {
                    //                   return GestureDetector(
                    //                       onTap: () {
                    //                         Navigator.push(
                    //                             context,
                    //                             MaterialPageRoute(
                    //                                 builder: (context) =>
                    //                                     ExplorePageImage(
                    //                                         uid: snapshot.data!
                    //                                             .docs[index]
                    //                                             .get("uid"),
                    //                                         postuid: snapshot
                    //                                             .data!
                    //                                             .docs[index]
                    //                                             .get(
                    //                                                 "postid"))));
                    //                       },
                    //                       onLongPressEnd: (details) async {
                    //                         popupDialog!.remove();
                    //                       },
                    //                       onLongPress: () {
                    //                         popupDialog = OverlayEntry(
                    //                           builder: (context) {
                    //                             return Dialog(
                    //                               backgroundColor: Colors.black,
                    //                               child: Container(
                    //                                 constraints:
                    //                                     const BoxConstraints(
                    //                                         maxWidth: 600,
                    //                                         maxHeight:
                    //                                             650), // Example constraints
                    //                                 child: Column(
                    //                                   mainAxisSize:
                    //                                       MainAxisSize.min,
                    //                                   children: [
                    //                                     SizedBox(
                    //                                       width:
                    //                                           double.infinity,
                    //                                       height:
                    //                                           400, // Example height
                    //                                       child: Image.network
                    //                                         (
                    //                                         snapshot.data!
                    //                                             .docs[index]
                    //                                             .get("posturl"),
                    //                                         fit: BoxFit
                    //                                             .cover, // Adjust the fit as per your requirement
                    //                                       ),
                    //                                     ),
                    //                                     Row(
                    //                                       mainAxisAlignment:
                    //                                           MainAxisAlignment
                    //                                               .spaceEvenly,
                    //                                       children: [
                    //                                         BlocBuilder<
                    //                                             ExploreBloc,
                    //                                             ExploreState>(
                    //                                           builder: (context,
                    //                                               state) {
                    //                                             if (state
                    //                                                 is showliking) {
                    //                                               if (state
                    //                                                       .Islike ==
                    //                                                   true) {
                    //                                                 return IconButton(
                    //                                                   tooltip:
                    //                                                       "Send message",
                    //                                                   onPressed:
                    //                                                       () {
                    //                                                     print(context
                    //                                                         .toString());
                    //                                                   },
                    //                                                   icon: const Icon(
                    //                                                       Icons
                    //                                                           .favorite), // Example IconButton
                    //                                                 );
                    //                                               } else {
                    //                                                 return IconButton(
                    //                                                   tooltip:
                    //                                                       "Send message",
                    //                                                   onPressed:
                    //                                                       () {
                    //                                                     print(context
                    //                                                         .toString());
                    //                                                   },
                    //                                                   icon: const Icon(
                    //                                                       Icons
                    //                                                           .favorite_border_rounded), // Example IconButton
                    //                                                 );
                    //                                               }
                    //                                             }
                    //                                             return IconButton(
                    //                                               tooltip:
                    //                                                   "Send message",
                    //                                               onPressed:
                    //                                                   () {
                    //                                                 print(context
                    //                                                     .toString());
                    //                                               },
                    //                                               icon: const Icon(
                    //                                                   Icons
                    //                                                       .favorite_border_rounded), // Example IconButton
                    //                                             );
                    //                                           },
                    //                                         ),
                    //                                         IconButton(
                    //                                           tooltip:
                    //                                               "Send message",
                    //                                           onPressed: () {},
                    //                                           icon: const Icon(Icons
                    //                                               .person), // Example IconButton
                    //                                         ),
                    //                                         IconButton(
                    //                                           tooltip:
                    //                                               "Send message",
                    //                                           onPressed: () {},
                    //                                           icon: const Icon(Icons
                    //                                               .send_sharp), // Example IconButton
                    //                                         ),
                    //                                       ],
                    //                                     ),
                    //                                   ],
                    //                                 ),
                    //                               ),
                    //                             );
                    //                           },
                    //                         );
                    //                         Overlay.of(context)
                    //                             .insert(popupDialog!);
                    //                       },
                    //                       child: ClipRRect(
                    //                           borderRadius:
                    //                               BorderRadius.circular(8.0),
                    //                           child: Image.network(
                    //                             snapshot.data!.docs[index]
                    //                                 .get("posturl"),
                    //                             fit: BoxFit.cover,
                    //                             filterQuality: FilterQuality.low,
                    //                             width: double.infinity,
                    //                             height: double.infinity,
                    //                           )));
                    //                 } else {
                    //                   controller =
                    //                       VideoPlayerController.networkUrl(
                    //                           Uri.parse(snapshot
                    //                               .data!.docs[index]
                    //                               .get("posturl")))
                    //                         ..initialize()
                    //                         ..pause();
                    //                   return Stack(
                    //                     children: [
                    //                       ClipRRect(
                    //                         borderRadius:
                    //                             BorderRadius.circular(8.0),
                    //                         child: VideoPlayer(controller!),
                    //                       ),
                    //                       const Positioned(
                    //                         top: 0,
                    //                         right: 0,
                    //                         child: Icon(
                    //                           Icons
                    //                               .tv_sharp, // Replace Icons.close with your desired icon
                    //                           color: Colors.white,
                    //                           size: 24.0,
                    //                         ),
                    //                       ),
                    //                     ],
                    //                   );
                    //                 }
                    //               }, childCount: snapshot.data!.size),
                    //               gridDelegate: SliverQuiltedGridDelegate(
                    //                   crossAxisCount: 3,
                    //                   mainAxisSpacing: 3,
                    //                   crossAxisSpacing: 3,
                    //                   pattern: [
                    //                     const QuiltedGridTile(2, 1),
                    //                     const QuiltedGridTile(2, 2),
                    //                     const QuiltedGridTile(1, 1),
                    //                     const QuiltedGridTile(1, 1),
                    //                     const QuiltedGridTile(1, 1),
                    //                   ])),
                    //         ],
                    //       );
                    //       // return GridView.builder(
                    //       //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //       //     crossAxisCount: 3,
                    //       //     crossAxisSpacing: 4.0,
                    //       //     mainAxisSpacing: 4.0,
                    //       //   ),
                    //       //   itemCount: snapshot.data!.size,
                    //       //   itemBuilder: (BuildContext _, int index) {
                    //       //   },);
                    //     }
                    //     return Container();
                    //
                    //     // return GridView.builder(
                    //     //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //     //     crossAxisCount: 3,
                    //     //     crossAxisSpacing: 4.0,
                    //     //     mainAxisSpacing: 4.0,
                    //     //   ),
                    //     //   itemCount: images.length,
                    //     //   itemBuilder: (BuildContext _, int index) {
                    //     //     return GestureDetector(
                    //     //         child: ClipRRect(
                    //     //           borderRadius: BorderRadius.circular(8.0),
                    //     //           child: Image.network(
                    //     //             images[index],
                    //     //             fit: BoxFit.cover,
                    //     //             width: double.infinity,
                    //     //             height: double.infinity,
                    //     //           )
                    //     //     ));
                    //     // return GestureDetector(
                    //     //   onLongPress: () {
                    //     //     popupDialog = OverlayEntry(
                    //     //       builder: (context) {
                    //     //         return Dialog(
                    //     //           backgroundColor: Colors.black,
                    //     //           child: Container(
                    //     //             constraints: BoxConstraints(
                    //     //                 maxWidth: 600,
                    //     //                 maxHeight: 650), // Example constraints
                    //     //             child: Column(
                    //     //               mainAxisSize: MainAxisSize.min,
                    //     //               children: [
                    //     //                 SizedBox(
                    //     //                   width: double.infinity,
                    //     //                   height: 400, // Example height
                    //     //                   child: Image.network(
                    //     //                     images[index],
                    //     //                     fit: BoxFit
                    //     //                         .cover, // Adjust the fit as per your requirement
                    //     //                   ),
                    //     //                 ),
                    //     //                 Row(
                    //     //                   mainAxisAlignment:
                    //     //                       MainAxisAlignment.spaceEvenly,
                    //     //                   children: [
                    //     //                     BlocBuilder<ExploreBloc,
                    //     //                         ExploreState>(
                    //     //                       builder: (context, state) {
                    //     //                         if(state is showliking){
                    //     //                           if(state.Islike == true){
                    //     //                             return IconButton(
                    //     //                               tooltip: "Send message",
                    //     //                               onPressed: () {
                    //     //                                 print(context.toString());
                    //     //                               },
                    //     //                               icon: Icon(Icons
                    //     //                                   .favorite), // Example IconButton
                    //     //                             );
                    //     //                           }else{
                    //     //                             return IconButton(
                    //     //                               tooltip: "Send message",
                    //     //                               onPressed: () {
                    //     //                                 print(context.toString());
                    //     //                               },
                    //     //                               icon: Icon(Icons
                    //     //                                   .favorite_border_rounded), // Example IconButton
                    //     //                             );
                    //     //                           }
                    //     //                         }
                    //     //                         return IconButton(
                    //     //                           tooltip: "Send message",
                    //     //                           onPressed: () {
                    //     //                             print(context.toString());
                    //     //                           },
                    //     //                           icon: Icon(Icons
                    //     //                               .favorite_border_rounded), // Example IconButton
                    //     //                         );
                    //     //                       },
                    //     //                     ),
                    //     //                     IconButton(
                    //     //                       tooltip: "Send message",
                    //     //                       onPressed: () {},
                    //     //                       icon: Icon(Icons
                    //     //                           .person), // Example IconButton
                    //     //                     ),
                    //     //                     IconButton(
                    //     //                       tooltip: "Send message",
                    //     //                       onPressed: () {},
                    //     //                       icon: Icon(Icons
                    //     //                           .send_sharp), // Example IconButton
                    //     //                     ),
                    //     //                   ],
                    //     //                 ),
                    //     //               ],
                    //     //             ),
                    //     //           ),
                    //     //         );
                    //     //       },
                    //     //     );
                    //     //     Overlay.of(context).insert(popupDialog!);
                    //     //   },
                    //     //   onLongPressMoveUpdate: (posmove) async {
                    //     //     print(posmove.globalPosition.toString() + "moving");
                    //     //     if ((posmove.globalPosition.dx >= 95 &&
                    //     //             posmove.globalPosition.dx <= 108) &&
                    //     //         (posmove.globalPosition.dy >= 575 &&
                    //     //             posmove.globalPosition.dy <= 595)) {
                    //     //       print("ling thw post");
                    //     //       BlocProvider.of<ExploreBloc>(context)
                    //     //           .add(UserClickOnLikedBtn(false));
                    //     //       await Future.delayed(Duration(seconds: 3));
                    //     //       popupDialog!.remove();
                    //     //       ispopupremoved = true;
                    //     //       print(ispopupremoved.toString());
                    //     //     }
                    //     //   },
                    //     //   onLongPressEnd: (details) async{
                    //     //     if(ispopupremoved==true){
                    //     //
                    //     //     }
                    //     //     else{
                    //     //       popupDialog!.remove();
                    //     //     }
                    //     //
                    //     //   },
                    //     //   child: ClipRRect(
                    //     //     borderRadius: BorderRadius.circular(8.0),
                    //     //     child: Image.network(
                    //     //       images[index],
                    //     //       fit: BoxFit.cover,
                    //     //       width: double.infinity,
                    //     //       height: double.infinity,
                    //     //     ),
                    //     //   ),
                    //     // );
                    //   },
                    // );
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
