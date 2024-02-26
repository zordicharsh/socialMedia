import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile_bloc.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile_event.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile_state.dart';

import '../../../global_Bloc/global_bloc.dart';
class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}
class _EditProfileState extends State<EditProfile> {
  File? imageFile;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  late OverlayEntry circularLoadingBar;
  final _editprofilekey = GlobalKey<FormState>();

  String? url;
  @override
  void initState() {
    BlocProvider.of<EditprofileBloc>(context).add(GetUserAlldataEvent());
    super.initState();
  }
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditprofileBloc, EditProfileState>(
      builder: (context, state) {
        if(state is GetUserAllDataState)
          {
            _nameController = TextEditingController(text: state.naam);
             _bioController = TextEditingController(text: state.Bio);
            _usernameController = TextEditingController(text: state.Usernaam);
            url = state.profileUrl;
            return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  title: const Text('Edit Profile'),
                ),
                body: Form(
                  key: _editprofilekey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showOptionsDialog(context);
                            },
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                 radius: 50,
                                 backgroundColor: Colors.grey.withOpacity(0.3),
                                 backgroundImage: imageFile != null
                                     ? FileImage(imageFile!)
                                     : null,
                                 child: (imageFile == null)
                                     ? ClipOval(child: CachedNetworkImage(imageUrl: url!, fit: BoxFit.cover, height: 120,width: 120,filterQuality: FilterQuality.low, ),)
                                     : null,),
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
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                            decoration:
                            const InputDecoration(labelText: 'Name'),
                          ),
                          TextFormField(
                            controller: _bioController,
                            decoration:
                            const InputDecoration(labelText: 'Bio'),
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
                            listener: (context, state) async{
                              if (state is EditProfileUserNameErrorState) {
                                circularLoadingBar.remove();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.ErrorMessage),
                                  ),
                                );
                              } else if (state is EditProfileMessageSuccessState) {

                                circularLoadingBar.remove();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.SuccessMessage),
                                  ),
                                );
                                BlocProvider.of<GlobalBloc>(context).add(GetUserIDEvent(uid: state.uid));
                                await Future.delayed(const Duration(milliseconds: 200));
                                Navigator.pop(context);
                              } else if (state is EditProfileSuccessState) {
                                if (imageFile == null) {

                                  BlocProvider.of<EditprofileBloc>(context).add(EditProfileDataPassEvent2(url!, _usernameController.text.toString().trim(), _nameController.text.toString().trim(), _bioController.text.toString().trim()),);

                                } else {

                                  BlocProvider.of<EditprofileBloc>(context).add(EditProfileDataPassEvent(imageFile, _usernameController.text.toString().trim(), _nameController.text.toString().trim(), _bioController.text.toString().trim()),);

                                }
                              }
                            },
                            child: ElevatedButton(
                                onPressed: ()  {
                                if (_editprofilekey.currentState!.validate()) {
                                    circularLoadingBar = _createCircularLoadingBar();
                                    Overlay.of(context).insert(circularLoadingBar);
                                      print("phela if 1");
                                      BlocProvider.of<EditprofileBloc>(context).add(EditProfilUserNameCheckEvent(_usernameController.text.toString().trim(),url!,_nameController.text.toString().trim(),_bioController.text.toString().trim(),));
                                  }
                                },
                              child: const Text("submit"),
                            ),
                          )
                        ],
                      )),
                ));
          }
        else if(state is IfUserProfilePicIsNull)
          {
            { _nameController = TextEditingController(text: state.naam);
            _bioController = TextEditingController(text: state.Bio);
            _usernameController = TextEditingController(text: state.Usernaam);
            return Scaffold(
                backgroundColor: Colors.black,
                appBar: AppBar(
                  backgroundColor: Colors.black,
                  title: const Text('Edit Profile'),
                ),
                body: Form(
                  key: _editprofilekey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showOptionsDialog(context);
                            },
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.grey.withOpacity(0.3),
                                    backgroundImage: imageFile != null
                                        ? FileImage(imageFile!)
                                        : null,
                                    child: (imageFile == null)
                                        ? const Icon(Icons.person)
                                        : null),
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
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                            decoration:
                            const InputDecoration(labelText: 'Name'),
                          ),
                          TextFormField(
                            controller: _bioController,
                            decoration:
                            const InputDecoration(labelText: 'Bio'),
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
                          BlocListener<EditprofileBloc,EditProfileState>(
                            listener: (context, state) async{
                              if (state is EditProfileUserNameErrorState) {
                                circularLoadingBar.remove();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.ErrorMessage),
                                  ),
                                );
                              } else if (state is EditProfileMessageSuccessState) {
                                circularLoadingBar.remove();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.SuccessMessage),),);
                                BlocProvider.of<GlobalBloc>(context).add(GetUserIDEvent(uid: state.uid));
                                await Future.delayed(const Duration(milliseconds: 200));
                                Navigator.pop(context);
                              } else if (state is EditProfileSuccessState) {
                                if (imageFile == null) {
                                  print("phela if 3  from listrener");
                                  BlocProvider.of<EditprofileBloc>(context).add(EditProfileDataPassEvent2("", _usernameController.text.toString().trim(), _nameController.text.toString().trim(), _bioController.text.toString().trim()),);

                                } else {
                                  print("phela if 4 listerner");
                                  BlocProvider.of<EditprofileBloc>(context).add(EditProfileDataPassEvent(imageFile, _usernameController.text.toString().trim(), _nameController.text.toString().trim(), _bioController.text.toString().trim()),);

                                }
                              }
                            },
                            child: ElevatedButton(
                              onPressed: ()  {
                                if (_editprofilekey.currentState!.validate()) {
                                  circularLoadingBar = _createCircularLoadingBar();
                                  Overlay.of(context).insert(circularLoadingBar);
                                  print("phela if 1");
                                  BlocProvider.of<EditprofileBloc>(context).add(EditProfilUserNameCheckEvent(_usernameController.text.toString().trim(),"",_nameController.text.toString().trim(),_bioController.text.toString().trim(),));
                                }

                              },
                              child: const Text("submit"),
                            ),
                          )
                        ],
                      )),
                ));
            }
          }
        else
        {
          return Scaffold(
              backgroundColor: Colors.black,
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: const Text('Edit Profile'),
              ),
              body: Form(
                key: _editprofilekey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                           showOptionsDialog(context);
                          },
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey.withOpacity(0.3),
                                backgroundImage: imageFile != null
                                    ? FileImage(imageFile!)
                                    : null,
                                child: (imageFile == null)
                                    ? const Icon(Icons.person)
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
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                          decoration:
                          const InputDecoration(labelText: 'Name'),
                        ),
                        TextFormField(
                          controller: _bioController,
                          decoration:
                          const InputDecoration(labelText: 'Bio'),
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
                          listener: (context, state) async{
                            if (state is EditProfileUserNameErrorState) {
                              circularLoadingBar.remove();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.ErrorMessage),
                                ),
                              );
                            }
                            else if (state is EditProfileMessageSuccessState) {
                              circularLoadingBar.remove();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.SuccessMessage),
                                ),
                              );
                              BlocProvider.of<GlobalBloc>(context).add(GetUserIDEvent(uid: state.uid));
                              await Future.delayed(const Duration(milliseconds: 200));
                              Navigator.pop(context);
                            }
                            else if (state is EditProfileSuccessState) {
                              if (imageFile == null) {
                                print("phela if 3  from listrener");
                                BlocProvider.of<EditprofileBloc>(context).add(EditProfileDataPassEvent2("", _usernameController.text.toString().trim(), _nameController.text.toString().trim(), _bioController.text.toString().trim()),);

                              } else {
                                print("phela if 4 listerner");
                                BlocProvider.of<EditprofileBloc>(context).add(EditProfileDataPassEvent(imageFile, _usernameController.text.toString().trim(), _nameController.text.toString().trim(), _bioController.text.toString().trim()),);

                              }
                            }
                          },
                          child: ElevatedButton(
                            onPressed: ()  {
                              if (_editprofilekey.currentState!.validate()) {
                                circularLoadingBar = _createCircularLoadingBar();
                                Overlay.of(context).insert(circularLoadingBar);
                                print("phela if 1");
                                BlocProvider.of<EditprofileBloc>(context).add(EditProfilUserNameCheckEvent(_usernameController.text.toString().trim(),"",_nameController.text.toString().trim(),_bioController.text.toString().trim(),));
                              }
                            },
                            child: const Text("submit"),
                          ),
                        )
                      ],
                    )),
              ));
        }
      },
    );
  }
  OverlayEntry _createCircularLoadingBar() {
    return OverlayEntry(
      builder: (context) => Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: const CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
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
                ),
                ListTile(
                  onTap: () {
                   if(imageFile != null)
                     {
                       setState(() {
                         imageFile = null;
                       });
                     }
                   else
                     {
                       BlocProvider.of<EditprofileBloc>(context).add(ShowingNullProfile("", _usernameController.text.toString().trim(), _nameController.text.toString().trim(), _bioController.text.toString().trim(),),);
                     }
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
