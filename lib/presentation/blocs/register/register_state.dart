part of 'register_cubit.dart';

enum FormStatus { invalid, valid, validating, posting }

class RegisterFormState extends Equatable {
  
  final FormStatus formStatus;
  final UserName userName;
  final Email email;
  final Password password;
  final bool isValid;

  const RegisterFormState({
    this.formStatus = FormStatus.invalid, 
    this.userName = const UserName.pure(), 
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
  });

  RegisterFormState copyWith({
    FormStatus? formStatus,
    UserName? userName,
    Email? email,
    Password? password,
    bool? isValid,
  }) => RegisterFormState(
    formStatus : formStatus?? this.formStatus,
    userName : userName ?? this.userName,
    email : email ?? this.email,
    password : password ?? this.password,
    isValid : isValid ?? this.isValid,
  );

  @override
  List<Object> get props => [
    formStatus,
    userName,
    email,
    password,
    isValid
  ];
}
