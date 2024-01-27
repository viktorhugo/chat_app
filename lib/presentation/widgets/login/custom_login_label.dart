import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomLoginLabel extends StatelessWidget {

  final String route;

  const CustomLoginLabel({
    super.key, 
    required this.route
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            route == 'register' ? 'You do not have an account ?' : 'You already have an account ?',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => context.pushReplacement('/$route'),
            child: Text(
              route == 'register' ? 'Create one now!' : 'Log in with your account',
              style: TextStyle(
                color: Colors.blue[600],
                fontSize: 18,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}