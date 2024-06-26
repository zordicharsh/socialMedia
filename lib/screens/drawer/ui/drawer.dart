import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:socialmedia/screens/Drawer/bloc/drawer_bloc.dart';
import 'package:socialmedia/screens/Drawer/bloc/drawer_event.dart';
import 'package:socialmedia/screens/Drawer/bloc/drawer_state.dart';

import '../../login/ui/loginui.dart';



class MyDrawer extends StatefulWidget {
  var Url;
  var Name;
  var date;

  MyDrawer(this.Url, this.Name, this.date, {super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  bool vvv = false;
  late OverlayEntry circularLoadingBar;
  TextEditingController Delete = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 220.sp,
      child: Container(
        color: const Color(0xff212121),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              curve: Curves.easeInOut,
              decoration: const BoxDecoration(
                color: Color(0xff212121),
              ),
              child: Column(
                children: [
                  widget.Url != ""
                      ? CachedNetworkImage(
                          imageUrl: widget.Url,
                          placeholder: (context, url) => CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.3),
                            radius: 36.sp,
                          ),
                          imageBuilder: (context, imageProvider) =>
                              CircleAvatar(
                                  radius: 36.sp,
                                  backgroundImage: imageProvider),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(0.2),
                          radius: 36.sp,
                          child: Icon(
                            Icons.person,
                            size: 66,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                  SizedBox(
                    height: 6.sp,
                  ),
                  Text(
                    widget.Name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
                  ),
                  Text(
                    "Joined Date: ${widget.date}",
                    style:
                        TextStyle(fontWeight: FontWeight.w200, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            ListTile(
              title: const Text("Private"),
              trailing: BlocBuilder<DrawerBloc, DrawerState>(
                builder: (context, state) {
                  if (state is PublicPrivateTrueState) {
                    return SizedBox(
                      height: 37,
                      child: LiteRollingSwitch(
                        width: 90,
                        textOn: 'ON',
                        textOff: 'OFF',
                        colorOn: Colors.black,
                        colorOff: Colors.black,
                        textOnColor: Colors.white,
                        textOffColor: Colors.white,
                        iconOn: Icons.lock,
                        iconOff: Icons.lock_open,
                        value: state.CheckState,
                        animationDuration: const Duration(milliseconds: 60),
                        onChanged: (value) {
                          BlocProvider.of<DrawerBloc>(context)
                              .add(PublicPrivateTrueEvent(true));
                        },
                        onTap: () {},
                        onDoubleTap: () {},
                        onSwipe: () {},
                      ),
                    );
                  } else if (state is PublicPrivateFaleState) {
                    return SizedBox(
                      height: 37,
                      child: LiteRollingSwitch(
                        width: 90,
                        textOn: 'ON',
                        textOff: 'OFF',
                        textOnColor: Colors.white,
                        textOffColor: Colors.white,
                        colorOn: Colors.black,
                        colorOff: Colors.black,
                        value: state.CheckState,
                        iconOn: Icons.lock,
                        iconOff: Icons.lock_open,
                        animationDuration: const Duration(milliseconds: 60),
                        onChanged: (value) {
                          BlocProvider.of<DrawerBloc>(context)
                              .add(PublicPrivateTrueEvent(false));
                        },
                        onTap: () {},
                        onDoubleTap: () {},
                        onSwipe: () {},
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: 37,
                      child: LiteRollingSwitch(
                        width: 90,
                        value: false,
                        textOn: 'ON',
                        textOff: 'OFF',
                        textOnColor: Colors.white,
                        textOffColor: Colors.white,
                        colorOn: Colors.black,
                        colorOff: Colors.black,
                        iconOn: Icons.lock,
                        iconOff: Icons.lock_open,
                        animationDuration: const Duration(milliseconds: 60),
                        onChanged: (value) {
                          BlocProvider.of<DrawerBloc>(context)
                              .add(PublicPrivateTrueEvent(false));
                        },
                        onTap: () {},
                        onDoubleTap: () {},
                        onSwipe: () {},
                      ),
                    );
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Sign Out'),
              trailing: const Icon(Icons.exit_to_app),
              onTap: () {
                showOptionsDialog2(context);
              },
            ),
            ListTile(
              title: const Text('Delete'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                showOptionsDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showOptionsDialog(BuildContext context) async {
    final deletekey = GlobalKey<FormState>();
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          title: const Text('To Delete Account Write Delete',
              style: TextStyle(fontSize: 16)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: deletekey,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null) {
                        return "Write Delete";
                      } else if (value != 'Delete') {
                        return "Write Delete";
                      }
                      return null;
                    },
                    controller: Delete,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 10.sp,
                          horizontal:
                              12.sp), // Adjust the padding to make it smaller
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(60.sp, 40.sp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ), // Set button size
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (deletekey.currentState!.validate()) {
                          circularLoadingBar = _createCircularLoadingBar();
                          Overlay.of(context).insert(circularLoadingBar);
                          BlocProvider.of<DrawerBloc>(context)
                              .add(DeleteAccountEvent());
                          Future.delayed(const Duration(milliseconds: 5000),
                              () async {
                            await FirebaseAuth.instance.currentUser?.delete();
                            circularLoadingBar.remove();
                            if (!context.mounted) return;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginUi()));
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: Size(60.sp, 40.sp),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: const Text(
                        "Delete",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showOptionsDialog2(BuildContext context) async {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
            title: const Text(
              "Alert !",
              style: TextStyle(fontSize: 20),
            ),
            content: Text('Do you want to Logout?',
                style: TextStyle(fontSize: 16.sp)),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                  isDestructiveAction: false,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.white60),
                  )),
              CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () {
                    BlocProvider.of<DrawerBloc>(context).add(SignOutEvent());
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginUi()));
                  },
                  child: const Text("Yes")),
            ]);
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
}
