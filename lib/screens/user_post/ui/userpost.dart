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
  File? Check ;
  var CheckWhichState = "";
  @override
  void dispose() {
    videoPlayerController?.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: BlocBuilder<UserpostBloc, UserPostStates>(
        builder: (context, state) {
          if (state is SuccessFullySelectedImage) {
            Check=state.sentimage;
            CheckWhichState='image';
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
          } else if (state is SuccessFullySelectedVideo) {
            Check= state.sentvideo;
            CheckWhichState='video';
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
            CheckWhichState="";
            return const Center(child: Text("Image can't be uploaded"));
          } else if (state is LoadingComeState) {
            videoPlayerController?.dispose();
            return const Center(child: CircularProgressIndicator());
          } else if (state is LoadingGoState) {
            videoPlayerController?.dispose();
            return const Center(child: Text("Picture has been uploaded"));
          } else if (state is AbletoUplaodImage) {
            videoPlayerController?.dispose();
            Check = null;
            CheckWhichState="";
            return const Center(child: Text("Successfully uploaded"));
          }
          else if(state is RemovePhotoOrVideoState){
            Check = null;
            videoPlayerController!.dispose();
            return Column(
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
              ],
            );
          }
          else {
            return Column(
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
              ],
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        child: BlocListener<UserpostBloc, UserPostStates>(
          listener: (context, state) {},
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  showOptionsDialog(context);
                },
                icon: const Icon(Icons.camera),
              ),
              BlocBuilder<GlobalBloc, GlobalState>(
                builder: (context, state) {
                  var listen;
                  if (state is GetUserDataFromGlobalBlocState) {
                    listen = state.userData[0].Profileurl;
                    return ElevatedButton(
                      onPressed: () {
                        if(Check != null && CheckWhichState == 'image') {
                          BlocProvider.of<UserpostBloc>(context).add(UserClickonPostbtn(profileurl: listen, caption: caption.text.trim(),),);
                        }
                        else if(Check != null && CheckWhichState == 'video')
                          {
                            BlocProvider.of<UserpostBloc>(context).add(UserVideoPost(caption.text.trim(),listen));
                          }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("First Select Image or Reel"),duration:Duration(seconds: 1),));
                        }
                      },
                      child: const Text('Upload Image'),
                    );
                  } else {
                    return ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Check line number 109 in userpost.dart //coded by dipak"),
                          ),
                        );
                      },
                      child: const Text('Upload Image'),
                    );
                  }
                },
              ),
            ],
          ),
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
                    BlocProvider.of<UserpostBloc>(context).add(UserRemoveViedoOrImageEvent());
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
