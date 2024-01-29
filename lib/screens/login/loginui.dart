import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialmedia/screens/login/loginbloc/login_bloc.dart';
import 'package:socialmedia/screens/login/loginbloc/login_event.dart';
import 'package:socialmedia/screens/login/loginbloc/login_state.dart';
import 'package:socialmedia/screens/new.dart';
import 'package:text_divider/text_divider.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({Key? key}) : super(key: key);
  @override
  _LoginUiState createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  final loginKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    var obscured = true;
    return Scaffold(
      body: Form(
        key: loginKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Padding(padding: EdgeInsets.only(top: 120)),
                Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'assets/images/instaLOGO.svg',
                    width: 300,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter Email or Username";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.person),
                    labelText: "Enter your username",
                    labelStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.white70,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors.white60,
                      ),
                    ),
                    errorStyle: const TextStyle(
                      color:
                          Colors.red, // Customize the color of the error text
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors
                            .red, // Customize the color of the error border
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide: const BorderSide(
                        width: 2,
                        color: Colors
                            .red, // Customize the color of the focused error border
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter Password";
                        }
                        return null;
                      },
                      controller: passwordController,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              if (state is VisibilityFalseState) {
                                obscured = true;
                                return const Icon(Icons.visibility);
                              } else {
                                obscured = false;
                                return const Icon(Icons.visibility_off);
                              }
                            },
                          ),
                          onPressed: () {
                            BlocProvider.of<LoginBloc>(context).add(
                                VisibilityButtonEvent(visibility: obscured));
                          },
                        ),
                        labelText: "Password",
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            width: 2,
                            color: Colors.white70,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            color: Colors.white70,
                            width: 2,
                          ),
                        ),
                        errorStyle: const TextStyle(
                          color: Colors
                              .red, // Customize the color of the error text
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            width: 2,
                            color: Colors
                                .red, // Customize the color of the error border
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                          borderSide: const BorderSide(
                            width: 2,
                            color: Colors
                                .red, // Customize the color of the focused error border
                          ),
                        ),
                      ),
                      obscureText: obscured,
                    );
                  },
                ),
                const SizedBox(height: 15),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is LoginValidationErrorState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)));
                      } else if (state is LoginSuccessState) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const neww(),
                            ));
                      }
                    },
                    child: BlocBuilder<LoginBloc, LoginState>(
                      buildWhen: (previous, current) =>
                          current is LoginLoadingSuccessState,
                      builder: (context, state) {
                        if (state is LoginLoadingSuccessState) {
                          return ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(400, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            child: Center(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(
                                        0.5), // Adjust opacity as needed
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  height: 24,
                                  width: 24,
                                  child:
                                      const CircularProgressIndicator.adaptive(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return ElevatedButton(
                            onPressed: () {
                              if (loginKey.currentState!.validate()) {
                                String email = emailController.text;
                                String password = passwordController.text;
                                BlocProvider.of<LoginBloc>(context).add(
                                    LoginValidationError(
                                        Email: email, Password: password));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(400, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9),
                              ),
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.white),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                const TextDivider(
                  text: Text(
                    "or",
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  color: Colors.grey,
                  thickness: 1,
                ),
                const SizedBox(height: 22),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.facebook, color: Colors.blue),
                    SizedBox(width: 6),
                    InkWell(
                      child: Text(
                        "Log in with Facebook",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 190),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(width: 6),
                    InkWell(
                      child: Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
