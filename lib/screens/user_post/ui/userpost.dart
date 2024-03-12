import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:socialmedia/global_Bloc/global_bloc.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_bloc.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_event.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_state.dart';
import 'package:video_player/video_player.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({Key? key}) : super(key: key);

  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  TextEditingController caption = TextEditingController();
  VideoPlayerController? videoPlayerController;
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
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: BlocBuilder<UserpostBloc, UserPostStates>(
        builder: (context, state) {
          if (state is SuccessFullySelectedImage) {
            Check = state.sentimage;
            CheckWhichState = 'image';
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Write a caption",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      controller: caption,
                    ),
                    Image.file(
                      Check!,
                      fit: BoxFit.fill,
                      height: 530,
                      width: 350,
                    ),
                  ],
                ),
              ),
            );
          }
          else if (state is SuccessFullySelectedVideo) {
            Check = state.sentvideo;
            CheckWhichState = 'video';
            videoPlayerController = VideoPlayerController.file(state.sentvideo)
              ..initialize()
              ..play()
              ..setLooping(true);
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Write a caption",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      controller: caption,
                    ),
                    Container(
                      height: 530,
                      width: 330,
                      child: VideoPlayer(videoPlayerController!),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is UnSuccessFullySelectedImage) {
            Check = null;
            CheckWhichState = "";
            return const Center(child: Text("Image can't be uploaded"));
          } else if (state is LoadingComeState) {
            videoPlayerController?.dispose();
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadingGoState) {
            caption.dispose();
            videoPlayerController?.dispose();
            return const Center(child: Text("Picture has been uploaded"));
          } else if (state is AbletoUplaodImage) {
            videoPlayerController?.dispose();
            Check = null;
            CheckWhichState = "";
            return const Center(child: Text("Successfully uploaded"));
          } else if (state is RemovePhotoOrVideoState) {
            Check = null;
            if (videoPlayerController != null) {
              videoPlayerController!.dispose();
            }
          } else {
            return Center(
                child: Text("Select Photo")
            );
          }
          return SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<UserpostBloc,UserPostStates>(
              builder: (context, state) {
                if(state is LoadingComeState){
                  return SizedBox();
                }
                else{
                  return IconButton(
                    onPressed: () {
                      showOptionsDialog(context);
                    },
                    icon: const Icon(Icons.camera),
                  );
                }

              },
            ),
            BlocBuilder<UserpostBloc, UserPostStates>(
              builder: (context, state) {
                if (state is SuccessFullySelectedVideo ||
                    state is SuccessFullySelectedImage) {
                  return ElevatedButton(
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
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("First Select Image or Reel"),
                              duration: Duration(seconds: 1),
                            ));
                      }
                    },
                    child: const Text('Post'),
                  );
                } else {
                  return SizedBox();
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
                  leading: const Icon(Icons.photo_album),
                  title: const Text("Photo"),
                ),
                ListTile(
                  onTap: () {
                    BlocProvider.of<UserpostBloc>(context).add(UserGetVideo());
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(Icons.videocam),
                  title: const Text("Video"),
                ),
                ListTile(
                  onTap: () {
                    BlocProvider.of<UserpostBloc>(context)
                        .add(UserRemoveViedoOrImageEvent());
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(Icons.delete),
                  title: const Text("Remove Photo"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}