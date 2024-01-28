import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socialmedia/screens/Loginpage.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_bloc.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_event.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_state.dart';
import 'package:text_divider/text_divider.dart';
import '../registrationwidgets/textfromfield.dart';

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
    final formkeyreg = GlobalKey<FormState>();

    String? _validateUserName(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a username';
      }
      return null;
    }

    String? _validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter an email';
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return 'Please enter a valid email';
      }
      return null;
    }

    String? _validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a password';
      }
      return null;
    }

    String? _validateConfirmPassword(String? value) {
      if (value != PasswordController.text || value!.isEmpty) {
        return 'Passwords do not match';
      }
      return null;
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: formkeyreg,
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
                            CustomTextFromField(
                              validator: _validateUserName,
                              GetController: UserNameController,
                              GetHintText: "Enter your username",
                              GetIcon: Icons.person,
                            ),
                            SizedBox(height: 10),
                            CustomTextFromField(
                              validator: _validateEmail,
                              GetController: EmailController,
                              GetHintText: "Enter your email",
                              GetIcon: Icons.email,
                            ),
                            SizedBox(height: 10),
                            BlocBuilder<RegistrationBloc, RegistrationStaste>(
                              builder: (context, state) {
                                print(state.toString());
                                if (state is obsecureTrue) {
                                  return Column(
                                    children: [
                                      CustomTextFormFieldError(
                                          validator: _validatePassword,
                                          LightIcon: Icons.flashlight_on,
                                          Obsecure: state.Obsecure,
                                          GetController: PasswordController,
                                          GetHintText: "Create your password",
                                          GetIcon: Icons.password),
                                      SizedBox(height: 10),
                                      CustomTextFormFieldError(
                                          validator: _validateConfirmPassword,
                                          LightIcon: Icons.flashlight_on,
                                          Obsecure: state.Obsecure,
                                          GetController:
                                              ConfromPasswordController,
                                          GetHintText: "Conform your password",
                                          GetIcon: Icons.password),
                                    ],
                                  );
                                }
                                else if (state is obsecureFalse) {
                                  return Column(
                                    children: [
                                      CustomTextFormFieldError(
                                          validator: _validatePassword,
                                          LightIcon: Icons.flashlight_off,
                                          Obsecure: state.Obsecure,
                                          GetController: PasswordController,
                                          GetHintText: "Create your password",
                                          GetIcon: Icons.password),
                                      SizedBox(height: 10),
                                      CustomTextFormFieldError(
                                          validator: _validateConfirmPassword,
                                          LightIcon: Icons.flashlight_off,
                                          Obsecure: state.Obsecure,
                                          GetController:
                                              ConfromPasswordController,
                                          GetHintText: "Conform your password",
                                          GetIcon: Icons.password)
                                    ],
                                  );
                                }
                                else {
                                  return Column(
                                    children: [
                                      CustomTextFormFieldError(
                                          validator: _validatePassword,
                                          LightIcon: Icons.flashlight_on,
                                          Obsecure: false,
                                          GetController: PasswordController,
                                          GetHintText: "Create your password",
                                          GetIcon: Icons.password),
                                      SizedBox(height: 10),
                                      CustomTextFormFieldError(
                                          validator: _validateConfirmPassword,
                                          LightIcon: Icons.flashlight_on,
                                          Obsecure: false,
                                          GetController:
                                              ConfromPasswordController,
                                          GetHintText: "Conform your password",
                                          GetIcon: Icons.password)
                                    ],
                                  );
                                }
                              },
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        BlocListener<RegistrationBloc, RegistrationStaste>(
                          listener: (context, state) {
                            if (state is FirebaseAuthErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          state.AuthErrorMessage.toString())));
                            } else if (state is FirebaseAuthSuccessState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(state.AuthSuccessMessage
                                          .toString())));
                            } else if (state is NavigateToLoginScreen) {
                              // Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage(),));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ));
                            }
                          },
                          child:
                              BlocBuilder<RegistrationBloc, RegistrationStaste>(
                            buildWhen: (previous, current) =>
                                current is AuthSuccessLoading,
                            builder: (context, state) {
                              print(state.toString());
                              if (state is AuthSuccessLoading) {
                                return GestureDetector(
                                  onTap: () {
                                    if (formkeyreg.currentState!.validate()) {
                                      BlocProvider.of<RegistrationBloc>(context)
                                          .add(ClickOnSignUpButton(
                                              Username: UserNameController.text
                                                  .toString(),
                                              Email: EmailController.text
                                                  .toString(),
                                              Password: PasswordController.text
                                                  .toString(),
                                              ConfromPassword:
                                                  PasswordController.text
                                                      .toString()));
                                    }
                                    log("Sign Up Functionality",
                                        name: "81 line in Registration.dart");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 24),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    height: 40,
                                    width: 346,
                                    child: Center(
                                      child:
                                          CircularProgressIndicator.adaptive(),
                                    ),
                                  ),
                                );
                              } else {
                                return GestureDetector(
                                  onTap: () {
                                    if (formkeyreg.currentState!.validate()) {
                                      BlocProvider.of<RegistrationBloc>(context)
                                          .add(ClickOnSignUpButton(
                                              Username: UserNameController.text
                                                  .toString(),
                                              Email: EmailController.text
                                                  .toString(),
                                              Password: PasswordController.text
                                                  .toString(),
                                              ConfromPassword:
                                                  PasswordController.text
                                                      .toString()));
                                    }
                                    log("Sign Up Functionality",
                                        name: "81 line in Registration.dart");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 24),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    height: 40,
                                    width: 346,
                                    child: Center(
                                      child: Text(
                                        "Sign up",
                                        style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: .1,
                                          fontSize: 15.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
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
                    SizedBox(width: 5),
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
      ),
    );
  }
}
