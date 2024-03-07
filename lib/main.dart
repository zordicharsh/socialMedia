import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/screens/EditProfile/ui/editprofile_bloc.dart';
import 'package:socialmedia/screens/SplashScreeenUI.dart';
import 'package:socialmedia/screens/login/loginbloc/login_bloc.dart';
import 'package:socialmedia/screens/navigation_handler/bloc/navigation_bloc.dart';
import 'package:socialmedia/screens/profile/bloc/comment_bloc/comment_bloc.dart';
import 'package:socialmedia/screens/profile/bloc/heart_animation_bloc/heart_bloc.dart';
import 'package:socialmedia/screens/profile/bloc/profile_bloc.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_bloc.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_bloc.dart';

import 'firebase_options.dart';
import 'global_Bloc/global_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
            create: (context) => HeartBloc(),
          ),
          BlocProvider(
            create: (context) => CommentBloc(),
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
          )
        ],
        child: MaterialApp(
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
