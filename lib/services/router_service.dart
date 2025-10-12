import 'package:go_router/go_router.dart';
import 'package:temani_frontend/app.dart';
import 'package:temani_frontend/features/authentication/presentation/pages/login_page.dart';
import 'package:temani_frontend/features/counseling/presentation/pages/book_consultation_page.dart';
import 'package:temani_frontend/features/counseling/presentation/pages/chat_page.dart';
import 'package:temani_frontend/features/counseling/presentation/pages/counseling_page.dart';
import 'package:temani_frontend/features/counseling/presentation/pages/payment_page.dart';
import 'package:temani_frontend/features/journal/presentation/pages/create_journal_page.dart';
import 'package:temani_frontend/features/journal/presentation/pages/journal_page.dart';
import 'package:temani_frontend/features/main/presentation/pages/home_page.dart';
import 'package:temani_frontend/features/todo/presentation/pages/create_todo_page.dart';
import 'package:temani_frontend/features/todo/presentation/pages/todo_page.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/main', builder: (context, state) => const MainScaffold()),
    GoRoute(
      path: '/book-consultation',
      builder: (context, state) => const BookConsultationPage(),
    ),
    GoRoute(path: '/payment', builder: (context, state) => const PaymentPage()),
    GoRoute(
      path: '/counseling',
      builder: (context, state) => const CounselingPage(),
    ),
    GoRoute(path: '/journal', builder: (context, state) => const JournalPage()),
    GoRoute(
      path: '/journal/create',
      builder: (context, state) => const CreateJournalPage(),
    ),
    GoRoute(path: '/todo', builder: (context, state) => const TodoPage()),
    GoRoute(
      path: '/todo/create',
      builder: (context, state) => const CreateTodoPage(),
    ),
    GoRoute(path: '/chat', builder: (context, state) => const ChatPage()),
  ],
);
