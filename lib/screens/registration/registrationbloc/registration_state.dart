class RegistrationStaste {}

class RegistrationInitalState extends RegistrationStaste {}

class RegistrationValidationErrorState extends RegistrationStaste {
  String DynmaicError;
  RegistrationValidationErrorState({required this.DynmaicError});
}

class RegistrationValidationSuccessState extends RegistrationStaste {}
