import 'package:go_router/go_router.dart';
import 'package:temani_frontend/features/main/presentation/pages/home_page.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(path: '/', builder: (context, state) => const HomePage())
  ],
);
