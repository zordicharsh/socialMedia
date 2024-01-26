import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:text_divider/text_divider.dart';
class LoginUi extends StatefulWidget {
  const LoginUi({super.key});
  @override
  State<LoginUi> createState() => _LoginUiState();
}
class _LoginUiState extends State<LoginUi> {
  var obscured;
  @override
  void initState() {
    super.initState();
    obscured = true;
  }
  final login_key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final TextEditingController email_controller = TextEditingController();
    final TextEditingController password_controll = TextEditingController();
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 120)),
              Align(
                  alignment: Alignment.topCenter,
                  child: SvgPicture.asset(
                    'assets/harsh.svg',
                    width: 300,
                  )),
              const SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                    suffixIcon: Icon(Icons.person, color: Colors.white60),
                    labelText: "Enter your username",
                    labelStyle: TextStyle(fontSize: 14, color: Colors.white60),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide:
                            const BorderSide(width: 2, color: Colors.white70)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.white60,
                        ))),
              ),
              const SizedBox(height: 18),
              TextFormField(
                obscureText: obscured,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscured ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white60,
                    ),
                    onPressed: () {
                      setState(() {
                        obscured = !obscured;
                      });
                    },
                  ),
                  labelText: "Password",
                  labelStyle:
                      const TextStyle(fontSize: 14, color: Colors.white60),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide:
                          const BorderSide(width: 2, color: Colors.white70)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(9),
                      borderSide:
                          const BorderSide(color: Colors.white70, width: 2)),
                ),
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
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(400, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                  backgroundColor: Colors.blue,
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
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
                  )
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
    );
  }
}
