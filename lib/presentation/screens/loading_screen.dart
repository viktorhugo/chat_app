import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/web_socket_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';


class LoadingScreen extends StatelessWidget {
  
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return const Center(
            child: Text('Loagind...'),
          );
        },
      ),
    );
  }

  Future checkLoginState (BuildContext context) async {
    final AuthService authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<WebSocketService>(context);
    final checkAuth = await authService.checkToken();
    if ( !checkAuth ) return context.go('/login');
    socketService.startWSSConnection();
    return context.go('/users');
    // 

  }


}