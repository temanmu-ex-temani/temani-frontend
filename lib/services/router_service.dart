import 'package:go_router/go_router.dart';
import 'package:temani_frontend/app.dart';
import 'package:temani_frontend/features/authentication/presentation/pages/login_page.dart';
import 'package:temani_frontend/features/counseling/presentation/pages/chat_page.dart';
import 'package:temani_frontend/features/main/presentation/pages/home_page.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/main', builder: (context, state) => const MainScaffold()),
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/chat',
      builder:
          (context, state) => const ChatPage(
            sessionId: "123",
            receiverUsername: "daffa",
            counselorName: "nibras",
          ),
    ),
  ],
);
