import 'package:chat_app/infrastructure/inputs/inputs.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterFormState> {
  RegisterCubit() : super(const RegisterFormState());

  void register() {
    print(state.userName);
    print(state.password);
    print(state.email);
    emit(
      state.copyWith(
        formStatus: FormStatus.validating,
        userName: UserName.dirty(state.userName.value),
        email: Email.dirty(state.email.value),
        password: Password.dirty(state.password.value),
        isValid: Formz.validate([ 
          state.userName, 
          state.password,
          state.email,
        ])
      )
    );
    print('Form cubit submit $state');
  }

  void userNameChanged(String value) {
    final userName = UserName.dirty(value);
    emit(
      state.copyWith(
        userName: userName,
        isValid: Formz.validate([ userName, state.password, state.email,]) // llamara la validacion 
      )
    );
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([ email, state.userName, state.password ]) // llamara la validacion 
      )
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(  
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.userName, state.email,   ]) // llamara la validacion 
      )
    );      
  }

}
