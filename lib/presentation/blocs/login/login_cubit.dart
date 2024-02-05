import 'package:chat_app/infrastructure/inputs/inputs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginFormState> {
  LoginCubit() : super(const LoginFormState());

  bool submitLogin() {
    print(state.password);
    print(state.email);
    emit(
      state.copyWith(
        formStatus: FormStatus.validating,
        email: Email.dirty(state.email.value),
        password: Password.dirty(state.password.value),
        isValid: Formz.validate([ 
          state.password,
          state.email,
        ])
      )
    );
    print('Form cubit submit Success full!  =====  $state');
    return true;
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([ email, state.password ]) // llamara la validacion 
      )
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(  
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.email,   ]) // llamara la validacion 
      )
    );      
  }

}
