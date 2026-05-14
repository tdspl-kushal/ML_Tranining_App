import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/app_sidebar.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/extensions.dart';
import '../modules/dashboard/screens/profile_dashboard_screen.dart';
import '../modules/leaderboard/bloc/leaderboard_bloc.dart';
import '../modules/leaderboard/screens/leaderboard_screen.dart';
import 'route_names.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.dashboard,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return _ShellScaffold(
            currentRoute: state.uri.toString(),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: RouteNames.dashboard,
            pageBuilder: (context, state) {
              return const NoTransitionPage(
                child: ProfileDashboardScreen(),
              );
            },
          ),
          GoRoute(
            path: RouteNames.leaderboard,
            pageBuilder: (context, state) {
              final profileId = state.uri.queryParameters['profileId'] ?? '';
              final profileName = state.uri.queryParameters['profileName'] ?? '';
              return NoTransitionPage(
                child: BlocProvider(
                  create: (_) => GetIt.instance<LeaderboardBloc>(),
                  child: LeaderboardScreen(
                    profileId: profileId,
                    profileName: Uri.decodeComponent(profileName),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ],
  );
}

class _ShellScaffold extends StatefulWidget {
  final String currentRoute;
  final Widget child;

  const _ShellScaffold({required this.currentRoute, required this.child});

  @override
  State<_ShellScaffold> createState() => _ShellScaffoldState();
}

class _ShellScaffoldState extends State<_ShellScaffold> {
  bool _isSidebarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;
    final isTablet = context.isTablet;

    // Determine which sidebar route to highlight
    String sidebarRoute = '/';
    if (widget.currentRoute.startsWith('/leaderboard')) {
      sidebarRoute = '/training';
    } else if (widget.currentRoute == '/') {
      sidebarRoute = '/';
    }

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            AppSidebar(
              selectedRoute: sidebarRoute,
              onNavigate: (route) => context.go(route),
              isCollapsed: _isSidebarCollapsed,
              onToggle: () => setState(() => _isSidebarCollapsed = !_isSidebarCollapsed),
            ),
            Expanded(child: widget.child),
          ],
        ),
      );
    }

    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            // Rail sidebar (icons only)
            NavigationRail(
              selectedIndex: _routeToIndex(sidebarRoute),
              backgroundColor: AppColors.white,
              indicatorColor: AppColors.primaryLight,
              onDestinationSelected: (index) {
                final routes = ['/', '/settings'];
                if (index < routes.length) context.go(routes[index]);
              },
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.grid_view_rounded),
                  label: Text('Dashboard'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  label: Text('Settings'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: widget.child),
          ],
        ),
      );
    }

    // Mobile
    return Scaffold(
      drawer: Drawer(
        child: AppSidebar(
          selectedRoute: sidebarRoute,
          onNavigate: (route) {
            Navigator.of(context).pop();
            context.go(route);
          },
          isCollapsed: false, // Mobile drawer is always expanded
          onToggle: () => Navigator.of(context).pop(),
        ),
      ),
      body: widget.child,
    );
  }

  int _routeToIndex(String route) {
    switch (route) {
      case '/':
        return 0;
      case '/settings':
        return 1;
      default:
        return 0;
    }
  }
}
