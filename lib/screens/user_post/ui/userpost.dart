import 'dart:io';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/global_Bloc/global_bloc.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_bloc.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_event.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_state.dart';


class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  TextEditingController caption = TextEditingController();
  CachedVideoPlayerController? videoPlayerController;
  File? Check;
  var CheckWhichState = "";

  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<UserpostBloc>(context).add(UserPostInitEvent());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text('Post'),
        backgroundColor: Colors.black,
      ),
      body: BlocBuilder<UserpostBloc, UserPostStates>(
        builder: (context, state) {
          if (state is SuccessFullySelectedImage) {
            Check = state.sentimage;
            CheckWhichState = 'image';
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,right: 8,left:8,bottom:20),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "caption...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      controller: caption,
                    ),
                  ),
                  const SizedBox(height: 96,),
                  Image.file(
                    Check!,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.39,
                    width:350,
                  ),
                ],
              ),
            );
          }
          else if (state is SuccessFullySelectedVideo) {
            Check = state.sentvideo;
            CheckWhichState = 'video';
            videoPlayerController = CachedVideoPlayerController.file(state.sentvideo)
              ..initialize()
              ..play()
              ..setLooping(true);
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0,right: 8,left:8,bottom:20),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "caption...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      controller: caption,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    width: 350,
                    child: AspectRatio(aspectRatio: videoPlayerController!
              .value.aspectRatio,child: CachedVideoPlayer(videoPlayerController!)),
                  ),
                ],
              ),
            );
          }
          else if (state is UnSuccessFullySelectedImage) {
            Check = null;
            CheckWhichState = "";
            return const Center(child: Text("Select appropriate Image."));
          }
          else if (state is LoadingComeState) {
            videoPlayerController?.dispose();
            return Center(child: CircularProgressIndicator(color: Colors.grey[700],));
          }
          else if (state is LoadingGoState) {
            caption.dispose();
            videoPlayerController?.dispose();
            return const Center(child: Text("Post has been uploaded"));
          }
          else if (state is AbletoUplaodImage) {
            videoPlayerController?.dispose();
            Check = null;
            CheckWhichState = "";
            BlocProvider.of<GlobalBloc>(context).add(
                GetUserIDEvent(uid: FirebaseAuth.instance.currentUser!.uid));
            return const Center(child: Text("Post has been uploaded."));
          }
          else if (state is RemovePhotoOrVideoState) {
            Check = null;
            if (videoPlayerController != null) {
              videoPlayerController!.dispose();
            }
          }
          else {
            return const Center(child: Text("Post photo or video."));
          }

          return const Center(child: Text("Post photo or video."));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[900],
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<UserpostBloc, UserPostStates>(
              builder: (context, state) {
                if (state is LoadingComeState) {
                  return const SizedBox();
                } else {
                  return IconButton(
                    onPressed: () {
                      showOptionsDialog(context);
                    },
                    icon: const Icon(CupertinoIcons.camera,size: 32,),
                  );
                }
              },
            ),

            BlocBuilder<UserpostBloc, UserPostStates>(
              builder: (context, state) {
                if (state is SuccessFullySelectedVideo ||
                    state is SuccessFullySelectedImage) {
                  return Row(
                    children: [
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (Check != null && CheckWhichState == 'image') {
                            BlocProvider.of<UserpostBloc>(context).add(
                              UserClickonPostbtn(
                                caption: caption.text.trim(),
                              ),
                            );
                          } else if (Check != null && CheckWhichState == 'video') {
                            BlocProvider.of<UserpostBloc>(context)
                                .add(UserVideoPost(caption.text.trim()));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("First Select Image or Reel"),
                              duration: Duration(seconds: 1),
                            ));
                          }
                        },
                        child: const Text('Post',style: TextStyle(color: Colors.white),),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void showOptionsDialog(BuildContext context) async {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          elevation: 0,
          title: const Text('Select an option'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    videoPlayerController?.dispose();
                    BlocProvider.of<UserpostBloc>(context).add(UsergetImage());
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(Icons.grid_on_rounded,),
                  title: const Text("Photo"),
                ),
                ListTile(
                  onTap: () {
                    BlocProvider.of<UserpostBloc>(context).add(UserGetVideo());
                    Navigator.of(context).pop();
                  },
                  leading: const Icon( Icons.video_library_outlined,),
                  title: const Text("Video"),
                ),
                ListTile(
                  onTap: () {
                    BlocProvider.of<UserpostBloc>(context)
                        .add(UserRemoveViedoOrImageEvent());
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(CupertinoIcons.delete,size: 22,),
                  title: const Text("Remove"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
