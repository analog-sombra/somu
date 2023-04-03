import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:somu/routers/route_names.dart';
import 'package:somu/views/dashborad.dart';
import 'package:somu/views/error.dart';

import '../components/bottom_nav.dart';
import '../views/history.dart';
import '../views/home/books.dart';
import '../views/home/daily.dart';
import '../views/home/notes.dart';
import '../views/home/study.dart';
import '../views/home/years.dart';
import '../views/profile.dart';

final GoRouter router = GoRouter(
  initialLocation: "/daily",
  errorBuilder: (context, state) => const ErrorPage(),
  redirect: (context, state) {
    return null;
  },
  routes: [
    ShellRoute(
      routes: [
        GoRoute(
          name: RouteNames.daily,
          path: "/daily",
          builder: (context, state) => const DailyPage(),
        ),
        GoRoute(
          name: RouteNames.years,
          path: "/years",
          builder: (context, state) => const YearsPage(),
        ),
        GoRoute(
          name: RouteNames.notes,
          path: "/notes",
          builder: (context, state) => const NotesPage(),
        ),
        GoRoute(
          name: RouteNames.study,
          path: "/study",
          builder: (context, state) => const StudyPage(),
        ),
        GoRoute(
          name: RouteNames.books,
          path: "/books",
          builder: (context, state) => const BookPage(),
        ),
      ],
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return BoottomNavBar(
          childElement: child,
        );
      },
    ),
    GoRoute(
      name: RouteNames.history,
      path: "/history",
      pageBuilder: (context, state) => CustomTransitionPage(
          transitionDuration: const Duration(seconds: 1),
          key: state.pageKey,
          fullscreenDialog: true,
          child: const HistoryPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );
            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          }),
    ),
    GoRoute(
      name: RouteNames.profile,
      path: "/profile",
      builder: (context, state) => const ProfilePage(),
      routes: [
        GoRoute(
          name: RouteNames.dashboard,
          path: "dashboard",
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const Dashboard(),
            fullscreenDialog: true,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
                child: child,
              );
            },
          ),
        ),
      ],
    ),
  ],
);
