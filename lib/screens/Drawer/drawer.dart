import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:socialmedia/screens/Drawer/drawer_bloc.dart';
import 'package:socialmedia/screens/Drawer/drawer_event.dart';
import 'package:socialmedia/screens/Drawer/drawer_state.dart';
import '../login/loginui.dart';

class MyDrawer extends StatefulWidget {
  var Url;
  var Name;
  var date;
  MyDrawer(this.Url, this.Name, this.date);
  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  bool vvv = false;
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
                          backgroundColor: Colors.grey.withOpacity(0.3),
                          radius: 36.sp,
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
                    "Join Date: ${widget.date}",
                    style:
                        TextStyle(fontWeight: FontWeight.w200, fontSize: 12.sp),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text("Private"),
              trailing: BlocBuilder<DrawerBloc, DrawerState>(
                builder: (context, state) {
                  if (state is PublicPrivateTrueState) {
                    print("Under TrueState");
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
                    print("Under FalseState");
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
                    print("Under else");
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
                BlocProvider.of<DrawerBloc>(context).add(SignOutEvent());
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const LoginUi()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
