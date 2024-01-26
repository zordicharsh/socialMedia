import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/firebase_options.dart';

import 'package:socialmedia/screens/login/loginui.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: LoginUi(),
    );
  }
}
class ee extends StatelessWidget {
  const ee({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


