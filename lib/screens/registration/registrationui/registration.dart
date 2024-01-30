import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:socialmedia/common_widgets/transition_widgets/left_to_right/custom_page_route_left_to_right.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_bloc.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_event.dart';
import 'package:socialmedia/screens/registration/registrationbloc/registration_state.dart';

import '../../login/loginui.dart';
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
    final ConfirmPasswordController = TextEditingController();
    final formkeyreg = GlobalKey<FormState>();
    late OverlayEntry circularLoadingbar;

    String? validateUserName(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a username';
      } else {
        return null;
      }
    }

    String? validateEmail(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter an email';
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return 'Please enter a valid email';
      }
      return null;
    }

    String? validatePassword(String? value) {
      if (value == null || value.isEmpty) {
        return 'Please enter a password';
      }
      return null;
    }

    String? validateConfirmPassword(String? value) {
      if (value != PasswordController.text || value!.isEmpty) {
        return 'Passwords do not match';
      }
      return null;
    }

    double deviceWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => RegistrationBloc(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 90),
              child: Form(
                key: formkeyreg,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
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
                      ),
                      SizedBox(
                        //  color: Colors.red,
                        width: deviceWidth,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/images/instaLOGO.svg',
                              height: deviceWidth * .24,
                            ),
                            SizedBox(height: deviceWidth * .02),
                            Text(
                                "Sign up to see photos and videos from your friends",
                                style: TextStyle(
                                    fontSize: deviceWidth * .036,
                                    color: Colors.white60),
                                maxLines: 2,
                                textAlign: TextAlign.center),
                            SizedBox(height: deviceWidth * .1),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: deviceWidth * .90,
                                  height: deviceWidth * .14,
                                  child: CustomTextFromField(
                                    validator: validateUserName,
                                    GetController: UserNameController,
                                    GetHintText: "Enter your username",
                                    GetIcon: Icons.person,
                                  ),
                                ),
                                SizedBox(height: deviceWidth * .05),
                                SizedBox(
                                  width: deviceWidth * .90,
                                  height: deviceWidth * .14,
                                  child: CustomTextFromField(
                                    validator: validateEmail,
                                    GetController: EmailController,
                                    GetHintText: "Enter your email",
                                    GetIcon: Icons.email,
                                  ),
                                ),
                                SizedBox(height: deviceWidth * .05),
                                BlocBuilder<RegistrationBloc,
                                    RegistrationStates>(
                                  builder: (context, state) {
                                    if (state is obsecureFalse) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: deviceWidth * .90,
                                            height: deviceWidth * .14,
                                            child: CustomTextFormFieldError(
                                                validator: validatePassword,
                                                LightIcon: Icons.visibility_off,
                                                Obscure: state.Obscure,
                                                GetController:
                                                    PasswordController,
                                                GetHintText:
                                                    "Create your password",
                                                GetIcon: Icons.password),
                                          ),
                                          SizedBox(height: deviceWidth * .05),
                                          SizedBox(
                                            width: deviceWidth * .90,
                                            height: deviceWidth * .14,
                                            child: CustomTextFormFieldError(
                                                validator:
                                                    validateConfirmPassword,
                                                LightIcon: Icons.visibility_off,
                                                Obscure: state.Obscure,
                                                GetController:
                                                    ConfirmPasswordController,
                                                GetHintText:
                                                    "Confirm your password",
                                                GetIcon: Icons.password),
                                          ),
                                        ],
                                      );
                                    } else if (state is obsecureTrue) {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: deviceWidth * .90,
                                            height: deviceWidth * .14,
                                            child: CustomTextFormFieldError(
                                                validator: validatePassword,
                                                LightIcon: Icons.visibility,
                                                Obscure: state.Obsecure,
                                                GetController:
                                                    PasswordController,
                                                GetHintText:
                                                    "Create your password",
                                                GetIcon: Icons.password),
                                          ),
                                          SizedBox(height: deviceWidth * .05),
                                          SizedBox(
                                            width: deviceWidth * .90,
                                            height: deviceWidth * .14,
                                            child: CustomTextFormFieldError(
                                                validator:
                                                    validateConfirmPassword,
                                                LightIcon: Icons.visibility,
                                                Obscure: state.Obsecure,
                                                GetController:
                                                    ConfirmPasswordController,
                                                GetHintText:
                                                    "Confirm your password",
                                                GetIcon: Icons.password),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: deviceWidth * .90,
                                            height: deviceWidth * .14,
                                            child: CustomTextFormFieldError(
                                                validator: validatePassword,
                                                LightIcon: Icons.visibility_off,
                                                Obscure: true,
                                                GetController:
                                                    PasswordController,
                                                GetHintText:
                                                    "Create your password",
                                                GetIcon: Icons.password),
                                          ),
                                          SizedBox(height: deviceWidth * .05),
                                          SizedBox(
                                            width: deviceWidth * .90,
                                            height: deviceWidth * .14,
                                            child: CustomTextFormFieldError(
                                                validator:
                                                    validateConfirmPassword,
                                                LightIcon: Icons.visibility_off,
                                                Obscure: true,
                                                GetController:
                                                    ConfirmPasswordController,
                                                GetHintText:
                                                    "Confirm your password",
                                                GetIcon: Icons.password),
                                          )
                                        ],
                                      );
                                    }
                                  },
                                ),
                                SizedBox(height: deviceWidth * .1),
                              ],
                            ),
                            BlocListener<RegistrationBloc, RegistrationStates>(
                              listener: (context, state) {
                                if (state is FirebaseAuthErrorState) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(state.AuthErrorMessage
                                              .toString())));
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
                              child: BlocBuilder<RegistrationBloc,
                                  RegistrationStates>(
                                builder: (context, state) {
                                  if (state is NavigateToLoginScreen) {
                                    circularLoadingbar.remove();
                                    return const SizedBox();
                                  } else if (state is FirebaseAuthErrorState) {
                                    circularLoadingbar.remove();
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (formkeyreg.currentState!
                                                .validate()) {
                                              BlocProvider.of<RegistrationBloc>(
                                                      context)
                                                  .add(
                                                      ClickOnSignUpButton(
                                                          Username:
                                                              UserNameController
                                                                  .text
                                                                  .toString(),
                                                          Email: EmailController
                                                              .text
                                                              .toString(),
                                                          Password:
                                                              PasswordController
                                                                  .text
                                                                  .toString(),
                                                          ConfirmPassword:
                                                              PasswordController
                                                                  .text
                                                                  .toString()));
                                              circularLoadingbar =
                                                  _createCircularLoadingBar();
                                              Overlay.of(context)
                                                  .insert(circularLoadingbar);
                                            }
                                            log("Sign Up Functionality",
                                                name:
                                                    "81 line in Registration.dart");
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            height: 40,
                                            //  width: deviceWidth * .14,
                                            width: 328.sp,
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
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            if (formkeyreg.currentState!
                                                .validate()) {
                                              BlocProvider.of<RegistrationBloc>(
                                                      context)
                                                  .add(
                                                      ClickOnSignUpButton(
                                                          Username:
                                                              UserNameController
                                                                  .text
                                                                  .toString(),
                                                          Email: EmailController
                                                              .text
                                                              .toString(),
                                                          Password:
                                                              PasswordController
                                                                  .text
                                                                  .toString(),
                                                          ConfirmPassword:
                                                              PasswordController
                                                                  .text
                                                                  .toString()));
                                              circularLoadingbar =
                                                  _createCircularLoadingBar();
                                              Overlay.of(context)
                                                  .insert(circularLoadingbar);
                                            }
                                            log("Sign Up Functionality",
                                                name:
                                                    "81 line in Registration.dart");
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.blue,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            height: 40,
                                            //  width: deviceWidth * .14,
                                            width: 328.sp,
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
                                        ),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: deviceWidth,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: deviceWidth * .036),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () => Navigator.push(
                                  context,
                                  CustomPageRouteLeftToRight(
                                      child: const LoginUi())),
                              child: Text(
                                "Login",
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
