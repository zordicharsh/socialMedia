import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/screens/login/loginui.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String name;
  final String username;
  final String email;
  final String password;

  const EmailVerificationScreen({
    Key? key,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen>
    with WidgetsBindingObserver {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    timer = Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  Future<void> checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) {
      UserModel regModel = UserModel(
        Name: widget.name,
        Uid: FirebaseAuth.instance.currentUser!.uid.toString(),
        Username: widget.username.trim(),
        Email: widget.email.trim(),
        Password: widget.password.trim(),
        Following: [],
        Follower: [],
        datetime: Timestamp.now(),
        Profileurl: "",
        Bio: "",
        Acctype: "public",
        Followrequest: [],
        Followrequestnotification: [],
        TotalPosts: 0,
      );
      await FirebaseFirestore.instance
          .collection("RegisteredUsers")
          .doc(FirebaseAuth.instance.currentUser!.uid.toString())
          .set(regModel.toMap());
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginUi()));
      timer?.cancel();
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    if (isEmailVerified == false) {
      log("Email verification not completed. Deleting user...");
      FirebaseAuth.instance.currentUser!.delete();
    }
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state.toString());
      // if (!isEmailVerified) {
      //   log("Email verification not completed. Deleting user...");
      //   FirebaseAuth.instance.currentUser!.delete();
      // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Check your Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'We have sent you an email for verification.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              Lottie.asset(
                'assets/images/live.json',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      try {
                        FirebaseAuth.instance.currentUser!.sendEmailVerification();
                      } catch (e) {
                        debugPrint('$e');
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 34,
                          width: 56,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              gradient: const SweepGradient(colors: [
                                Colors.lightBlueAccent,
                                Colors.blue,
                                Colors.blueGrey,
                              ])),

                        ),
                        Container(
                          height: 32,
                          width: 54,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.grey[900]),
                        ),
                        Text("Resend")
                      ],
                    ),
                  ),
                  SizedBox(width: 16,),
                  GestureDetector(
                    onTap: (){
                      try {
                        FirebaseAuth.instance.currentUser!.delete();
                        Navigator.pop(context);
                      } catch (e) {
                        debugPrint('$e');
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 34,
                          width: 56,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              gradient: const SweepGradient(colors: [
                                Colors.blue,
                                Colors.lightBlueAccent,
                                Colors.blueGrey,
                                Colors.lightBlueAccent,
                              ])),

                        ),
                        Container(
                          height: 32,
                          width: 54,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.grey[900]),
                        ),
                        Text("Cancel")
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
