import 'package:go_router/go_router.dart';
import 'package:temanmu/app.dart';
import 'package:temanmu/features/authentication/presentation/pages/login_page.dart';
import 'package:temanmu/features/counseling/presentation/pages/book_consultation_page.dart';
import 'package:temanmu/features/counseling/presentation/pages/create_schedule_page.dart';
import 'package:temanmu/features/counseling/presentation/pages/chat_page.dart'
    as counseling_chat;
import 'package:temanmu/features/counseling/presentation/pages/chat_history_page.dart'
    as counseling_chat_history;
import 'package:temanmu/features/counseling/presentation/pages/counseling_page.dart';
import 'package:temanmu/features/counseling/presentation/pages/payment_page.dart';
import 'package:temanmu/features/journal/presentation/pages/create_journal_page.dart';
import 'package:temanmu/features/journal/presentation/pages/journal_page.dart';
import 'package:temanmu/features/todo/presentation/pages/create_todo_page.dart';
import 'package:temanmu/features/todo/presentation/pages/todo_page.dart';
import 'package:temanmu/features/relationship/presentation/pages/relationship_page.dart';

GoRouter router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/main', builder: (context, state) => const MainScaffold()),
    GoRoute(
      path: '/book-consultation',
      builder: (context, state) => const BookConsultationPage(),
    ),
    GoRoute(
      path: '/create-schedule',
      builder: (context, state) => const CreateSchedulePage(),
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
    GoRoute(
      path: '/relationship',
      builder: (context, state) => const RelationshipPage(),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final sessionId = state.uri.queryParameters['sessionId'] ?? '';
        final receiverId = state.uri.queryParameters['receiverId'] ?? '';
        final counselorName = state.uri.queryParameters['counselorName'] ?? '';
        final scheduleId = state.uri.queryParameters['scheduleId'];
        return counseling_chat.ChatPage(
          sessionId: sessionId,
          receiverUsername: receiverId, // This is now actually receiverId
          counselorName: counselorName,
          scheduleId: scheduleId,
        );
      },
    ),
    GoRoute(
      path: '/chat-history',
      builder: (context, state) {
        final sessionId = state.uri.queryParameters['sessionId'] ?? '';
        final receiverId = state.uri.queryParameters['receiverId'] ?? '';
        final counselorName = state.uri.queryParameters['counselorName'] ?? '';
        return counseling_chat_history.ChatHistoryPage(
          sessionId: sessionId,
          receiverUsername: receiverId,
          counselorName: counselorName,
        );
      },
    ),
  ],
);
