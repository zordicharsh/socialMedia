import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import 'package:socialmedia/screens/exploreimage/exploreimagepage.dart';
import 'package:socialmedia/screens/search_user/explorebloc/explore_bloc.dart';
import 'package:socialmedia/screens/search_user/searchui/searchui.dart';
import 'package:video_player/video_player.dart';
class AllUserPosts extends StatefulWidget {
  const AllUserPosts({super.key});

  @override
  State<AllUserPosts> createState() => _AllUserPostsState();
}

class _AllUserPostsState extends State<AllUserPosts> {
  VideoPlayerController? controller;
  bool islike = false;
  bool isloading=false;
  late OverlayEntry? popupDialog;
  ScrollController _scrollController = ScrollController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List <DocumentSnapshot> _userdata = [];
  bool gettingmoreData=false;
  bool moreuserdataavailable = true;
  QuerySnapshot ?querySnapshot2;
  bool _loadingProduct = true;
  int _perPageData = 10;
  DocumentSnapshot ?_lastdoc;










//   getAllUserData() async{
//      Query q = await _firestore.collection("UserPost").orderBy("postid").where('acctype',isEqualTo: 'public').limit(_perPageData);
//
//      // _loadingProduct = true;
//      QuerySnapshot querySnapshot= await q.get();
//      _userdata = querySnapshot.docs;
//      // _loadingProduct = false;
//      _lastdoc =  querySnapshot.docs[querySnapshot.docs.length-1];
//      print(querySnapshot.toString()+"yoyo");
//
//
// }
//
//
//
// getMoreData() async{
//     print(_userdata.toString());
//     setState(() {
//       isloading = true;
//     });
//     if(moreuserdataavailable == false){
//       print("no more data");
//       setState(() {
//         isloading = false;
//       });
//       return;
//     }
//     if(gettingmoreData == true){
//       print("more data");
//       return;
//     }
//     gettingmoreData =true;
//     Query q = _firestore.collection("UserPost").orderBy("postid").where('acctype',isEqualTo: 'public').startAfter([_lastdoc!.get("postid")]).limit(_perPageData);
// querySnapshot2= await q.get();
//   if(querySnapshot2!.docs.length < _perPageData){
//     moreuserdataavailable = false;
//   }
//   _lastdoc = querySnapshot2!.docs[querySnapshot2!.docs.length-1];
//   _userdata.addAll(querySnapshot2!.docs);
//   print(querySnapshot2!.docs.length.toString()+"moredata");
//   print(_userdata.length.toString()+"more data");
//   gettingmoreData = false;
//     setState(() {
//       isloading = false;
//     });
//   setState(() {});
// print(querySnapshot2.toString()+"more data");
// }
//
//
//
//
//
//
//
//
// @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print("inint is calling");
//     getAllUserData();
//     log(_userdata.toString());
//     _scrollController.addListener(() {
//       double maxScroll = _scrollController.position.maxScrollExtent;
//       double currentScroll = _scrollController.position.pixels;
//       double delta = MediaQuery.of(context).size.height * 0.25;
//       if(maxScroll == currentScroll){
//        getMoreData();
//       }});
//   }
//
//
//
//


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("name of explaorepage"),surfaceTintColor: Colors.black,actions:[IconButton(onPressed: (){
        Navigator.push(context,CustomPageRouteRightToLeft(child: const SearchUser()));
      },icon: const Icon(Icons.search),)]),
      body:
      FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("UserPost").where('acctype',isEqualTo: 'public')
            .get(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return CustomScrollView(
              slivers: [
                SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          if (snapshot.data!.docs[index]['type'] ==
                              "image") {
                            return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      CustomPageRouteRightToLeft(child: ExplorePageImage(
                                          uid: snapshot.data!.docs[index]['uid'], postuid: snapshot.data!.docs[index]['postid']))
                                  );
                                },
                                onLongPressEnd: (details) async {
                                  popupDialog!.remove();
                                },
                                onLongPress: () {
                                  popupDialog = OverlayEntry(
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Colors.black,
                                        child: Container(
                                          constraints:
                                          const BoxConstraints(
                                              maxWidth: 600,
                                              maxHeight:
                                              650),
                                          child: Column(
                                            mainAxisSize:
                                            MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(
                                                        snapshot.data!.docs[index]['profileurl']
                                                    ),
                                                  ),
                                                  Text(
                                                      snapshot.data!.docs[index]['username']
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width:
                                                double.infinity,
                                                height:
                                                400, // Example height
                                                child:Image.network
                                                  (
                                                  snapshot.data!.docs[index]['posturl'],
                                                  fit: BoxFit
                                                      .cover, // Adjust the fit as per your requirement
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  IconButton(
                                                    tooltip:
                                                    "Send message",
                                                    onPressed:
                                                        () {
                                                      print(context
                                                          .toString());
                                                    },
                                                    icon: const Icon(
                                                        Icons
                                                            .favorite_border_rounded), // Example IconButton
                                                  ),
                                                  IconButton(
                                                    tooltip:
                                                    "Send message",
                                                    onPressed: () {},
                                                    icon: const Icon(Icons
                                                        .person), // Example IconButton
                                                  ),
                                                  IconButton(
                                                    tooltip:
                                                    "Send message",
                                                    onPressed: () {},
                                                    icon: const Icon(Icons
                                                        .send_sharp), // Example IconButton
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  Overlay.of(context)
                                      .insert(popupDialog!);
                                },
                                child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8.0),
                                    child: Image.network(
                                      snapshot.data!.docs[index]['posturl'],
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.low,
                                      width: double.infinity,
                                      height: double.infinity,
                                    )));
                          }
                          else
                          {
                            return
                              Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(8.0),
                                      child: Image.network(
                                        snapshot.data!.docs[index]['thumbnail'],
                                        fit: BoxFit.cover,
                                        filterQuality: FilterQuality.low,
                                        width: double.infinity,
                                        height: double.infinity,
                                      )),
                                  const Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Icon(
                                      Icons
                                          .tv_sharp, // Replace Icons.close with your desired icon
                                      color: Colors.black,
                                      size: 24.0,
                                    ),
                                  ),
                                ],
                              );
                            ClipRRect(
                                borderRadius:
                                BorderRadius.circular(8.0),
                                child: Image.network(
                                  _userdata[index].get("thumbnail"),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                  width: double.infinity,
                                  height: double.infinity,
                                ));
                            // return Center(child: const Text("this is Video Player"));
                            //   controller =
                            //   VideoPlayerController.networkUrl(
                            //       Uri.parse(snapshot
                            //           .data!.docs[index]
                            //           .get("posturl")))
                            //     ..initialize()
                            //     ..pause();
                            //   return Stack(
                            //     children: [
                            //       ClipRRect(
                            //         borderRadius:
                            //         BorderRadius.circular(8.0),
                            //         child: VideoPlayer(controller!),
                            //       ),
                            //       const Positioned(
                            //         top: 0,
                            //         right: 0,
                            //         child: Icon(
                            //           Icons
                            //               .tv_sharp, // Replace Icons.close with your desired icon
                            //           color: Colors.white,
                            //           size: 24.0,
                            //         ),
                            //       ),
                            //     ],
                            //   );
                          }
                        }, childCount: snapshot.data!.size),
                    gridDelegate: SliverQuiltedGridDelegate(
                        crossAxisCount: 3,
                        mainAxisSpacing: 3,
                        crossAxisSpacing: 3,
                        pattern: [
                          const QuiltedGridTile(2, 1),
                          const QuiltedGridTile(2, 2),
                          const QuiltedGridTile(1, 1),
                          const QuiltedGridTile(1, 1),
                          const QuiltedGridTile(1, 1),
                        ])),
                SliverToBoxAdapter(child: isloading ? const Center(child: CircularProgressIndicator(color: Colors.white)):const SizedBox())
              ],
            );
          }
          else{
            return Container();
          }

          // return GridView.builder(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 3,
          //     crossAxisSpacing: 4.0,
          //     mainAxisSpacing: 4.0,
          //   ),
          //   itemCount: snapshot.data!.size,
          //   itemBuilder: (BuildContext _, int index) {
          //   },);
          // return GridView.builder(
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 3,
          //     crossAxisSpacing: 4.0,
          //     mainAxisSpacing: 4.0,
          //   ),
          //   itemCount: images.length,
          //   itemBuilder: (BuildContext _, int index) {
          //     return GestureDetector(
          //         child: ClipRRect(
          //           borderRadius: BorderRadius.circular(8.0),
          //           child: Image.network(
          //             images[index],
          //             fit: BoxFit.cover,
          //             width: double.infinity,
          //             height: double.infinity,
          //           )
          //     ));
          // return GestureDetector(
          //   onLongPress: () {
          //     popupDialog = OverlayEntry(
          //       builder: (context) {
          //         return Dialog(
          //           backgroundColor: Colors.black,
          //           child: Container(
          //             constraints: BoxConstraints(
          //                 maxWidth: 600,
          //                 maxHeight: 650), // Example constraints
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 SizedBox(
          //                   width: double.infinity,
          //                   height: 400, // Example height
          //                   child: Image.network(
          //                     images[index],
          //                     fit: BoxFit
          //                         .cover, // Adjust the fit as per your requirement
          //                   ),
          //                 ),
          //                 Row(
          //                   mainAxisAlignment:
          //                       MainAxisAlignment.spaceEvenly,
          //                   children: [
          //                     BlocBuilder<ExploreBloc,
          //                         ExploreState>(
          //                       builder: (context, state) {
          //                         if(state is showliking){
          //                           if(state.Islike == true){
          //                             return IconButton(
          //                               tooltip: "Send message",
          //                               onPressed: () {
          //                                 print(context.toString());
          //                               },
          //                               icon: Icon(Icons
          //                                   .favorite), // Example IconButton
          //                             );
          //                           }else{
          //                             return IconButton(
          //                               tooltip: "Send message",
          //                               onPressed: () {
          //                                 print(context.toString());
          //                               },
          //                               icon: Icon(Icons
          //                                   .favorite_border_rounded), // Example IconButton
          //                             );
          //                           }
          //                         }
          //                         return IconButton(
          //                           tooltip: "Send message",
          //                           onPressed: () {
          //                             print(context.toString());
          //                           },
          //                           icon: Icon(Icons
          //                               .favorite_border_rounded), // Example IconButton
          //                         );
          //                       },
          //                     ),
          //                     IconButton(
          //                       tooltip: "Send message",
          //                       onPressed: () {},
          //                       icon: Icon(Icons
          //                           .person), // Example IconButton
          //                     ),
          //                     IconButton(
          //                       tooltip: "Send message",
          //                       onPressed: () {},
          //                       icon: Icon(Icons
          //                           .send_sharp), // Example IconButton
          //                     ),
          //                   ],
          //                 ),
          //               ],
          //             ),
          //           ),
          //         );
          //       },
          //     );
          //     Overlay.of(context).insert(popupDialog!);
          //   },
          //   onLongPressMoveUpdate: (posmove) async {
          //     print(posmove.globalPosition.toString() + "moving");
          //     if ((posmove.globalPosition.dx >= 95 &&
          //             posmove.globalPosition.dx <= 108) &&
          //         (posmove.globalPosition.dy >= 575 &&
          //             posmove.globalPosition.dy <= 595)) {
          //       print("ling thw post");
          //       BlocProvider.of<ExploreBloc>(context)
          //           .add(UserClickOnLikedBtn(false));
          //       await Future.delayed(Duration(seconds: 3));
          //       popupDialog!.remove();
          //       ispopupremoved = true;
          //       print(ispopupremoved.toString());
          //     }
          //   },
          //   onLongPressEnd: (details) async{
          //     if(ispopupremoved==true){
          //
          //     }
          //     else{
          //       popupDialog!.remove();
          //     }
          //
          //   },
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(8.0),
          //     child: Image.network(
          //       images[index],
          //       fit: BoxFit.cover,
          //       width: double.infinity,
          //       height: double.infinity,
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}