import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/jobs/presentation/screens/jobs_screen.dart';
import '../../features/jobs/presentation/screens/job_detail_screen.dart';
import '../../features/applications/presentation/screens/applications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../widgets/responsive_navigation_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Splash Screen
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    
    // Login Screen
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    
    // Main App Shell (Dashboard, Jobs, Applications, Profile)
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return ResponsiveNavigationShell(state: state, child: child);
      },
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/jobs',
          builder: (context, state) => const JobsScreen(),
        ),
        GoRoute(
          path: '/applications',
          builder: (context, state) => const ApplicationsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
    
    // Job Detail Screen (Separate full page view)
    GoRoute(
      path: '/jobs/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return JobDetailScreen(jobId: id);
      },
    ),
  ],
);
