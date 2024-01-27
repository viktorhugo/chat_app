import 'package:flutter/material.dart';

class CustomLoginLogo extends StatelessWidget {
  const CustomLoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        width: double.infinity,
        child: const Column(
          children: [
            Image(image: AssetImage('assets/logo.png'), fit: BoxFit.contain, height: 220, )
          ],
        ),
      ),
    );
  }
}