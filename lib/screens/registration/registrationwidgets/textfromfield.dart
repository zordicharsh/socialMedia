import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../registrationbloc/registration_bloc.dart';
import '../registrationbloc/registration_event.dart';

class CustomTextFromField extends StatelessWidget {
  var GetController = TextEditingController();
  String GetHintText;
  var GetIcon;
  final String? Function(String?)? validator;

  CustomTextFromField({
    required this.GetController,
    required this.GetHintText,
    required this.GetIcon,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: GetController,
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 0.3),
          borderRadius: BorderRadius.circular(7),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(7),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.circular(7),
        ),
        prefixIcon: Icon(GetIcon, color: Colors.white60, size: 20),
        labelText: GetHintText.toString(),
        labelStyle: const TextStyle(fontSize: 13, color: Colors.white60),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 0.2),
          borderRadius: BorderRadius.circular(7),
        ),
      ),
    );
  }
}

class CustomTextFormFieldError extends StatelessWidget {
  final String? Function(String?)? validator;
  bool Obsecure;
  var GetController = TextEditingController();
  String GetHintText;
  var LightIcon;
  var GetIcon;

  CustomTextFormFieldError({
    required this.GetController,
    required this.GetHintText,
    required this.GetIcon,
    required this.Obsecure,
    required this.LightIcon,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      obscureText: Obsecure,
      controller: GetController,
      decoration: InputDecoration(
          focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
                width: 0.3,
              ),
              borderRadius: BorderRadius.circular(7)),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(7),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.grey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(7)),
          suffixIcon: IconButton(
              onPressed: () {
                BlocProvider.of<RegistrationBloc>(context)
                    .add(ClickOnVisibilityButton(Obscure: Obsecure));
              },
              icon: Icon(
                LightIcon,
                size: 17,
              )),
          prefixIcon: Icon(GetIcon, color: Colors.white60, size: 20),
          labelText: GetHintText.toString(),
          labelStyle: const TextStyle(fontSize: 13, color: Colors.white60),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.white,
                width: 0.2,
              ),
              borderRadius: BorderRadius.circular(7))),
    );
  }
}
