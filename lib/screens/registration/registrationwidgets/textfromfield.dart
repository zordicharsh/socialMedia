import 'package:flutter/material.dart';
class CustomTextFromField extends StatelessWidget {

  var GetController = TextEditingController();
  String GetHintText ;
  var GetIcon ;
  String Error;
   CustomTextFromField({required this.GetController,required this.GetHintText,required this.GetIcon , required this.Error});

  @override
  Widget build(BuildContext context) {

    if(Error.isNotEmpty){
      return TextField(
        controller: GetController,
        decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 0.3,
                ),
                borderRadius: BorderRadius.circular(7)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(7)),
            prefixIcon: Icon(GetIcon,
                color: Colors.white60, size: 20),
            suffixIcon: Tooltip(
              message: Error.toString(),
              child: Icon(Icons.info,
                  color: Colors.red, size: 10),
            ),
            labelText: GetHintText.toString(),
            labelStyle: TextStyle(
                fontSize: 13, color: Colors.white60),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 0.2,
                ),
                borderRadius: BorderRadius.circular(7))),
      );
    }else{
      return TextField(
        controller: GetController,
        decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 0.3,
                ),
                borderRadius: BorderRadius.circular(7)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(7)),
            prefixIcon: Icon(GetIcon,
                color: Colors.white60, size: 20),
            labelText: GetHintText.toString(),
            labelStyle: TextStyle(
                fontSize: 13, color: Colors.white60),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 0.2,
                ),
                borderRadius: BorderRadius.circular(7))),
      );
    }


  }
}
