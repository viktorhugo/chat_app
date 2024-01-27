import 'package:formz/formz.dart';

// Define input validation errors
enum UserNameError { empty, length }

// Extend FormzInput and provide the input type and error type.
class UserName extends FormzInput<String, UserNameError> {
  // Call super.pure to represent an unmodified form input.
  const UserName.pure() : super.pure('');

  // Call super.dirty to represent a modified form input.
  const UserName.dirty(String value) : super.dirty(value);

  String? get errorMessage {
    if (isValid || isPure) return null;
    if (displayError == UserNameError.empty ) return 'The field is required';
    if (displayError == UserNameError.length ) return 'Minimum 6 characters';
    return null;
  }

  // Override validator to handle validating a given input value.
  @override
  UserNameError? validator(String value) {
    if ( value.isEmpty || value.trim().isEmpty ) return UserNameError.empty;
    if (value.length < 6) return UserNameError.length;
    return null;
  }
}