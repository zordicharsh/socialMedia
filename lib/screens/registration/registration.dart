import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:text_divider/text_divider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final UserNameController = TextEditingController();
    final EmailController = TextEditingController();
    final PasswordController = TextEditingController();
    final BioController = TextEditingController();
    return Scaffold(
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 68, 0, 5),
                child: SvgPicture.asset('assets/images/instalogosvg.svg',
                    width: 300),
              ),
              Text("Sign up to see photos and videos from your friends",
                  style: TextStyle(fontSize: 16, color: Colors.white60),
                  maxLines: 2,
                  textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          TextFormField(
                            // style: TextStyle(
                            //   color: Colors.white
                            // ),
                            controller: UserNameController,
                            decoration: InputDecoration(
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 0.3,
                                    ),
                                    borderRadius: BorderRadius.circular(7)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(7)),
                                prefixIcon: Icon(Icons.person,
                                    color: Colors.white60, size: 22),
                                labelText: "Enter your username",
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Colors.white60),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(7))),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: EmailController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(7)),
                                prefixIcon: Icon(Icons.email,
                                    color: Colors.white60, size: 22),
                                labelText: "Enter your email",
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Colors.white60),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(7))),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: PasswordController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(7)),
                                prefixIcon: Icon(Icons.password,
                                    color: Colors.white60, size: 22),
                                labelText: "Create your password",
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Colors.white60),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(7))),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: BioController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(7)),
                                prefixIcon: Icon(Icons.info,
                                    color: Colors.white60, size: 22),
                                labelText: "Create your bio",
                                labelStyle: TextStyle(
                                    fontSize: 14, color: Colors.white60),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(7))),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          log("Sign Up Functionality",
                              name: "81 line in Registration.dart");
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 24),
                          decoration: (BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5))),
                          height: 40,
                          width: 346,
                          child: Center(
                              child: Text(
                            "Sign up",
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: .1,
                                fontSize: 15.5),
                          )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 115, 0, 0),
                child: TextDivider(
                  text: Text(
                    "or",
                    style: TextStyle(color: Colors.white54),
                  ),
                  color: Colors.grey,
                  thickness: 0.6,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account ?",
                    style: TextStyle(fontSize: 14, color: Colors.white60),
                  ),
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
