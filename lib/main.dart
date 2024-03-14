import 'package:chat_app/config/router/app_router.dart';
import 'package:chat_app/config/theme/app_theme.dart';
import 'package:chat_app/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  // await Environment.initEnvironment();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (context) => WebSocketService(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatService(),
        )
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme().getTheme(),
        routerConfig: appRouter,
      ),
    );
  }
}
