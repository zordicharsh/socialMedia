import 'package:flutter/material.dart';

class ProfileManipulationButton extends StatelessWidget {
  const ProfileManipulationButton({super.key, required this.text, required this.width, required this.height,required this.onTap,});
final String text;
final double width;
final double height;
final void Function()?onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(onPressed:onTap,
        style: ElevatedButton.styleFrom(
        foregroundColor:Colors.black12,
        splashFactory: NoSplash.splashFactory,
        padding: const EdgeInsets.all(4),
        backgroundColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)),
      ), child:Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
      ),),
    );
  }
}
