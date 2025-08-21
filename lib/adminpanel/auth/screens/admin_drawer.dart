import 'package:family_tree/adminpanel/auth/screens/temp_id_screen.dart';
import 'package:family_tree/adminpanel/create_event/screens/create_event.dart';
import 'package:family_tree/adminpanel/guestuserdashboard/presentation/screens/guest_user_dash_board.dart';
import 'package:family_tree/adminpanel/member/cubit/member_cubit.dart';
import 'package:family_tree/adminpanel/member/presentation/screens/members.dart';
import 'package:family_tree/adminpanel/member/presentation/screens/tree_view.dart';
import 'package:family_tree/adminpanel/moments/presentation/screens/moments_screen.dart';
import 'package:family_tree/adminpanel/setting/presentation/screens/setting_screen.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/adminpanel/viewlogs/cubit/viewlogs_cubit.dart';
import 'package:family_tree/adminpanel/viewlogs/presentation/screens/view_log_screen.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatelessWidget {
  final void Function(String route) onItemSelected;

  const AppDrawer({super.key, required this.onItemSelected});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Drawer Header
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.orangeDark, AppColors.orangePrimary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/avatar.jpg'),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.admin,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      AppLocalizations.of(context)!.welcome,
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Content with pinned bottom version
          Expanded(
            child: Stack(
              children: [
                // Scrollable menu items
                ListView(
                  padding: EdgeInsets.only(
                    bottom: 60,
                  ), // Avoid overlap with version
                  children: [
                    _buildDrawerItem(
                      context,
                      imagePath: 'assets/icons/temporary.png',
                      label: AppLocalizations.of(context)!.createTemporaryID,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => TempIdScreen()),
                        );
                      },
                    ),
                    // _buildDrawerItem(
                    //   context,
                    //   imagePath: 'assets/icons/log.png',
                    //   label: AppLocalizations.of(context)!.viewLogs,
                    //   onTap: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //         builder: (_) => BlocProvider(
                    //           create: (_) => ViewlogsCubit(),
                    //           child: const ViewLogScreen(),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    _buildDrawerItem(
                      context,
                      imagePath: 'assets/icons/diagram.png',
                      label: AppLocalizations.of(context)!.treeView,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => MemberCubit(),
                              child: const TreeViewScreen(),
                            ),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      imagePath: 'assets/icons/group-chat.png',
                      label: AppLocalizations.of(context)!.members,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const Members()),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      imagePath: 'assets/icons/photos.png',
                      label: AppLocalizations.of(context)!.memories,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MomentsScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      imagePath: 'assets/icons/event.png',
                      label: AppLocalizations.of(context)!.eventTitle,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const EventCreateScreen(),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      imagePath: 'assets/icons/setting.png',
                      label: AppLocalizations.of(context)!.settings,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                SettingScreen(isComingFromAdmin: true),
                          ),
                        );
                      },
                    ),
                    _buildDrawerItem(
                      context,
                      imagePath: 'assets/icons/logout.png',
                      label: AppLocalizations.of(context)!.logout,
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool('isAdminLoggedIn', false);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const GuestUserDashBoard(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                // Version pinned to bottom
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  Text(
                    'App version 1.0.0',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: ListTile(
          leading: Image.asset(imagePath),
          title: Text(
            label,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
