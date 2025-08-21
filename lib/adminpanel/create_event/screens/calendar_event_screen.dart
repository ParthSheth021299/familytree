// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';

// class CalendarEventScreen extends StatefulWidget {
//   const CalendarEventScreen({super.key});

//   @override
//   State<CalendarEventScreen> createState() => _CalendarEventScreenState();
// }

// class _CalendarEventScreenState extends State<CalendarEventScreen> {
// Map<DateTime, List<Map<String, dynamic>>> _eventsByDate = {};
// DateTime _focusedDay = DateTime.now();
// DateTime? _selectedDay;

//   @override
//   void initState() {
//     super.initState();
//     _loadEventsFromFirestore();
//   }

// void _loadEventsFromFirestore() async {
//   final snapshot = await FirebaseFirestore.instance
//       .collection('events')
//       .get();

//   Map<DateTime, List<Map<String, dynamic>>> eventsMap = {};

//   for (var doc in snapshot.docs) {
//     final data = doc.data();
//     final date = DateTime.parse(data['date']).toLocal();
//     final key = DateTime(date.year, date.month, date.day);

//     eventsMap.putIfAbsent(key, () => []).add(data);
//   }

//   setState(() => _eventsByDate = eventsMap);
// }

// List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
//   final key = DateTime(day.year, day.month, day.day);
//   return _eventsByDate[key] ?? [];
// }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Event Calendar"),
//         centerTitle: true,
//         backgroundColor: theme.colorScheme.primary,
//         foregroundColor: theme.colorScheme.onPrimary,
//         elevation: 2,
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: TableCalendar(
//               focusedDay: _focusedDay,
//               firstDay: DateTime.utc(2020, 1, 1),
//               lastDay: DateTime.utc(2100, 12, 31),
//               eventLoader: _getEventsForDay,
//               selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//               onDaySelected: (selectedDay, focusedDay) {
//                 setState(() {
//                   _selectedDay = selectedDay;
//                   _focusedDay = focusedDay;
//                 });
//               },
//               calendarStyle: CalendarStyle(
//                 todayDecoration: BoxDecoration(
//                   color: theme.colorScheme.primary.withOpacity(0.6),
//                   shape: BoxShape.circle,
//                 ),
//                 selectedDecoration: BoxDecoration(
//                   color: theme.colorScheme.primary,
//                   shape: BoxShape.circle,
//                 ),
//                 markerDecoration: BoxDecoration(
//                   color: theme.colorScheme.secondary,
//                   shape: BoxShape.circle,
//                 ),
//                 outsideTextStyle: TextStyle(color: theme.disabledColor),
//               ),
//               headerStyle: HeaderStyle(
//                 formatButtonVisible: false,
//                 titleCentered: true,
//                 titleTextStyle: theme.textTheme.titleMedium!.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
// Expanded(
//   child: _getEventsForDay(_selectedDay ?? _focusedDay).isEmpty
//       ? Center(
//           child: Text(
//             "No events on this day",
//             style: theme.textTheme.bodyLarge,
//           ),
//         )
//       : ListView.builder(
//           padding: const EdgeInsets.all(12.0),
//           itemCount: _getEventsForDay(
//             _selectedDay ?? _focusedDay,
//           ).length,
//           itemBuilder: (context, index) {
//             final event = _getEventsForDay(
//               _selectedDay ?? _focusedDay,
//             )[index];
//             final dateFormatted = DateFormat.yMMMEd().format(
//               DateTime.parse(event['date']),
//             );

//             return Card(
//               elevation: 2,
//               margin: const EdgeInsets.only(bottom: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       event['title'] ?? 'Untitled Event',
//                       style: theme.textTheme.titleMedium?.copyWith(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       event['description'] ?? '',
//                       style: theme.textTheme.bodyMedium,
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.calendar_today,
//                           size: 16,
//                           color: theme.colorScheme.primary,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           dateFormatted,
//                           style: theme.textTheme.bodySmall?.copyWith(
//                             color: theme.colorScheme.primary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({super.key});

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // Map<DateTime, List<String>> _eventsByDate = {};
  Map<DateTime, List<Map<String, dynamic>>> _eventsByDate = {};

  @override
  void initState() {
    super.initState();
    _loadEventsFromFirestore();
  }

  void _loadEventsFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('events')
        .get();

    Map<DateTime, List<Map<String, dynamic>>> eventsMap = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final date = DateTime.parse(data['date']).toLocal();
      final key = DateTime(date.year, date.month, date.day);

      eventsMap.putIfAbsent(key, () => []).add(data);
    }

    setState(() => _eventsByDate = eventsMap);
  }

  List<Map<String, dynamic>> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return _eventsByDate[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.eventCalendar)),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            selectedDayPredicate: (day) =>
                _selectedDay != null && isSameDay(day, _selectedDay),
            eventLoader: _getEventsForDay,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              selectedDecoration: const BoxDecoration(), // No circle
              todayDecoration: const BoxDecoration(), // No circle
              selectedTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
              todayTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: themeColor,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                bool isSelected =
                    _selectedDay != null && isSameDay(day, _selectedDay);
                bool isToday = isSameDay(day, DateTime.now());

                return Center(
                  child: Text(
                    '${day.day}',
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected ? themeColor : null,
                    ),
                  ),
                );
              },
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return const SizedBox.shrink();
                final String eventText = events.length > 1 ? "Events" : "Event";
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${events.length} ${events.length > 1 ? "Events" : "Event"}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _getEventsForDay(_selectedDay ?? _focusedDay).isEmpty
                ? Center(
                    child: Text(
                      "No events on this day",
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12.0),
                    itemCount: _getEventsForDay(
                      _selectedDay ?? _focusedDay,
                    ).length,
                    itemBuilder: (context, index) {
                      final event = _getEventsForDay(
                        _selectedDay ?? _focusedDay,
                      )[index];
                      final dateFormatted = DateFormat.yMMMEd().format(
                        DateTime.parse(event['date']),
                      );
                      final eventDate = DateFormat(
                        'yyyy-MM-dd',
                      ).parse(event['date']);
                      final formattedDate = DateFormat(
                        'dd MMM yyyy',
                      ).format(eventDate);

                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          // child: Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       event['title'] ?? 'Untitled Event',
                          //       style: theme.textTheme.titleMedium?.copyWith(
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //     const SizedBox(height: 4),
                          //     Text(
                          //       event['description'] ?? '',
                          //       style: theme.textTheme.bodyMedium,
                          //     ),
                          //     const SizedBox(height: 8),
                          //     Row(
                          //       children: [
                          //         Icon(
                          //           Icons.calendar_today,
                          //           size: 16,
                          //           color: theme.colorScheme.primary,
                          //         ),
                          //         const SizedBox(width: 6),
                          //         Text(
                          //           dateFormatted,
                          //           style: theme.textTheme.bodySmall?.copyWith(
                          //             color: theme.colorScheme.primary,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ],
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
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    title: Text(event['title'] ?? ''),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (formattedDate.isNotEmpty)
                                          Text("📅 Date: $formattedDate"),
                                        if (event['time'] != null)
                                          Text("🕒 Time: ${event['time']}"),
                                        if (event['place'] != null)
                                          Text("📍 Place: ${event['place']}"),
                                        const SizedBox(height: 8),
                                        Text(
                                          event['description'] ?? '',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        style: ButtonStyle(
                                          shape: WidgetStatePropertyAll(
                                            ContinuousRectangleBorder(
                                              side: BorderSide(
                                                color: AppColors.orangeDark,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text(
                                          "Close",
                                          style: TextStyle(
                                            color: AppColors.orangeDark,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
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
