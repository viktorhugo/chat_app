import 'package:chat_app/helpers/handler_alerts.dart';
import 'package:chat_app/presentation/blocs/register/register_cubit.dart';
import 'package:chat_app/presentation/widgets/widgets.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/web_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';


class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: BlocProvider(
        create: (context) => RegisterCubit(),
        child: const _LoginView()
      ),
    );
  }
}

class _LoginView extends StatelessWidget {
  const _LoginView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height *0.9,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,// ESPARCE TODOS LOS ELEMENTOS EN EL ESPACIO DE LA PANTALLA
              children: [
                
                CustomLoginLogo(),
                
                _RegisterForm(),
                
                CustomLoginLabel(route: 'login'),
                
                Text(
                  'Terms and conditions',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                    fontWeight: FontWeight.w300
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _RegisterForm extends StatelessWidget {
  
  const _RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final registerCubit = context.watch<RegisterCubit>(); // cuando el state cambia se renderiza el build
    final email = registerCubit.state.email;
    final userName = registerCubit.state.userName;
    final password = registerCubit.state.password;
    final validate = registerCubit.state.isValid;
    final authService = Provider.of<AuthService>(context, listen: true);
    final socketService = Provider.of<WebSocketService>(context);
    var logger = Logger();

    return Form(
      child: Column(
        children: [

          CustomTextFormField(
            label: 'User name',
            icon:Icon(Icons.perm_identity_sharp, size: 25, color: colors.primary,),
            onChanged: (value) => registerCubit.userNameChanged(value),
            errorMessage: userName.errorMessage,
          ),
          
          const SizedBox(height: 20,),

          CustomTextFormField(
            label: 'Email',
            icon:Icon(Icons.email_outlined, size: 25, color: colors.primary,),
            onChanged: (value) => registerCubit.emailChanged(value),
            errorMessage: email.errorMessage,
          ),
          
          const SizedBox(height: 20,),

          CustomTextFormField(
            label: 'Password',
            icon:Icon(Icons.key_outlined, size: 25, color: colors.primary,),
            obscureText: true,
            onChanged: (value) => registerCubit.passwordChanged(value),
            errorMessage: password.errorMessage,
          ),
          
          const SizedBox(height: 20,),
          
          SizedBox(
            width: 200,
            height: 55,
            child: FilledButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(colors.primary)
              ),
              onPressed: (!validate && !authService.authenticating) ? null :() async {
                // when all fields are valid
                FocusScope.of(context).unfocus();
                if (!validate) return;

                registerCubit.register();

                final res = await authService.register(registerCubit.state.userName.value, registerCubit.state.email.value, registerCubit.state.password.value);
                logger.d('Response : $res');
                if (res['state']) {
                  socketService.startWSSConnection();
                  context.go('/users');
                  return showAlert(
                    context: context, 
                    title: 'Well done!', 
                    subtitle: 'Your registration was completed successfully.', 
                    typeShowAlert: TypeShowAlert.success
                  );
                } else {
                  return showAlert(
                    context: context, 
                    title: 'Warning!', 
                    subtitle: res['message'], 
                    typeShowAlert: TypeShowAlert.warning
                  );
                }
              },
              icon: const Icon(Icons.add_moderator_outlined, color: Colors.green, size: 32), 
              label: const Text('Register', style: TextStyle(color: Colors.white, fontSize: 18),)
            ),
          ),
        ],
      ),
    );
  }
}