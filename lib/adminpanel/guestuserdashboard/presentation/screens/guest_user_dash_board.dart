// // ignore_for_file: unnecessary_null_comparison

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

// final todayBirthdays = members.where((e) {
//   try {
//     final dob = dateFormat.parse(e.dob.toString());
//     return dob.day == today.day && dob.month == today.month;
//   } catch (_) {
//     return false;
//   }
// }).toList();

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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/create_event/screens/calendar_event_screen.dart';
import 'package:family_tree/adminpanel/create_event/screens/events_screen.dart';
import 'package:family_tree/adminpanel/member/cubit/member_cubit.dart';
import 'package:family_tree/adminpanel/member/presentation/screens/tree_view.dart';
import 'package:family_tree/adminpanel/moments/presentation/screens/moments_list_screen.dart';
import 'package:family_tree/adminpanel/setting/presentation/screens/setting_screen.dart';
import 'package:family_tree/adminpanel/utils/birthday_section.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/adminpanel/utils/demographics_chart.dart';
import 'package:family_tree/adminpanel/utils/download_app.dart';
import 'package:family_tree/adminpanel/utils/quick_stats_grid.dart';
import 'package:family_tree/adminpanel/utils/welcome_header.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:family_tree/models/family_member.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class GuestUserDashBoard extends StatefulWidget {
  const GuestUserDashBoard({super.key});

  @override
  State<GuestUserDashBoard> createState() => _GuestUserDashBoardState();
}

class _GuestUserDashBoardState extends State<GuestUserDashBoard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<MemberCubit>(context).subscribeToMembers();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    subscribe();
    streamUpcomingEvents();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void subscribe() async {
    if (!kIsWeb) {
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      OneSignal.initialize("62094d7d-71ae-45b3-9bf9-858a815c86b2");
      OneSignal.Notifications.requestPermission(true);
    }
  }

  Stream<List<Map<String, dynamic>>> streamUpcomingEvents() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    final dateFromDatabase = FirebaseFirestore.instance.collection('events');

    return FirebaseFirestore.instance
        .collection('events')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildCustomDrawer(context),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.dashboard,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.orangePrimary,
        elevation: 0,
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
            return _buildEmptyState(context);
          }

          final members = snapshot.data!;

          // Enhanced statistics calculation
          int maleCount = 0;
          int femaleCount = 0;
          int aliveCount = 0;
          int deceasedCount = 0;
          int childrenCount = 0;
          int adultsCount = 0;

          for (final member in members) {
            final gender = member.gender.toLowerCase();

            // Gender count
            if (gender == 'male') {
              maleCount++;
            } else if (gender == 'female') {
              femaleCount++;
            }

            // Age calculation for age groups
            try {
              final dob = DateFormat("dd-MM-yyyy").parse(member.dob.toString());
              final age = DateTime.now().difference(dob).inDays ~/ 365;
              if (age < 18) {
                childrenCount++;
              } else {
                adultsCount++;
              }
            } catch (_) {}

            // Status count (you'll need to add isAlive field to your FamilyMember model)
            // For now, assuming all are alive - modify based on your data structure
            aliveCount++;
          }

          final totalCount = members.length;

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

          return LayoutBuilder(
            builder: (context, constraints) {
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

                        // Quick Stats Cards
                        QuickStatsGrid(
                          total: totalCount,
                          male: maleCount,
                          female: femaleCount,
                          alive: aliveCount,
                          children: childrenCount,
                          adults: adultsCount,
                        ),
                        const SizedBox(height: 24),

                        // Enhanced Member Demographics
                        DemographicsChart(
                          maleCount: maleCount,
                          femaleCount: femaleCount,
                          childrenCount: childrenCount,
                          adultsCount: adultsCount,
                        ),

                        const SizedBox(height: 24),

                        // Today's Birthdays
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

                        // Upcoming Birthdays
                        BirthdaySection(
                          title:
                              "📅 ${AppLocalizations.of(context)!.upcoming_birthdays}",
                          members: upcomingBirthdays,
                          emptyMessage: AppLocalizations.of(
                            context,
                          )!.no_upcoming_birthdays,
                          isToday: false,
                        ),
                        const SizedBox(height: 24),

                        // Events Section
                        EventsScreen(),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                  'App version 1.0.0',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ),
                              if (kIsWeb) ...[
                                const SizedBox(height: 8),

                                DriveDownloadLink(),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.family_restroom, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noMembersFound,
            style: GoogleFonts.poppins(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start building your family tree!',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
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
                icon: 'assets/icons/diagram.png',
                label: AppLocalizations.of(context)!.treeView,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TreeViewScreen()),
                ),
              ),
              _buildDrawerItem(
                context,
                icon: 'assets/icons/photos.png',
                label: AppLocalizations.of(context)!.memories,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MomentsListScreen(isAdmin: false),
                  ),
                ),
              ),
              _buildDrawerItem(
                context,
                icon: 'assets/icons/event.png',
                label: AppLocalizations.of(context)!.eventTitle,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const EventCalendarScreen(),
                  ),
                ),
              ),

              _buildDrawerItem(
                context,
                icon: 'assets/icons/setting.png',
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
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: ListTile(
          leading: Image.asset(icon, color: AppColors.orangePrimary),
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
