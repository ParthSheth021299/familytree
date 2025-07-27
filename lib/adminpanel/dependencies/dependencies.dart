import 'package:family_tree/adminpanel/auth/data/auth_repository.dart';
import 'package:family_tree/adminpanel/member/data/member_repository.dart';
import 'package:family_tree/adminpanel/moments/data/moments_repository.dart';
import 'package:family_tree/adminpanel/viewlogs/data/view_logs_repository.dart';
import 'package:get_it/get_it.dart';

class Dependencies {
  static final _getIt = GetIt.instance;

  static void initDependencies() {
    registerAppServices();
  }

  static void registerAppServices() {
    _getIt.registerSingleton<AuthRepository>(AuthRepository());
    _getIt.registerSingleton<FamilyRepository>(FamilyRepository());
    _getIt.registerSingleton<MomentsRepository>(MomentsRepository());
    _getIt.registerSingleton<ViewLogsRepository>(ViewLogsRepository());
  }
}

AuthRepository get authRepository => Dependencies._getIt.get();
FamilyRepository get memberRepository => Dependencies._getIt.get();
MomentsRepository get momentRepository => Dependencies._getIt.get();
ViewLogsRepository get viewLogsRepository => Dependencies._getIt.get();
