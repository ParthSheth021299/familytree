import 'package:family_tree/adminpanel/app/app_bloc_provider.dart';
import 'package:family_tree/adminpanel/dashboard/presentation/screens/admin_home_screen.dart';
import 'package:family_tree/adminpanel/dependencies/dependencies.dart';
import 'package:family_tree/adminpanel/guestuserdashboard/presentation/screens/guest_user_dash_board.dart';
import 'package:family_tree/adminpanel/splash/presentation/screens/splash_screen.dart';
import 'package:family_tree/adminpanel/utils/theme.dart';
import 'package:family_tree/firebase_options.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:family_tree/providers/local_provider.dart';
import 'package:family_tree/service/notification_handler_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Dependencies.initDependencies();
  // await FlutterLocalNotificationsPlugin().initialize(
  //   InitializationSettings(
  //     android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  //   ),
  // );

  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
  runApp(const AppEntry());
}

class AppEntry extends StatelessWidget {
  const AppEntry({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LocaleProvider>(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return AppBlocProvider(
      builder: (BuildContext context) {
        // NotificationHandler.initialize(context);
        return MaterialApp(
          locale: localeProvider.locale, // default locale
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: AppTheme.orangeTheme,

          // home: GuestUserDashBoard(),
          home: SplashScreen(),
        );
      },
    );
  }
}
