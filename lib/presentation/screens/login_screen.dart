import 'package:chat_app/presentation/blocs/login/login_cubit.dart';
import 'package:chat_app/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: BlocProvider(
        create: (context) => LoginCubit(),
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
                
                _LoginForm(),
                
                CustomLoginLabel(route: 'register'),
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


class _LoginForm extends StatelessWidget {
  
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final loginCubit = context.watch<LoginCubit>(); // cuando el state cambia se renderiza el build
    final email = loginCubit.state.email;
    final password = loginCubit.state.password;

    return Form(
      child: Column(
        children: [

          CustomTextFormField(
            label: 'Email',
            icon:Icon(Icons.email_outlined, size: 25, color: colors.primary,),
            onChanged: (value) => loginCubit.emailChanged(value),
            errorMessage: email.errorMessage,
          ),
          
          const SizedBox(height: 20,),

          CustomTextFormField(
            label: 'Password',
            icon:Icon(Icons.key_outlined, size: 25, color: colors.primary,),
            obscureText: true,
            onChanged: (value) => loginCubit.passwordChanged(value),
            errorMessage: password.errorMessage,
          ),
          
          const SizedBox(height: 20,),
          
          SizedBox(
            width: 200,
            height: 55,
            child: FilledButton.tonalIcon(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll<Color>(colors.primary)
              ),
              onPressed: () {
                // when all fields are valid
                loginCubit.login();
              }, 
              icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.green, size: 32), 
              label: const Text('Sign in', style: TextStyle(color: Colors.white, fontSize: 18),)
            ),
          ),
        ],
      ),
    );
  }
}