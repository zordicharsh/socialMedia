import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_bloc.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_event.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_state.dart';
import 'package:socialmedia/screens/registration/registrationwidgets/textfromfield.dart';
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
    final ConfromPasswordController = TextEditingController();
    return Scaffold(
      // backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 70, 0, 5),
                child: SvgPicture.asset('assets/images/instalogosvg.svg',
                    width: 300),
              ),
              Text("Sign up to see photos and videos from your friends",
                  style: TextStyle(fontSize: 16, color: Colors.white60),
                  maxLines: 2,
                  textAlign: TextAlign.center),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 43, 0, 0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          BlocBuilder<RegistrationBloc, RegistrationStaste>(
                            builder: (context, state) {
                              if (state is RegistrationValidationErrorState) {
                                return CustomTextFromField(
                                  GetController: UserNameController,
                                  GetHintText: "Enter your username",
                                  GetIcon: Icons.person,
                                  Error: state.DynmaicError,
                                );
                              } else if (state
                                  is RegistrationValidationSuccessState) {
                                return CustomTextFromField(
                                  Error: "",
                                    GetController: UserNameController,
                                    GetHintText: "Enter your username",
                                    GetIcon: Icons.person);
                              } else {
                                return CustomTextFromField(
                                  Error: "",
                                    GetController: UserNameController,
                                    GetHintText: "Enter your username",
                                    GetIcon: Icons.person);
                              }
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          BlocBuilder<RegistrationBloc, RegistrationStaste>(
                            builder: (context, state) {
                              return CustomTextFromField(
                                Error: "",
                                  GetController: EmailController,
                                  GetHintText: "Enter your email",
                                  GetIcon: Icons.email);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          BlocBuilder<RegistrationBloc, RegistrationStaste>(
                            builder: (context, state) {
                              return CustomTextFromField(
                                Error: "",
                                  GetController: PasswordController,
                                  GetHintText: "Create your password",
                                  GetIcon: Icons.password);
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          BlocBuilder<RegistrationBloc, RegistrationStaste>(
                            builder: (context, state) {
                              return CustomTextFromField(
                                Error: "",
                                  GetController: ConfromPasswordController,
                                  GetHintText: "Confrom your password",
                                  GetIcon: Icons.password);
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          log("Sign Up Functionality",
                              name: "81 line in Registration.dart");
                          BlocProvider.of<RegistrationBloc>(context).add(
                              ClickOnSignUpButton(
                                  Username: UserNameController.text,
                                  Email: EmailController.text,
                                  Password: PasswordController.text,
                                  ConfromPassword:
                                      ConfromPasswordController.text));
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
                    style: TextStyle(color: Colors.white54, fontSize: 15),
                  ),
                  color: Colors.grey,
                  thickness: 0.6,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(fontSize: 14, color: Colors.white60),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    onTap: () {},
                    child: Text(
                      "Sign in",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
