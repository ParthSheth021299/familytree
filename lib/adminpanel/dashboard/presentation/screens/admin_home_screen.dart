import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/auth/screens/admin_drawer.dart';
import 'package:family_tree/adminpanel/create_event/screens/events_screen.dart';
import 'package:family_tree/adminpanel/member/cubit/member_cubit.dart';
import 'package:family_tree/adminpanel/utils/birthday_section.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/adminpanel/utils/demographics_chart.dart';
import 'package:family_tree/adminpanel/utils/quick_stats_grid.dart';
import 'package:family_tree/adminpanel/utils/welcome_header.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../models/family_member.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with TickerProviderStateMixin {
  List<FamilyMember> members = [];
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    context.read<MemberCubit>().subscribeToMembers();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    streamUpcomingEvents();
  }

  @override
  void didUpdateWidget(covariant AdminHomeScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    streamUpcomingEvents();
  }

  Stream<List<Map<String, dynamic>>> streamUpcomingEvents() {
    return FirebaseFirestore.instance
        .collection('events')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.orangePrimary,
        title: Text(
          AppLocalizations.of(context)!.adminPanel,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.orangePrimary, AppColors.orangeDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: AppDrawer(onItemSelected: (_) {}),
      body: StreamBuilder<List<FamilyMember>>(
        stream: context.read<MemberCubit>().membersStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.orangePrimary),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.loadingDashboard,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noMembersFound),
            );
          }

          final members = snapshot.data!;

          int maleCount = 0;
          int femaleCount = 0;
          int totalCount = members.length;
          int aliveCount = 0;
          int deceasedCount = 0;
          int childrenCount = 0;
          int adultsCount = 0;

          for (final member in members) {
            final gender = member.gender.toLowerCase();
            // Count the member
            // final gender = member.gender.toLowerCase();
            // if (gender == 'male') {
            //   maleCount++;
            // } else if (gender == 'female') {
            //   femaleCount++;
            // }

            // // Count the spouse if exists
            // if (member.spouse != null) {
            //   final spouseGender = member.spouse!.gender.toLowerCase();
            //   if (spouseGender == 'male') {
            //     maleCount++;
            //   } else if (spouseGender == 'female') {
            //     femaleCount++;
            //   }
            // }
            // Gender count
            if (gender == 'male') {
              maleCount++;
            } else if (gender == 'female') {
              femaleCount++;
            }
          }

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
              final nextBirthday = DateTime(today.year, dob.month, dob.day);
              final daysUntil = nextBirthday.difference(today).inDays;
              return daysUntil > 0 && daysUntil <= 30; // Next 30 days
            } catch (_) {
              return false;
            }
          }).toList();

          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.grey[50]!, Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Header
                    WelcomeHeader(),
                    const SizedBox(height: 20),
                    QuickStatsGrid(
                      total: totalCount,
                      male: maleCount,
                      female: femaleCount,
                      alive: aliveCount,
                      children: childrenCount,
                      adults: adultsCount,
                    ),
                    DemographicsChart(
                      maleCount: maleCount,
                      femaleCount: femaleCount,
                      childrenCount: childrenCount,
                      adultsCount: adultsCount,
                    ),

                    const SizedBox(height: 20),
                    BirthdaySection(
                      title:
                          "🎂${AppLocalizations.of(context)!.birthdaysToday}",
                      members: todayBirthdays,
                      emptyMessage: AppLocalizations.of(
                        context,
                      )!.no_birthdays_today,
                      isToday: true,
                    ),
                    const SizedBox(height: 20),
                    BirthdaySection(
                      title:
                          "📅 ${AppLocalizations.of(context)!.upcoming_birthdays}",
                      members: upcomingBirthdays,
                      emptyMessage: AppLocalizations.of(
                        context,
                      )!.no_upcoming_birthdays,
                      isToday: false,
                    ),

                    EventsScreen(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
// ignore_for_file: unnecessary_null_comparison

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:family_tree/adminpanel/create_event/screens/calendar_event_screen.dart';
// import 'package:family_tree/adminpanel/create_event/screens/events_screen.dart';
// import 'package:family_tree/adminpanel/member/cubit/member_cubit.dart';
// import 'package:family_tree/adminpanel/member/presentation/screens/tree_view.dart';
// import 'package:family_tree/adminpanel/moments/presentation/screens/moments_list_screen.dart';
// import 'package:family_tree/adminpanel/setting/presentation/screens/setting_screen.dart';
// import 'package:family_tree/adminpanel/utils/colors.dart';
// import 'package:family_tree/l10n/app_localizations.dart';
// import 'package:family_tree/models/family_member.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

// class GuestUserDashBoard extends StatefulWidget {
//   const GuestUserDashBoard({super.key});

//   @override
//   State<GuestUserDashBoard> createState() => _GuestUserDashBoardState();
// }

// class _GuestUserDashBoardState extends State<GuestUserDashBoard> {
//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<MemberCubit>(context).subscribeToMembers();

//     subscribe();
//     streamUpcomingEvents();
//   }

//   void subscribe() async {
//     if (!kIsWeb) {
//       OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//       OneSignal.initialize("62094d7d-71ae-45b3-9bf9-858a815c86b2");
//       OneSignal.Notifications.requestPermission(true);
//     }
//   }

//   Stream<List<Map<String, dynamic>>> streamUpcomingEvents() {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
//     final dateFromDatabase = FirebaseFirestore.instance.collection('events');

//     return FirebaseFirestore.instance
//         .collection('events')
//         // .where('date', isGreaterThanOrEqualTo: today)
//         // .where('date', isLessThanOrEqualTo: endOfMonth)
//         // .orderBy('date')
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => doc.data() as Map<String, dynamic>)
//               .toList(),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: _buildCustomDrawer(context),
//       appBar: AppBar(
//         title: Text(
//           AppLocalizations.of(context)!.dashboard,
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.orangePrimary,
//         elevation: 4,
//       ),
//       body: StreamBuilder<List<FamilyMember>>(
//         stream: context.read<MemberCubit>().membersStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text(AppLocalizations.of(context)!.noMembersFound),
//             );
//           }

//           final members = snapshot.data!;

//           int maleCount = 0;
//           int femaleCount = 0;
//           int totalCount = 0;

//           for (final member in members) {
//             final gender = member.gender.toLowerCase();

//             if (gender == 'male') {
//               maleCount++;
//             } else if (gender == 'female') {
//               femaleCount++;
//             }

//             totalCount++; // Every member is already a separate document (including spouse)
//           }

//           final today = DateTime.now();
//           final dateFormat = DateFormat("dd-MM-yyyy");

//           final todayBirthdays = members.where((e) {
//             try {
//               final dob = dateFormat.parse(e.dob.toString());
//               return dob.day == today.day && dob.month == today.month;
//             } catch (_) {
//               return false;
//             }
//           }).toList();

//           final upcomingBirthdays = members.where((e) {
//             try {
//               final dob = dateFormat.parse(e.dob.toString());
//               return dob.month == today.month && dob.day > today.day;
//             } catch (_) {
//               return false;
//             }
//           }).toList();

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _sectionCard(
//                   title: "👥 ${AppLocalizations.of(context)!.memberSummary}",
//                   child: Column(
//                     children: [
//                       Text(
//                         "${AppLocalizations.of(context)!.totalMembers} $totalCount",
//                         style: _subTextStyle(fontWeight: FontWeight.w600),
//                       ),
//                       const SizedBox(height: 12),
//                       SizedBox(
//                         height: 180,
//                         child: PieChart(
//                           PieChartData(
//                             sections: [
//                               PieChartSectionData(
//                                 color: Colors.blueAccent,
//                                 value: maleCount.toDouble(),
//                                 title:
//                                     '${((maleCount / (maleCount + femaleCount)) * 100).toStringAsFixed(1)}%',
//                                 titleStyle: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                               PieChartSectionData(
//                                 color: Colors.pinkAccent,
//                                 value: femaleCount.toDouble(),
//                                 title:
//                                     '${((femaleCount / (maleCount + femaleCount)) * 100).toStringAsFixed(1)}%',
//                                 titleStyle: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 12,
//                                 ),
//                               ),
//                             ],
//                             sectionsSpace: 4,
//                             centerSpaceRadius: 40,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _indicator(
//                             color: Colors.blueAccent,
//                             label: AppLocalizations.of(context)!.genderMale,
//                             count: maleCount,
//                           ),
//                           const SizedBox(width: 24),
//                           _indicator(
//                             color: Colors.pinkAccent,
//                             label: AppLocalizations.of(context)!.female,
//                             count: femaleCount,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 _sectionCard(
//                   title: "🎂 ${AppLocalizations.of(context)!.birthdaysToday}",
//                   child: todayBirthdays.isEmpty
//                       ? Text(
//                           AppLocalizations.of(context)!.no_birthdays_today,
//                           style: _subTextStyle(),
//                         )
//                       : Wrap(
//                           spacing: 12,
//                           runSpacing: 12,
//                           children: todayBirthdays.map((e) {
//                             return _birthdayCard(e);
//                           }).toList(),
//                         ),
//                 ),
//                 const SizedBox(height: 16),
//                 _sectionCard(
//                   title:
//                       "📅 ${AppLocalizations.of(context)!.upcoming_birthdays}",
//                   child: upcomingBirthdays.isEmpty
//                       ? Text(
//                           AppLocalizations.of(context)!.no_upcoming_birthdays,
//                           style: _subTextStyle(),
//                         )
//                       : Wrap(
//                           spacing: 12,
//                           runSpacing: 12,
//                           children: upcomingBirthdays.map((e) {
//                             return _birthdayCard(e);
//                           }).toList(),
//                         ),
//                 ),

//                 EventsScreen(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCustomDrawer(BuildContext context) {
//     return Drawer(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(16),
//           bottomRight: Radius.circular(16),
//         ),
//       ),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           return Column(
//             children: [
//               DrawerHeader(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [AppColors.orangeDark, AppColors.orangePrimary],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 30,
//                       backgroundImage: AssetImage('assets/images/avatar.jpg'),
//                     ),
//                     const SizedBox(width: 16),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           AppLocalizations.of(context)!.guest_user,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           AppLocalizations.of(context)!.welcome,
//                           style: TextStyle(color: Colors.white70, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Menu Items
//               _buildDrawerItem(
//                 context,
//                 icon: 'assets/icons/diagram.png',
//                 label: AppLocalizations.of(context)!.treeView,
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => TreeViewScreen()),
//                 ),
//               ),
//               _buildDrawerItem(
//                 context,
//                 icon: 'assets/icons/photos.png',
//                 label: AppLocalizations.of(context)!.memories,
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => MomentsListScreen(isAdmin: false),
//                   ),
//                 ),
//               ),
//               _buildDrawerItem(
//                 context,
//                 icon: 'assets/icons/event.png',
//                 label: AppLocalizations.of(context)!.eventTitle,
//                 onTap: () => Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (_) => const EventCalendarScreen(),
//                   ),
//                 ),
//               ),

//               _buildDrawerItem(
//                 context,
//                 icon: 'assets/icons/setting.png',
//                 label: AppLocalizations.of(context)!.settings,
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => SettingScreen(isComingFromAdmin: false),
//                   ),
//                 ),
//               ),

//               // Spacer to push version info to the bottom
//               Expanded(child: Container()),

//               const Divider(thickness: 1, indent: 20, endIndent: 20),

//               Padding(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Text(
//                     'App version 1.0.0',
//                     style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//     BuildContext context, {
//     required String icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(10),
//         onTap: onTap,
//         child: ListTile(
//           leading: Image.asset(icon, color: AppColors.orangePrimary),
//           title: Text(
//             label,
//             style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//           ),
//           trailing: const Icon(
//             Icons.arrow_forward_ios_rounded,
//             size: 14,
//             color: Colors.grey,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _sectionCard({
//     required String title,
//     IconData? icon,
//     required Widget child,
//     Color? backgroundColor,
//   }) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 10),
//       decoration: BoxDecoration(
//         color: backgroundColor ?? Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 6,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (title.isNotEmpty)
//               Row(
//                 children: [
//                   if (icon != null) Icon(icon, color: AppColors.orangePrimary),
//                   if (icon != null) const SizedBox(width: 8),
//                   Text(
//                     title,
//                     style: GoogleFonts.poppins(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             if (title.isNotEmpty) const SizedBox(height: 16),
//             child,
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _indicator({
//     required Color color,
//     required String label,
//     required int count,
//   }) {
//     return Row(
//       children: [
//         Container(
//           width: 14,
//           height: 14,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 6),
//         Text('$label ($count)', style: _subTextStyle()),
//       ],
//     );
//   }

//   Widget _birthdayCard(FamilyMember member) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         ClipOval(
//           child: Image.asset(
//             'assets/images/avatar.jpg',
//             width: 60,
//             height: 60,
//             fit: BoxFit.cover,
//           ),
//         ),
//         const SizedBox(height: 6),
//         Text(member.name, style: _subTextStyle(fontWeight: FontWeight.bold)),
//         Text(
//           member.dob,
//           style: _subTextStyle(size: 12, color: Colors.grey[600]),
//         ),
//       ],
//     );
//   }

//   TextStyle _subTextStyle({
//     double size = 14,
//     Color? color,
//     FontWeight fontWeight = FontWeight.normal,
//   }) {
//     return GoogleFonts.poppins(
//       fontSize: size,
//       color: color ?? Colors.black87,
//       fontWeight: fontWeight,
//     );
//   }
// }
// ignore_for_file: unnecessary_null_comparison

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:family_tree/adminpanel/create_event/screens/calendar_event_screen.dart';
// import 'package:family_tree/adminpanel/create_event/screens/events_screen.dart';
// import 'package:family_tree/adminpanel/member/cubit/member_cubit.dart';
// import 'package:family_tree/adminpanel/member/presentation/screens/tree_view.dart';
// import 'package:family_tree/adminpanel/moments/presentation/screens/moments_list_screen.dart';
// import 'package:family_tree/adminpanel/setting/presentation/screens/setting_screen.dart';
// import 'package:family_tree/adminpanel/utils/colors.dart';
// import 'package:family_tree/l10n/app_localizations.dart';
// import 'package:family_tree/models/family_member.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart';

// class AdminHomeScreen extends StatefulWidget {
//   const AdminHomeScreen({super.key});

//   @override
//   State<AdminHomeScreen> createState() => _AdminHomeScreenState();
// }

// class _AdminHomeScreenState extends State<AdminHomeScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<MemberCubit>(context).subscribeToMembers();

//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();

//     subscribe();
//     streamUpcomingEvents();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   void subscribe() async {
//     if (!kIsWeb) {
//       OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
//       OneSignal.initialize("62094d7d-71ae-45b3-9bf9-858a815c86b2");
//       OneSignal.Notifications.requestPermission(true);
//     }
//   }

//   Stream<List<Map<String, dynamic>>> streamUpcomingEvents() {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
//     final dateFromDatabase = FirebaseFirestore.instance.collection('events');

//     return FirebaseFirestore.instance
//         .collection('events')
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((doc) => doc.data() as Map<String, dynamic>)
//               .toList(),
//         );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: _buildCustomDrawer(context),
//       appBar: AppBar(
//         title: Text(
//           AppLocalizations.of(context)!.dashboard,
//           style: GoogleFonts.poppins(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: AppColors.orangePrimary,
//         elevation: 0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.orangePrimary, AppColors.orangeDark],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
//       ),
//       body: StreamBuilder<List<FamilyMember>>(
//         stream: context.read<MemberCubit>().membersStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   CircularProgressIndicator(color: AppColors.orangePrimary),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Loading Dashboard...',
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       color: Colors.grey[600],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return _buildEmptyState(context);
//           }

//           final members = snapshot.data!;

//           // Enhanced statistics calculation
//           int maleCount = 0;
//           int femaleCount = 0;
//           int aliveCount = 0;
//           int deceasedCount = 0;
//           int childrenCount = 0;
//           int adultsCount = 0;

//           for (final member in members) {
//             final gender = member.gender.toLowerCase();

//             // Gender count
//             if (gender == 'male') {
//               maleCount++;
//             } else if (gender == 'female') {
//               femaleCount++;
//             }

//             // Age calculation for age groups
//             try {
//               final dob = DateFormat("dd-MM-yyyy").parse(member.dob.toString());
//               final age = DateTime.now().difference(dob).inDays ~/ 365;
//               if (age < 18) {
//                 childrenCount++;
//               } else {
//                 adultsCount++;
//               }
//             } catch (_) {}

//             // Status count (you'll need to add isAlive field to your FamilyMember model)
//             // For now, assuming all are alive - modify based on your data structure
//             aliveCount++;
//           }

//           final totalCount = members.length;

//           final today = DateTime.now();
//           final dateFormat = DateFormat("dd-MM-yyyy");

//           final todayBirthdays = members.where((e) {
//             try {
//               final dob = dateFormat.parse(e.dob.toString());
//               return dob.day == today.day && dob.month == today.month;
//             } catch (_) {
//               return false;
//             }
//           }).toList();

//           final upcomingBirthdays = members.where((e) {
//             try {
//               final dob = dateFormat.parse(e.dob.toString());
//               final nextBirthday = DateTime(today.year, dob.month, dob.day);
//               final daysUntil = nextBirthday.difference(today).inDays;
//               return daysUntil > 0 && daysUntil <= 30; // Next 30 days
//             } catch (_) {
//               return false;
//             }
//           }).toList();

//           return FadeTransition(
//             opacity: _fadeAnimation,
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [Colors.grey[50]!, Colors.white],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Welcome Header
//                     _buildWelcomeHeader(),
//                     const SizedBox(height: 20),

//                     // Quick Stats Cards
//                     _buildQuickStatsGrid(
//                       totalCount,
//                       maleCount,
//                       femaleCount,
//                       aliveCount,
//                       childrenCount,
//                       adultsCount,
//                     ),
//                     const SizedBox(height: 24),

//                     // Enhanced Member Demographics
//                     _buildDemographicsChart(
//                       maleCount,
//                       femaleCount,
//                       childrenCount,
//                       adultsCount,
//                     ),
//                     const SizedBox(height: 24),

//                     // Today's Birthdays
//                     _buildBirthdaysSection(
//                       title:
//                           "🎂 ${AppLocalizations.of(context)!.birthdaysToday}",
//                       members: todayBirthdays,
//                       emptyMessage: AppLocalizations.of(
//                         context,
//                       )!.no_birthdays_today,
//                       isToday: true,
//                     ),
//                     const SizedBox(height: 20),

//                     // Upcoming Birthdays
//                     _buildBirthdaysSection(
//                       title:
//                           "📅 ${AppLocalizations.of(context)!.upcoming_birthdays}",
//                       members: upcomingBirthdays,
//                       emptyMessage: AppLocalizations.of(
//                         context,
//                       )!.no_upcoming_birthdays,
//                       isToday: false,
//                     ),
//                     const SizedBox(height: 24),

//                     // Events Section
//                     EventsScreen(),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildEmptyState(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.family_restroom, size: 80, color: Colors.grey[400]),
//           const SizedBox(height: 16),
//           Text(
//             AppLocalizations.of(context)!.noMembersFound,
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'Start building your family tree!',
//             style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWelcomeHeader() {
//     final hour = DateTime.now().hour;
//     String greeting = 'Good Morning';
//     if (hour >= 12 && hour < 17) {
//       greeting = 'Good Afternoon';
//     } else if (hour >= 17) {
//       greeting = 'Good Evening';
//     }

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             AppColors.orangePrimary.withOpacity(0.1),
//             Colors.orange[50]!,
//           ],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: AppColors.orangePrimary.withOpacity(0.2)),
//       ),
//       child: Row(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: AppColors.orangePrimary,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Icon(Icons.waving_hand, color: Colors.white, size: 24),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   greeting,
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 Text(
//                   'Welcome to your family dashboard',
//                   style: GoogleFonts.poppins(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuickStatsGrid(
//     int total,
//     int male,
//     int female,
//     int alive,
//     int children,
//     int adults,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Family Overview',
//           style: GoogleFonts.poppins(
//             fontSize: 20,
//             fontWeight: FontWeight.w600,
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(height: 12),
//         GridView.count(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           crossAxisCount: 2,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 12,
//           childAspectRatio: 1.5,
//           children: [
//             _buildStatCard(
//               title: 'Total Members',
//               count: total.toString(),
//               icon: Icons.group,
//               color: AppColors.orangePrimary,
//               gradient: [AppColors.orangePrimary, Colors.orange[300]!],
//             ),
//             _buildStatCard(
//               title: 'Male',
//               count: male.toString(),
//               icon: Icons.male,
//               color: Colors.blue,
//               gradient: [Colors.blue, Colors.blue[300]!],
//             ),
//             _buildStatCard(
//               title: 'Female',
//               count: female.toString(),
//               icon: Icons.female,
//               color: Colors.pink,
//               gradient: [Colors.pink, Colors.pink[300]!],
//             ),
//             _buildStatCard(
//               title: 'Children',
//               count: children.toString(),
//               icon: Icons.child_care,
//               color: Colors.green,
//               gradient: [Colors.green, Colors.green[300]!],
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard({
//     required String title,
//     required String count,
//     required IconData icon,
//     required Color color,
//     required List<Color> gradient,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: color.withOpacity(0.2)),
//         boxShadow: [
//           BoxShadow(
//             color: color.withOpacity(0.1),
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: color,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Icon(icon, color: Colors.white, size: 20),
//               ),
//               const Spacer(),
//               Text(
//                 count,
//                 style: GoogleFonts.poppins(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                   color: color,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             title,
//             style: GoogleFonts.poppins(
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey[700],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDemographicsChart(
//     int maleCount,
//     int femaleCount,
//     int childrenCount,
//     int adultsCount,
//   ) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Demographics',
//             style: GoogleFonts.poppins(
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//           ),
//           const SizedBox(height: 20),
//           SizedBox(
//             height: 200,
//             child: Row(
//               children: [
//                 // Gender Chart
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text(
//                         'Gender Distribution',
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Expanded(
//                         child: PieChart(
//                           PieChartData(
//                             sections: [
//                               PieChartSectionData(
//                                 color: Colors.blueAccent,
//                                 value: maleCount.toDouble(),
//                                 title: '$maleCount',
//                                 titleStyle: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                                 radius: 60,
//                               ),
//                               PieChartSectionData(
//                                 color: Colors.pinkAccent,
//                                 value: femaleCount.toDouble(),
//                                 title: '$femaleCount',
//                                 titleStyle: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                                 radius: 60,
//                               ),
//                             ],
//                             sectionsSpace: 2,
//                             centerSpaceRadius: 25,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 20),
//                 // Age Groups Chart
//                 Expanded(
//                   child: Column(
//                     children: [
//                       Text(
//                         'Age Groups',
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.grey[700],
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       Expanded(
//                         child: PieChart(
//                           PieChartData(
//                             sections: [
//                               PieChartSectionData(
//                                 color: Colors.green,
//                                 value: childrenCount.toDouble(),
//                                 title: '$childrenCount',
//                                 titleStyle: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                                 radius: 60,
//                               ),
//                               PieChartSectionData(
//                                 color: Colors.orange,
//                                 value: adultsCount.toDouble(),
//                                 title: '$adultsCount',
//                                 titleStyle: const TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                                 radius: 60,
//                               ),
//                             ],
//                             sectionsSpace: 2,
//                             centerSpaceRadius: 25,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           // Legends
//           Wrap(
//             spacing: 16,
//             runSpacing: 8,
//             children: [
//               _buildLegendItem(Colors.blueAccent, 'Male ($maleCount)'),
//               _buildLegendItem(Colors.pinkAccent, 'Female ($femaleCount)'),
//               _buildLegendItem(Colors.green, 'Children ($childrenCount)'),
//               _buildLegendItem(Colors.orange, 'Adults ($adultsCount)'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegendItem(Color color, String label) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 12,
//           height: 12,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 6),
//         Text(
//           label,
//           style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
//         ),
//       ],
//     );
//   }

//   Widget _buildBirthdaysSection({
//     required String title,
//     required List<FamilyMember> members,
//     required String emptyMessage,
//     required bool isToday,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 2,
//             blurRadius: 8,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(
//                 title,
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.black87,
//                 ),
//               ),
//               const Spacer(),
//               if (members.isNotEmpty)
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: isToday ? Colors.red[50] : Colors.orange[50],
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     '${members.length}',
//                     style: GoogleFonts.poppins(
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold,
//                       color: isToday ? Colors.red : Colors.orange,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           members.isEmpty
//               ? Container(
//                   padding: const EdgeInsets.all(20),
//                   child: Center(
//                     child: Column(
//                       children: [
//                         Icon(
//                           isToday ? Icons.cake_outlined : Icons.event_outlined,
//                           size: 48,
//                           color: Colors.grey[400],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           emptyMessage,
//                           style: GoogleFonts.poppins(
//                             color: Colors.grey[600],
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               : SizedBox(
//                   height: 120,
//                   child: ListView.builder(
//                     scrollDirection: Axis.horizontal,
//                     itemCount: members.length,
//                     itemBuilder: (context, index) {
//                       return _buildEnhancedBirthdayCard(
//                         members[index],
//                         isToday,
//                       );
//                     },
//                   ),
//                 ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEnhancedBirthdayCard(FamilyMember member, bool isToday) {
//     return Container(
//       width: 100,
//       margin: const EdgeInsets.only(right: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isToday
//               ? [Colors.red[50]!, Colors.red[100]!]
//               : [Colors.orange[50]!, Colors.orange[100]!],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: isToday ? Colors.red[200]! : Colors.orange[200]!,
//         ),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Stack(
//             children: [
//               CircleAvatar(
//                 radius: 25,
//                 backgroundImage: AssetImage('assets/images/avatar.jpg'),
//               ),
//               if (isToday)
//                 Positioned(
//                   top: 0,
//                   right: 0,
//                   child: Container(
//                     padding: const EdgeInsets.all(2),
//                     decoration: BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Icon(Icons.cake, size: 12, color: Colors.white),
//                   ),
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(
//             member.name,
//             style: GoogleFonts.poppins(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: Colors.black87,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Text(
//             member.dob,
//             style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[600]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCustomDrawer(BuildContext context) {
//     return Drawer(
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topRight: Radius.circular(16),
//           bottomRight: Radius.circular(16),
//         ),
//       ),
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           return Column(
//             children: [
//               DrawerHeader(
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [AppColors.orangeDark, AppColors.orangePrimary],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: Row(
//                   children: [
//                     const CircleAvatar(
//                       radius: 30,
//                       backgroundImage: AssetImage('assets/images/avatar.jpg'),
//                     ),
//                     const SizedBox(width: 16),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           AppLocalizations.of(context)!.guest_user,
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text(
//                           AppLocalizations.of(context)!.welcome,
//                           style: TextStyle(color: Colors.white70, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 12),

//               // Menu Items
//               _buildDrawerItem(
//                 context,
//                 icon: 'assets/icons/diagram.png',
//                 label: AppLocalizations.of(context)!.treeView,
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => TreeViewScreen()),
//                 ),
//               ),
//               _buildDrawerItem(
//                 context,
//                 icon: 'assets/icons/photos.png',
//                 label: AppLocalizations.of(context)!.memories,
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => MomentsListScreen(isAdmin: false),
//                   ),
//                 ),
//               ),
//               _buildDrawerItem(
//                 context,
//                 icon: 'assets/icons/event.png',
//                 label: AppLocalizations.of(context)!.eventTitle,
//                 onTap: () => Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (_) => const EventCalendarScreen(),
//                   ),
//                 ),
//               ),

//               _buildDrawerItem(
//                 context,
//                 icon: 'assets/icons/setting.png',
//                 label: AppLocalizations.of(context)!.settings,
//                 onTap: () => Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (_) => SettingScreen(isComingFromAdmin: false),
//                   ),
//                 ),
//               ),

//               // Spacer to push version info to the bottom
//               Expanded(child: Container()),

//               const Divider(thickness: 1, indent: 20, endIndent: 20),

//               Padding(
//                 padding: const EdgeInsets.only(bottom: 16),
//                 child: Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Text(
//                     'App version 1.0.0',
//                     style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildDrawerItem(
//     BuildContext context, {
//     required String icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(10),
//         onTap: onTap,
//         child: ListTile(
//           leading: Image.asset(icon, color: AppColors.orangePrimary),
//           title: Text(
//             label,
//             style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
//           ),
//           trailing: const Icon(
//             Icons.arrow_forward_ios_rounded,
//             size: 14,
//             color: Colors.grey,
//           ),
//         ),
//       ),
//     );
//   }
// }
