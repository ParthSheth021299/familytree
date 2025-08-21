import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_routes.dart';
import 'app_screens.dart';
import 'router_refresh_listenable.dart';

final initialLocation = AppRoutes.splashRoute.fullPath;
final appNavigatorKey = GlobalKey<NavigatorState>();
final kAppRouter = createAppRouter();

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splashRoute.fullPath,
    debugLogDiagnostics: true,
    navigatorKey: appNavigatorKey,
    redirect: _handleRedirect,
    errorBuilder: (context, state) => AppScreens.fromGoRouterState(state),
    refreshListenable: RouterRefreshListenable.instance,
    routes: [
      //Splash Route
      GoRoute(
        path: AppRoutes.splashRoute.fullPath,
        name: AppRoutes.splashRoute.name,
        builder: (context, state) => AppScreens.fromGoRouterState(
          state,
          appRoutes: AppRoutes.splashRoute,
        ),
      ),

      //Guest DashBoard
      GoRoute(
        path: AppRoutes.guestDashboard.fullPath,
        name: AppRoutes.guestDashboard.name,
        builder: (context, state) => AppScreens.fromGoRouterState(
          state,
          appRoutes: AppRoutes.guestDashboard,
        ),
      ),

      //Admin Routes
      //Admin Dashboard
      GoRoute(
        path: AppRoutes.adminDashboardRoute.fullPath,
        name: AppRoutes.adminDashboardRoute.name,
        builder: (context, state) => AppScreens.fromGoRouterState(
          state,
          appRoutes: AppRoutes.adminDashboardRoute,
        ),
      ),
      //Admin Create Event
      GoRoute(
        path: AppRoutes.createEvent.fullPath,
        name: AppRoutes.createEvent.name,
        builder: (context, state) => AppScreens.fromGoRouterState(
          state,
          appRoutes: AppRoutes.createEvent,
        ),
      ),
      //Admin Create Moment
      GoRoute(
        path: AppRoutes.createMemories.fullPath,
        name: AppRoutes.createMemories.name,
        builder: (context, state) => AppScreens.fromGoRouterState(
          state,
          appRoutes: AppRoutes.createMemories,
        ),
      ),
      //Admin Create Temp ID
      GoRoute(
        path: AppRoutes.createTempId.fullPath,
        name: AppRoutes.createTempId.name,
        builder: (context, state) => AppScreens.fromGoRouterState(
          state,
          appRoutes: AppRoutes.createTempId,
        ),
      ),

      //Common Routes

      //Memories
      GoRoute(
        path: AppRoutes.memories.fullPath,
        name: AppRoutes.memories.name,
        builder: (context, state) =>
            AppScreens.fromGoRouterState(state, appRoutes: AppRoutes.memories),
      ),
      // tree view
      GoRoute(
        path: AppRoutes.treeView.fullPath,
        name: AppRoutes.treeView.name,
        builder: (context, state) =>
            AppScreens.fromGoRouterState(state, appRoutes: AppRoutes.treeView),
      ),
      //Events
      GoRoute(
        path: AppRoutes.events.fullPath,
        name: AppRoutes.events.name,
        builder: (context, state) =>
            AppScreens.fromGoRouterState(state, appRoutes: AppRoutes.events),
      ),
      //Setting
      GoRoute(
        path: AppRoutes.setting.fullPath,
        name: AppRoutes.setting.name,
        builder: (context, state) =>
            AppScreens.fromGoRouterState(state, appRoutes: AppRoutes.setting),
      ),
      //Language
      GoRoute(
        path: AppRoutes.language.fullPath,
        name: AppRoutes.language.name,
        builder: (context, state) =>
            AppScreens.fromGoRouterState(state, appRoutes: AppRoutes.language),
      ),
      //Login
      GoRoute(
        path: AppRoutes.login.fullPath,
        name: AppRoutes.login.name,
        builder: (context, state) =>
            AppScreens.fromGoRouterState(state, appRoutes: AppRoutes.login),
      ),
    ],
  );
}

FutureOr<String?> _handleRedirect(
  BuildContext context,
  GoRouterState state,
) async {
  final prefs = await SharedPreferences.getInstance();
  final isAdminLoggedIn = prefs.getBool('isAdminLoggedIn') ?? false;

  // Use matchedLocation
  final location = state.matchedLocation;

  // Admin-only routes
  final adminRoutes = [
    AppRoutes.adminDashboardRoute.fullPath,
    AppRoutes.createEvent.fullPath,
    AppRoutes.createMemories.fullPath,
    AppRoutes.createTempId.fullPath,
  ];

  // Guest-only routes
  final guestRoutes = [AppRoutes.guestDashboard.fullPath];

  // Common routes for both
  final commonRoutes = [
    AppRoutes.memories.fullPath,
    AppRoutes.treeView.fullPath,
    AppRoutes.events.fullPath,
    AppRoutes.setting.fullPath,
    AppRoutes.language.fullPath,
  ];

  // Login route
  final loginRoute = AppRoutes.login.fullPath;

  // Redirect logic
  if (isAdminLoggedIn) {
    // Admin trying to access guest/login routes
    if (guestRoutes.contains(location) || location == loginRoute) {
      return AppRoutes.adminDashboardRoute.fullPath;
    }
    // Admin allowed on admin + common routes
    if (adminRoutes.contains(location) || commonRoutes.contains(location)) {
      return null;
    }
    return AppRoutes.adminDashboardRoute.fullPath; // fallback
  } else {
    // Guest or not logged in
    if (adminRoutes.contains(location)) {
      return loginRoute; // prevent access to admin
    }
    if (guestRoutes.contains(location) ||
        commonRoutes.contains(location) ||
        location == loginRoute) {
      return null; // allowed
    }
    return AppRoutes.guestDashboard.fullPath; // fallback
  }
}
