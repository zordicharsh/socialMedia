import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final _registrationkey = GlobalKey<FormState>();
    final UserNameController = TextEditingController();
    final EmailController = TextEditingController();
    final PasswordController = TextEditingController();
    final BioController = TextEditingController();
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _registrationkey,
          child: Column(
            children: [
              SizedBox(
                height: 110,
              ),
              SvgPicture.asset('assets/images/instalogosvg.svg',width: 300),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 315,
                        height: 55,
                        child: TextFormField(

                          controller: UserNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username can't be empty";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person,color: Colors.white60),
                              labelText: "Enter your username",labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white60
                          ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7))),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(height: 55,
                        width: 315,
                        child: TextFormField(
                          controller: EmailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Email can't be empty";
                            } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                .hasMatch(value)) {
                              return "enter correct format";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email,color: Colors.white60),
                              labelText: "Enter your email",labelStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.white60
                          ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7))),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(height: 55,
                        width: 315,
                        child: TextFormField(
                          controller: PasswordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Password can't be empty";
                            } else if (value.length < 8) {
                              return "Enter password lenght 8";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.password,color: Colors.white60),
                              labelText: "Create your password",labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white60
                          ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7))),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Container(height: 55,
                        width: 315,
                        child: TextFormField(
                          controller: BioController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return null;
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.info,color: Colors.white60),
                              labelText: "Create your bio",labelStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white60
                          ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(7))),
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_registrationkey.currentState!.validate()) {
                            log("message");
                          }
                          log("Sign Up Functionality",
                              name: "81 line in Registration.dart");
                        },
                        child: Container(
                          decoration: (BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5))),
                          height: 40,
                          width: 290,
                          child: Center(
                              child: Text(
                            "Sign up",
                              style: TextStyle(
                                  color: Colors.white, letterSpacing: .1, fontSize: 17
                              ),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 2,
              ),
              TextButton(onPressed: (){}, child: Text("Already have an account",style: TextStyle(
                color: Colors.blue
              ),))
            ],
          ),
        ),
      ),
    );
  }
}
