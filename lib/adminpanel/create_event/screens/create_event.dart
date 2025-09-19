import 'package:family_tree/adminpanel/create_event/screens/calendar_event_screen.dart';
import 'package:family_tree/adminpanel/service/send_notification.dart';
import 'package:family_tree/adminpanel/service/toast.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventCreateScreen extends StatefulWidget {
  const EventCreateScreen({super.key});

  @override
  State<EventCreateScreen> createState() => _EventCreateScreenState();
}

class _EventCreateScreenState extends State<EventCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  // Function to pick date
  Future<void> _pickDate(BuildContext context) async {
    final theme = Theme.of(context);

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              onSurface: theme.colorScheme.onSurface,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor:
                    theme.colorScheme.primary, // OK/Cancel button color
              ),
            ),
            dialogBackgroundColor: theme.dialogBackgroundColor,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to save to Firebase
  Future<void> _submitEvent() async {
    if (_formKey.currentState?.validate() != true || _selectedDate == null) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Please complete all fields')),
      // );
      showToast(AppLocalizations.of(context)!.pleaseSelectDate, isError: true);
      return;
    }

    final newEvent = {
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'date': _selectedDate!.toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
    };

    try {
      await FirebaseFirestore.instance.collection('events').add(newEvent);
      showToast('✅ ${AppLocalizations.of(context)!.eventCreatedSuccessfully}');
      await sendNotificationToAndroid(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        date:
            '${_selectedDate?.day}/${_selectedDate?.month}/${_selectedDate?.year}',
      );
      _titleController.clear();
      _descriptionController.clear();

      setState(() {
        _selectedDate = null;
      });

      // Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EventCalendarScreen()),
              );
            },
            icon: Icon(Icons.calendar_today),
            label: Text(AppLocalizations.of(context)!.viewEvents),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context)!.planNewEvent,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.markSpecialOccasions,
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  //Title
                  Text(
                    AppLocalizations.of(context)!.enterTitle,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.eventTitle,
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? AppLocalizations.of(context)!.required
                        : null,
                  ),
                  const SizedBox(height: 20),
                  //Description
                  Text(
                    AppLocalizations.of(context)!.enterDescription,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.eventDescription,
                    ),
                    maxLines: 3,
                    validator: (value) => value == null || value.isEmpty
                        ? AppLocalizations.of(context)!.required
                        : null,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedDate != null
                            ? '📅 ${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}'
                            : AppLocalizations.of(context)!.noEventDate,
                        style: const TextStyle(fontSize: 16),
                      ),
                      ElevatedButton(
                        onPressed: () => _pickDate(context),
                        child: Text(AppLocalizations.of(context)!.chooseDate),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _submitEvent,
                      icon: const Icon(Icons.save),
                      label: Text(AppLocalizations.of(context)!.saveEvent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
