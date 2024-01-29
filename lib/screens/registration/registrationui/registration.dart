import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socialmedia/screens/login/loginui.dart';

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
      } else {
        if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          return 'please enter valid username';
        }
      }
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

    return BlocProvider(
  create: (context) => RegistrationBloc(),
  child: Scaffold(
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
                const Text("Sign up to see photos and videos from your friends",
                    style: const TextStyle(fontSize: 16, color: Colors.white60),
                    maxLines: 2,
                    textAlign: TextAlign.center),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 43, 0, 0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomTextFromField(
                          validator: _validateUserName,
                          GetController: UserNameController,
                          GetHintText: "Enter your username",
                          GetIcon: Icons.person,
                        ),
                        const SizedBox(height: 10),
                        CustomTextFromField(
                          validator: _validateEmail,
                          GetController: EmailController,
                          GetHintText: "Enter your email",
                          GetIcon: Icons.email,
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<RegistrationBloc, RegistrationStates>(
                          builder: (context, state) {
                            print(state.toString());
                            if (state is obsecureFalse) {
                              return Column(
                                children: [
                                  CustomTextFormFieldError(
                                      validator: _validatePassword,
                                      LightIcon: Icons.visibility_off,
                                      Obsecure: state.Obsecure,
                                      GetController: PasswordController,
                                      GetHintText: "Create your password",
                                      GetIcon: Icons.password),
                                  const SizedBox(height: 10),
                                  CustomTextFormFieldError(
                                      validator: _validateConfirmPassword,
                                      LightIcon: Icons.visibility_off,
                                      Obsecure: state.Obsecure,
                                      GetController: ConfromPasswordController,
                                      GetHintText: "Conform your password",
                                      GetIcon: Icons.password),
                                ],
                              );
                            } else if (state is obsecureTrue) {
                              return Column(
                                children: [
                                  CustomTextFormFieldError(
                                      validator: _validatePassword,
                                      LightIcon: Icons.visibility,
                                      Obsecure: state.Obsecure,
                                      GetController: PasswordController,
                                      GetHintText: "Create your password",
                                      GetIcon: Icons.password),
                                  const SizedBox(height: 10),
                                  CustomTextFormFieldError(
                                      validator: _validateConfirmPassword,
                                      LightIcon: Icons.visibility,
                                      Obsecure: state.Obsecure,
                                      GetController: ConfromPasswordController,
                                      GetHintText: "Confirm your password",
                                      GetIcon: Icons.password)
                                ],
                              );
                            } else {
                              return Column(
                                children: [
                                  CustomTextFormFieldError(
                                      validator: _validatePassword,
                                      LightIcon: Icons.visibility_off,
                                      Obsecure: true,
                                      GetController: PasswordController,
                                      GetHintText: "Create your password",
                                      GetIcon: Icons.password),
                                  const SizedBox(height: 10),
                                  CustomTextFormFieldError(
                                      validator: _validateConfirmPassword,
                                      LightIcon: Icons.visibility_off,
                                      Obsecure: true,
                                      GetController: ConfromPasswordController,
                                      GetHintText: "Confirm your password",
                                      GetIcon: Icons.password)
                                ],
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        BlocListener<RegistrationBloc, RegistrationStates>(
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
                                  builder: (context) => const LoginUi(),
                                ),
                              );
                            }
                          },
                          child:
                              BlocBuilder<RegistrationBloc, RegistrationStates>(
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
                                              ConfirmPassword:
                                                  PasswordController.text
                                                      .toString()));
                                    }
                                    log("Sign Up Functionality",
                                        name: "81 line in Registration.dart");
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 24),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    height: 40,
                                    width: 346,
                                    child: Center(
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 5, sigmaY: 5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(
                                                0.5), // Adjust opacity as needed
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          height: 24,
                                          width: 24,
                                          child: const CircularProgressIndicator
                                              .adaptive(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                      ),
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
                                              ConfirmPassword:
                                                  PasswordController.text
                                                      .toString()));
                                    }
                                    log("Sign Up Functionality",
                                        name: "81 line in Registration.dart");
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 24),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    height: 40,
                                    width: 346,
                                    child: const Center(
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 115, 0, 0),
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
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 14, color: Colors.white60),
                    ),
                    const SizedBox(width: 5),
                    InkWell(
                      onTap: () {},
                      child: const Text(
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
    ),
);
  }
}
