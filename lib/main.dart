
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/firebase_options.dart';
import 'package:socialmedia/screens/SplashScreeenUI.dart';
import 'package:socialmedia/screens/login/loginbloc/login_bloc.dart';
import 'package:socialmedia/screens/profile/bloc/profile_bloc.dart';
import 'package:socialmedia/screens/navigation_handler/bloc/navigation_bloc.dart';


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
      builder: (context, child) =>
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => GlobalBloc(),
              ),
              BlocProvider(create: (context) => NavigationBloc(),),
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
              home: const spl()
            ),
          ),
    );
  }
}