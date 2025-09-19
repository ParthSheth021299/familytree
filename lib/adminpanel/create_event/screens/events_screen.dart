import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  // Stream<List<Map<String, dynamic>>> streamUpcomingEvents() {
  //   final now = DateTime.now();
  //   final today = DateTime(now.year, now.month, now.day);
  //   final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

  //   final sameDayEventsStream = FirebaseFirestore.instance
  //       .collection('events')
  //       .snapshots()
  //       .map(
  //         (snapshot) => snapshot.docs
  //             .map((doc) => doc.data() as Map<String, dynamic>)
  //             .where((data) {
  //               if (!data.containsKey('date') || data['date'] == null) {
  //                 return false; // skip if no date
  //               }

  //               DateTime? eventDate;

  //               // Convert based on stored type
  //               if (data['date'] is Timestamp) {
  //                 eventDate = (data['date'] as Timestamp).toDate();
  //               } else if (data['date'] is String) {
  //                 eventDate = DateTime.tryParse(data['date']);
  //               }

  //               if (eventDate == null) return false;

  //               return eventDate.year == today.year &&
  //                   eventDate.month == today.month &&
  //                   eventDate.day == today.day;
  //             })
  //             .toList(),
  //       );

  //   // return FirebaseFirestore.instance
  //   //     .collection('events')
  //   //     .where('date', isGreaterThanOrEqualTo: today)
  //   //     .where('date', isLessThanOrEqualTo: endOfMonth)
  //   //     .orderBy('date')
  //   //     .snapshots()
  //   //     .map(
  //   //       (snapshot) => snapshot.docs
  //   //           .map((doc) => doc.data() as Map<String, dynamic>)
  //   //           .toList(),
  //   //     );
  //   return sameDayEventsStream;
  // }
  Stream<List<Map<String, dynamic>>> streamUpcomingEvents() {
    return FirebaseFirestore.instance
        .collection('events')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: streamUpcomingEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(AppLocalizations.of(context)!.errorLoadingEvents),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _sectionCard(
            title: "📌 ${AppLocalizations.of(context)!.upcomingEvents}",
            child: Text(
              AppLocalizations.of(context)!.noUpcomingEvents,
              style: _subTextStyle(),
            ),
          );
        }

        final events = snapshot.data!;

        return _sectionCard(
          title: "📌 ${AppLocalizations.of(context)!.upcomingEvents}",
          child: Column(
            children: events.map((event) {
              final eventDate = DateFormat('yyyy-MM-dd').parse(event['date']);
              final formattedDate = DateFormat('dd MMM yyyy').format(eventDate);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                // child: ListTile(
                //   contentPadding: EdgeInsets.zero,
                //   leading: const Icon(
                //     Icons.event_note,
                //     color: AppColors.orangePrimary,
                //   ),
                //   title: Text(
                //     event['title'],
                //     style: _subTextStyle(fontWeight: FontWeight.bold),
                //   ),
                //   subtitle: Text(
                //     '$formattedDate\n${event['description'] ?? ''}',
                //     style: _subTextStyle(size: 12, color: Colors.grey[700]!),
                //   ),
                //   isThreeLine: event['description'] != null,
                // ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.event_note,
                    color: AppColors.orangePrimary,
                  ),
                  title: Text(
                    event['title'] ?? '',
                    style: _subTextStyle(fontWeight: FontWeight.bold),
                  ),
                  // onTap: () {
                  //   showDialog(
                  //     context: context,
                  //     builder: (context) {
                  //       return AlertDialog(
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(12),
                  //         ),
                  //         title: Text(event['title'] ?? ''),
                  //         content: Column(
                  //           mainAxisSize: MainAxisSize.min,
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             if (formattedDate.isNotEmpty)
                  //               Text("📅 Date: $formattedDate"),
                  //             if (event['time'] != null)
                  //               Text("🕒 Time: ${event['time']}"),
                  //             if (event['place'] != null)
                  //               Text("📍 Place: ${event['place']}"),
                  //             const SizedBox(height: 8),
                  //             Text(
                  //               event['description'] ?? '',
                  //               style: const TextStyle(fontSize: 14),
                  //             ),
                  //           ],
                  //         ),
                  //         actions: [
                  //           TextButton(
                  //             style: ButtonStyle(
                  //               shape: WidgetStatePropertyAll(
                  //                 ContinuousRectangleBorder(
                  //                   side: BorderSide(
                  //                     color: AppColors.orangeDark,
                  //                   ),
                  //                 ),
                  //               ),
                  //             ),
                  //             onPressed: () => Navigator.pop(context),
                  //             child: const Text(
                  //               "Close",
                  //               style: TextStyle(color: AppColors.orangeDark),
                  //             ),
                  //           ),
                  //         ],
                  //       );
                  //     },
                  //   );
                  // },
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: 400, // keeps it neat on web
                              maxHeight:
                                  MediaQuery.of(context).size.height * 0.7,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Title + Close button
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          event['title'] ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                    ],
                                  ),
                                ),

                                const Divider(height: 1),

                                // Scrollable content
                                Expanded(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (formattedDate.isNotEmpty)
                                          Text(
                                            "📅 ${AppLocalizations.of(context)!.date} $formattedDate",
                                          ),
                                        if (event['time'] != null)
                                          Text(
                                            "🕒 ${AppLocalizations.of(context)!.time} ${event['time']}",
                                          ),
                                        if (event['place'] != null)
                                          Text(
                                            "📍 ${AppLocalizations.of(context)!.place} ${event['place']}",
                                          ),
                                        const SizedBox(height: 12),
                                        Text(
                                          event['description'] ?? '',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            }).toList(),
          ),
        );
      },
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
