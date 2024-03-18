import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/firebase_options.dart';
import 'package:socialmedia/screens/Drawer/drawer_bloc.dart';
import 'package:socialmedia/screens/FollowingsAndFollowers/followers_following_bloc.dart';
import 'package:socialmedia/screens/SplashScreeenUI.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile_bloc.dart';
import 'package:socialmedia/screens/exploreimage/bloc/exploreimagebloc_bloc.dart';
import 'package:socialmedia/screens/follow_request_screen/request_bloc.dart';
import 'package:socialmedia/screens/login/loginbloc/login_bloc.dart';
import 'package:socialmedia/screens/navigation_handler/bloc/navigation_bloc.dart';
import 'package:socialmedia/screens/profile/bloc/comment_bloc/comment_bloc.dart';
import 'package:socialmedia/screens/profile/bloc/heart_animation_bloc/heart_bloc.dart';
import 'package:socialmedia/screens/profile/bloc/profile_bloc.dart';
import 'package:socialmedia/screens/search_user/explorebloc/explore_bloc.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_bloc.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_bloc.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'global_Bloc/global_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MyApp(navigatorKey: navigatorKey));
  });
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({
    required this.navigatorKey,
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NavigationBloc(),
          ),
          BlocProvider(
            create: (context) => UserpostBloc(),
          ),
          BlocProvider(
            create: (context) => GlobalBloc(),
          ),
          BlocProvider(
            create: (context) => SearchBloc(),
          ),
          BlocProvider(
            create: (context) => EditprofileBloc(),
          ),
          BlocProvider(
            create: (context) => LoginBloc(),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(),
          ),
          BlocProvider(
            create: (context) => CommentBloc(),
          ),
          BlocProvider(
            create: (context) => HeartBloc(),
          ),
          BlocProvider(
            create: (context) => ExploreBloc(),
          ),
          BlocProvider(
            create: (context) => DrawerBloc(),
          ),
          BlocProvider(
            create: (context) => exploreimageBloc(),
          ),
          BlocProvider(
            create: (context) => RequestBloc(),
          ),
          BlocProvider(
            create: (context) => FollowingFollowerBloc(),
          )
        ],
        child: MaterialApp(
            navigatorKey: widget.navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: const ColorScheme.dark(),
              useMaterial3: true,
            ),
            home: const spl()),
      ),
    );
  }
}
