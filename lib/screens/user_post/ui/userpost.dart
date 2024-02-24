import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/global_Bloc/global_bloc.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_bloc.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_event.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_state.dart';

class ImageUploadScreen extends StatefulWidget {
  const ImageUploadScreen({super.key});

  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUploadScreen> {
  TextEditingController capttion = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: BlocBuilder<UserpostBloc, UserPostStates>(
          builder: (context, state) {
            if (state is SuccessFullySelectedImage) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(decoration: InputDecoration(
                          hintText: "Write a caption",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)
                          )
                      ),
                        controller: capttion,
                      ),
                      Image.file(state.sentimage, fit: BoxFit.fill,
                        height: 530,
                        width: 350,),
                    ],
                  ),
                ),
              );
            }
            else if (state is UnSuccessFullySelectedImage) {
              return const Center(child: Text("image can't be uploaded"));
            }
            else if (state is LoadingComeState) {
              return const Center(
                child: CircularProgressIndicator(
                ),
              );
            }
            else if (state is LoadingGoState) {
              return const Center(child: Text("Picture has been uploaded"));
            }
            else if (state is AbletoUplaodImage) {
              return const Center(child: Text("Success Fully Uploaded"));
            }
            else {
              return Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Write a caption",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                        )
                    ),
                    controller: capttion,
                  )
                ],
              );
            }
          }
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: BottomAppBar(
        child: BlocListener<UserpostBloc, UserPostStates>(
          listener: (context, state) {

          },
          child: Row(
            children: [
              IconButton(onPressed: () {
                BlocProvider.of<UserpostBloc>(context).add(UsergetImage());
              }, icon: Icon(Icons.camera)
              ),
              BlocBuilder<GlobalBloc, GlobalState>(
                builder: (context, state) {
                  var listen;
                  if (state is GetUserDataFromGlobalBlocState) {
                    listen = state.userData[0].Profileurl;
                    return ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<UserpostBloc>(context).add(
                            UserClickonPostbtn(profileurl: listen,
                                caption: capttion.text.trim()));
                      },
                      child: const Text('Upload Image'),
                    );
                  }
                  else {
                    return ElevatedButton(
                      onPressed: () {
                        SnackBar(content: Text(
                            "check line number 109 in userpost.dart //coded by dipak"));
                        Tooltip(
                          message: "check line number 109 in userpost.dart //coded by dipak",);
                        /*  BlocProvider.of<UserpostBloc>(context).add(
                            UserClickonPostbtn());*/
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
}
