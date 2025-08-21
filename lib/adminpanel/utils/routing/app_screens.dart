import 'package:family_tree/adminpanel/auth/screens/login_screen.dart';
import 'package:family_tree/adminpanel/auth/screens/temp_id_screen.dart';
import 'package:family_tree/adminpanel/create_event/screens/create_event.dart';
import 'package:family_tree/adminpanel/create_event/screens/events_screen.dart';
import 'package:family_tree/adminpanel/dashboard/presentation/screens/admin_home_screen.dart';
import 'package:family_tree/adminpanel/guestuserdashboard/presentation/screens/guest_user_dash_board.dart';
import 'package:family_tree/adminpanel/language/presentation/screens/language_screen.dart';
import 'package:family_tree/adminpanel/member/presentation/screens/members.dart';
import 'package:family_tree/adminpanel/member/presentation/screens/tree_view.dart';
import 'package:family_tree/adminpanel/moments/presentation/screens/moments_list_screen.dart';
import 'package:family_tree/adminpanel/moments/presentation/screens/moments_screen.dart';
import 'package:family_tree/adminpanel/setting/presentation/screens/setting_screen.dart';
import 'package:family_tree/adminpanel/splash/presentation/screens/splash_screen.dart';
import 'package:family_tree/adminpanel/viewlogs/presentation/screens/view_log_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

class AppScreens extends StatelessWidget {
  final Widget screen;
  final AppRoutes? appRoute;
  const AppScreens({super.key, required this.screen, this.appRoute});

  factory AppScreens.fromGoRouterState(
    GoRouterState gorouterState, {
    AppRoutes? appRoutes,
  }) {
    switch (appRoutes) {
      case AppRoutes.adminDashboardRoute:
        return AppScreens(appRoute: appRoutes, screen: const AdminHomeScreen());
      case AppRoutes.createEvent:
        return AppScreens(screen: EventCreateScreen());
      case AppRoutes.guestDashboard:
        return AppScreens(screen: GuestUserDashBoard());
      case null:
      case AppRoutes.splashRoute:
        return AppScreens(appRoute: appRoutes, screen: SplashScreen());
      case AppRoutes.createTempId:
        return AppScreens(appRoute: appRoutes, screen: TempIdScreen());
      case AppRoutes.viewLogs:
        return AppScreens(appRoute: appRoutes, screen: ViewLogScreen());
      case AppRoutes.treeView:
        return AppScreens(appRoute: appRoutes, screen: TreeViewScreen());
      case AppRoutes.members:
        return AppScreens(appRoute: appRoutes, screen: Members());
      case AppRoutes.createMemories:
        return AppScreens(appRoute: appRoutes, screen: MomentsScreen());
      case AppRoutes.memories:
        return AppScreens(appRoute: appRoutes, screen: MomentsListScreen());
      case AppRoutes.events:
        return AppScreens(appRoute: appRoutes, screen: EventsScreen());
      case AppRoutes.setting:
        return AppScreens(appRoute: appRoutes, screen: SettingScreen());
      case AppRoutes.language:
        return AppScreens(appRoute: appRoutes, screen: LanguageGridScreen());
      case AppRoutes.login:
        return AppScreens(appRoute: appRoutes, screen: LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Title(color: Colors.white, child: screen);
  }
}
