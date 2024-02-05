import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile_bloc.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile_event.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile_state.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);
  @override
  State<EditProfile> createState() => _EditProfileState();
}
class _EditProfileState extends State<EditProfile> {
  File? imageFile;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final _editprofilekey = GlobalKey<FormState>();
  String UsernameCheck = "dipakfuck";

  void selectImage(ImageSource source) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      _cropImage(File(pickedFile.path));
    }
  }
  void _cropImage(File file) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 20,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.blue,
          toolbarWidgetColor: Colors.white,
          cropFrameColor: Colors.blue.withOpacity(0.7),
          cropGridColor: Colors.blue.withOpacity(0.4),
          showCropGrid: true,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );
    if (croppedImage != null) {
      setState(() {
        imageFile = File(croppedImage.path);
      });
    }
  }


  void showOptionsDialog(BuildContext context) async {
    return showDialog<void>(
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
                    selectImage(ImageSource.gallery);
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(Icons.photo_album),
                  title: const Text("Select from Gallery"),
                ),
                ListTile(
                  onTap: () {
                    selectImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                  leading: const Icon(Icons.camera),
                  title: const Text("Camera"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Edit Profile'),
      ),
      body: Form(
        key: _editprofilekey,
        child: GestureDetector(
            onTap: () {
              showOptionsDialog(context);
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            backgroundImage: imageFile != null
                                ? FileImage(imageFile!)
                                : null,
                            child: (imageFile == null)
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                  )
                                : null,
                          ),
                          Positioned(
                              top: 62.sp,
                              left: 62.sp,
                              child: const CircleAvatar(
                                backgroundColor: Colors.black,
                                radius: 12,
                                child: CircleAvatar(
                                    backgroundColor: Colors.blue,
                                    radius: 10,
                                    child: Center(
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 16,
                                        ))),
                              ))
                        ],
                      ),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Name";
                          } else {
                            return null;
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Name'),
                      ),
                      TextFormField(
                        controller: _bioController,
                        decoration: const InputDecoration(labelText: 'Bio'),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Email or Username";
                          } else if (RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'please enter username in valid format';
                          } else {
                            return null;
                          }
                        },
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                      ),
                      const SizedBox(height: 40),
                      BlocListener<EditprofileBloc, EditProfileState>(
                        listener: (context, state) {
                         if(state is EditProfileUserNameErrorState){
                           ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text(state.ErrorMessage)));
                         }
                         else if(state is EditProfileMessageSuccessState){
                           ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text(state.SuccessMessage)));
                         }
                         else if(state is EditProfileSuccessState)
                           {
                             if (imageFile == null) {
                               print("phela if 3  from listrener");
                               BlocProvider.of<EditprofileBloc>(context).add(EditProfileDataPassEvent2("", _usernameController.text.toString().trim(), _nameController.text.toString().trim(), _bioController.text.toString().trim()));
                             } else {
                               print("phela if 4 listerner");
                               BlocProvider.of<EditprofileBloc>(context).add(EditProfileDataPassEvent(imageFile, _usernameController.text.toString().trim(), _nameController.text.toString().trim(),_bioController.text.toString().trim()));}
                           }
                        },
                        child: ElevatedButton(
                          onPressed: () {
                            if (_editprofilekey.currentState!.validate()) {
                              print("phela if 1");
                              if (UsernameCheck.toString().trim() == _usernameController.text.toString().trim()) {
                                print("phela if 2");
                                if (imageFile == null) {
                                  print("phela if 3");
                                  BlocProvider.of<EditprofileBloc>(context).add(EditProfileDataPassEvent2("", _usernameController.text.toString().trim(), _nameController.text.toString().trim(), _bioController.text.toString().trim()));
                                } else {
                                  print("phela if 4");
                                  BlocProvider.of<EditprofileBloc>(context).add(EditProfileDataPassEvent(imageFile, _usernameController.text.toString().trim(), _nameController.text.toString().trim(),_bioController.text.toString().trim()));}
                              } else {
                                print("phela if 5");
                                BlocProvider.of<EditprofileBloc>(context).add(EditProfilUserNameCheckEvent(_usernameController.text.toString().trim()));
                              }
                            }
                          },
                          child: const Text("submit"),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
