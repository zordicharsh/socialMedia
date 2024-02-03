import 'package:flutter/material.dart';
import 'package:socialmedia/screens/splashscreen.dart';
class spl extends StatefulWidget {
  const spl({super.key});
  @override
  State<spl> createState() => _splState();
}
splservice s=splservice();
class _splState extends State<spl> {
  @override
  void initState(){
    super.initState();
    s.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 250,
            width: 250,
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}