import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:socialmedia/firebase_options.dart';
import 'package:socialmedia/screens/login/loginbloc/login_bloc.dart';
import 'package:socialmedia/screens/login/loginui.dart';
import 'package:socialmedia/screens/profile/bloc/profile_bloc.dart';
import 'package:socialmedia/screens/search_user/searchbloc/search_bloc.dart';
import 'package:socialmedia/screens/user_post/bloc/userpost_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
     const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(),
          ),
          BlocProvider(
            create: (context) => UserpostBloc(),
          ),
          BlocProvider(
            create: (context) => SearchBloc(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: const ColorScheme.dark(),
            useMaterial3: true,
          ),
          home:const LoginUi(),
        ),
      ),
    );
  }
}
