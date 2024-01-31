import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socialmedia/common_widgets/transition_widgets/right_to_left/custom_page_route_right_to_left.dart';
import 'package:socialmedia/screens/login/loginbloc/login_bloc.dart';
import 'package:socialmedia/screens/login/loginbloc/login_event.dart';
import 'package:socialmedia/screens/login/loginbloc/login_state.dart';
import 'package:socialmedia/screens/profile/ui/profile.dart';
import 'package:socialmedia/screens/registration/registrationui/registration.dart';
import 'package:text_divider/text_divider.dart';
class LoginUi extends StatefulWidget {
  const LoginUi({Key? key}) : super(key: key);
  @override
  LoginUiState createState() => LoginUiState();
}
class LoginUiState extends State<LoginUi> {
  final loginKey2 = GlobalKey<FormState>();
  late OverlayEntry circularLoadingBar;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var obscured = true;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 90),
            child: Form(
              key: loginKey2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //   Padding(padding: EdgeInsets.only(top: 116.sp)),
                    SizedBox(
                        width: deviceWidth,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("English"),
                            SizedBox(
                              width: 6,
                            ),
                            Icon(
                              Icons.arrow_drop_down_circle_outlined,
                              size: 16,
                            )
                          ],
                        )),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/instaLOGO.svg',
                          height: deviceWidth * .24,
                        ),
                        SizedBox(
                          height: deviceWidth * .05,
                        ),
                        SizedBox(
                          width: deviceWidth * .90,
                          height: deviceWidth * .14,
                          child: TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter Email or Username";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.person),
                              labelText: "Enter your Email/Username",
                              labelStyle: TextStyle(
                                fontSize: 12.sp,
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
                          ),
                        ),
                        SizedBox(height: deviceWidth * .04),
                        SizedBox(
                          width: deviceWidth * .90,
                          height: deviceWidth * .14,
                          child: BlocBuilder<LoginBloc, LoginState>(
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
                                          return const Icon(
                                              Icons.visibility_off);
                                        }
                                      },
                                    ),
                                    onPressed: () {
                                      BlocProvider.of<LoginBloc>(context).add(
                                          VisibilityButtonEvent(
                                              visibility: obscured));
                                    },
                                  ),
                                  labelText: "Password",
                                  labelStyle: TextStyle(
                                    fontSize: 12.sp,
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
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          width: deviceWidth * .90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                child: const Text(
                                  "Forgot password?",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: deviceWidth * .05,
                        ),
                        Center(
                          child: BlocListener<LoginBloc, LoginState>(
                            listener: (context, state) {
                              if (state is LoginValidationErrorState) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(state.message)));
                              } else if (state is LoginSuccessState) {
                                Navigator.pushReplacement(context,MaterialPageRoute(builder: (BuildContext context) => const ProfilePage(),));
                              }
                            },
                            child: BlocBuilder<LoginBloc, LoginState>(
                              /*   buildWhen: (previous, current) =>
                                  current is LoginLoadingSuccessState.00,*/
                              builder: (context, state) {
                                if (state is LoginSuccessState) {
                                  circularLoadingBar.remove();
                                  return const SizedBox();
                                } else if (state is LoginValidationErrorState) {
                                  circularLoadingBar.remove();
                                  return ElevatedButton(
                                    onPressed: () {
                                      if (loginKey2.currentState!.validate()) {
                                        String email = emailController.text;
                                        String password =
                                            passwordController.text;
                                        BlocProvider.of<LoginBloc>(context).add(
                                            LoginValidationError(
                                                Email: email,
                                                Password: password));
                                        circularLoadingBar =
                                            _createCircularLoadingBar();
                                        Overlay.of(context)
                                            .insert(circularLoadingBar);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(400.sp, 40),
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
                                } else {
                                  return ElevatedButton(
                                    onPressed: () {
                                      if (loginKey2.currentState!.validate()) {
                                        String email = emailController.text;
                                        String password =
                                            passwordController.text;
                                        BlocProvider.of<LoginBloc>(context).add(
                                            LoginValidationError(
                                                Email: email,
                                                Password: password));
                                        circularLoadingBar = _createCircularLoadingBar();Overlay.of(context).insert(circularLoadingBar);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(328.sp, 40),
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
                        SizedBox(
                          height: deviceWidth * .05,
                        ),
                        const TextDivider(
                          text: Text(
                            "or",
                            style:
                                TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                          color: Colors.grey,
                          thickness: 1,
                        ),
                        SizedBox(
                          height: deviceWidth * .05,
                        ),
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
                      ],
                    ),
                    //  SizedBox(height: deviceWidth*.04,),
                    SizedBox(
                      width: deviceWidth,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account?",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: deviceWidth * .036),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () => Navigator.push(
                                context,
                                CustomPageRouteRightToLeft(
                                    child: const SignUp())),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: deviceWidth * .036,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createCircularLoadingBar() {
    return OverlayEntry(
      builder: (context) => Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: const CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }
}