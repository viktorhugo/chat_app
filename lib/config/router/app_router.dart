import 'package:chat_app/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/loading',
  routes: [
    // home
    GoRoute(
      path: '/users',
      builder: (context, state) => const UsersScreen()
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen()
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen()
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen()
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) => const LoadingScreen()
    ),
    // GoRoute(
    //   path: '/alert',
    //   builder: (context, state) => const AlertScreen()
    // ),
  ]
);