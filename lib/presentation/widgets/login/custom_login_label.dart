import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomLoginLabel extends StatelessWidget {
  const CustomLoginLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text(
            'You do not have an account ?',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 15,
              fontWeight: FontWeight.w300
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () => context.push('/register'),
            child: Text(
              'Create one now!',
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