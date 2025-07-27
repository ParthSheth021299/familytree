import 'package:family_tree/adminpanel/member/cubit/member_cubit.dart';
import 'package:family_tree/adminpanel/member/presentation/screens/tree_view.dart';
import 'package:family_tree/adminpanel/moments/presentation/screens/moments_list_screen.dart';
import 'package:family_tree/adminpanel/setting/presentation/screens/setting_screen.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:family_tree/models/family_member.dart';
import 'package:family_tree/service/guest_token_manager_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

class GuestUserDashBoard extends StatefulWidget {
  const GuestUserDashBoard({super.key});

  @override
  State<GuestUserDashBoard> createState() => _GuestUserDashBoardState();
}

class _GuestUserDashBoardState extends State<GuestUserDashBoard> {
  final GuestTokenManager _guestTokenManager = GuestTokenManager();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MemberCubit>(context).subscribeToMembers();
    _registerFCMToken();
  }

  void _registerFCMToken() {
    _guestTokenManager.registerGuestToken(); // no root needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildCustomDrawer(context),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.dashboard,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.orangePrimary,
        elevation: 4,
      ),
      body: StreamBuilder<List<FamilyMember>>(
        stream: context.read<MemberCubit>().membersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noMembersFound),
            );
          }

          final members = snapshot.data!;
          final maleCount = members
              .where((e) => e.gender.toLowerCase() == 'male')
              .length;
          final femaleCount = members
              .where((e) => e.gender.toLowerCase() == 'female')
              .length;
          final totalMemberCount = members.length;

          final today = DateTime.now();
          final dateFormat = DateFormat("dd-MM-yyyy");

          final todayBirthdays = members.where((e) {
            try {
              final dob = dateFormat.parse(e.dob.toString());
              return dob.day == today.day && dob.month == today.month;
            } catch (_) {
              return false;
            }
          }).toList();

          final upcomingBirthdays = members.where((e) {
            try {
              final dob = dateFormat.parse(e.dob.toString());
              return dob.month == today.month && dob.day > today.day;
            } catch (_) {
              return false;
            }
          }).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionCard(
                  title: "👥 ${AppLocalizations.of(context)!.memberSummary}",
                  child: Column(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.totalMembers} $totalMemberCount",
                        style: _subTextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 180,
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Colors.blueAccent,
                                value: maleCount.toDouble(),
                                title:
                                    '${((maleCount / (maleCount + femaleCount)) * 100).toStringAsFixed(1)}%',
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PieChartSectionData(
                                color: Colors.pinkAccent,
                                value: femaleCount.toDouble(),
                                title:
                                    '${((femaleCount / (maleCount + femaleCount)) * 100).toStringAsFixed(1)}%',
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                            sectionsSpace: 4,
                            centerSpaceRadius: 40,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _indicator(
                            color: Colors.blueAccent,
                            label: AppLocalizations.of(context)!.genderMale,
                            count: maleCount,
                          ),
                          const SizedBox(width: 24),
                          _indicator(
                            color: Colors.pinkAccent,
                            label: AppLocalizations.of(context)!.female,
                            count: femaleCount,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  title: "🎂 ${AppLocalizations.of(context)!.birthdaysToday}",
                  child: todayBirthdays.isEmpty
                      ? Text(
                          AppLocalizations.of(context)!.no_birthdays_today,
                          style: _subTextStyle(),
                        )
                      : Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: todayBirthdays.map((e) {
                            return _birthdayCard(e);
                          }).toList(),
                        ),
                ),
                const SizedBox(height: 16),
                _sectionCard(
                  title:
                      "📅 ${AppLocalizations.of(context)!.upcoming_birthdays}",
                  child: upcomingBirthdays.isEmpty
                      ? Text(
                          AppLocalizations.of(context)!.no_upcoming_birthdays,
                          style: _subTextStyle(),
                        )
                      : Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: upcomingBirthdays.map((e) {
                            return _birthdayCard(e);
                          }).toList(),
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomDrawer(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
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
                          AppLocalizations.of(context)!.guest_user,
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
              const SizedBox(height: 12),

              // Menu Items
              _buildDrawerItem(
                context,
                icon: Icons.account_tree_outlined,
                label: AppLocalizations.of(context)!.treeView,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TreeViewScreen()),
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.photo_library_outlined,
                label: AppLocalizations.of(context)!.memories,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MomentsListScreen()),
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.settings_outlined,
                label: AppLocalizations.of(context)!.settings,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SettingScreen(isComingFromAdmin: false),
                  ),
                ),
              ),

              // Spacer to push version info to the bottom
              Expanded(child: Container()),

              const Divider(thickness: 1, indent: 20, endIndent: 20),

              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'App version 1.0.0',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: ListTile(
          leading: Icon(icon, color: AppColors.orangePrimary),
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

  Widget _sectionCard({
    required String title,
    IconData? icon,
    required Widget child,
    Color? backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title.isNotEmpty)
              Row(
                children: [
                  if (icon != null) Icon(icon, color: AppColors.orangePrimary),
                  if (icon != null) const SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            if (title.isNotEmpty) const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _indicator({
    required Color color,
    required String label,
    required int count,
  }) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text('$label ($count)', style: _subTextStyle()),
      ],
    );
  }

  Widget _birthdayCard(FamilyMember member) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipOval(
          child: Image.asset(
            'assets/images/avatar.jpg',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 6),
        Text(member.name, style: _subTextStyle(fontWeight: FontWeight.bold)),
        Text(
          member.dob,
          style: _subTextStyle(size: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  TextStyle _subTextStyle({
    double size = 14,
    Color? color,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.poppins(
      fontSize: size,
      color: color ?? Colors.black87,
      fontWeight: fontWeight,
    );
  }
}
