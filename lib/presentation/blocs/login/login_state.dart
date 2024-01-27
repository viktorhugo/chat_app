part of 'login_cubit.dart';

enum FormStatus { invalid, valid, validating, posting }

class LoginFormState extends Equatable {
  
  final FormStatus formStatus;
  final Email email;
  final Password password;
  final bool isValid;

  const LoginFormState({
    this.formStatus = FormStatus.invalid, 
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
  });

  LoginFormState copyWith({
    FormStatus? formStatus,
    UserName? userName,
    Email? email,
    Password? password,
    bool? isValid,
  }) => LoginFormState(
    formStatus : formStatus?? this.formStatus,
    email : email ?? this.email,
    password : password ?? this.password,
    isValid : isValid ?? this.isValid,
  );

  @override
  List<Object> get props => [
    formStatus,
    email,
    password,
    isValid
  ];
}
