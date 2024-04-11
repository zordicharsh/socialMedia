import 'package:flutter/material.dart';

import '../service/splashscreen(auth).dart';

class spl extends StatefulWidget {
  const spl({super.key});
  @override
  State<spl> createState() => _splState();
}

splservice s = splservice();
class _splState extends State<spl> {
  @override
  void initState() {
    super.initState();
    s.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(
      padding: const EdgeInsets.only(top:22.0),
      child: Image.asset('assets/images/spgif.gif',height:146,width:140,fit:BoxFit.cover),
    ));
  }
}