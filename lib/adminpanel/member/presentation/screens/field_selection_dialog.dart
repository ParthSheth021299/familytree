import 'package:flutter/material.dart';

class FieldSelectionDialog extends StatefulWidget {
  final Function(List<String>) onCreatePdf;

  const FieldSelectionDialog({super.key, required this.onCreatePdf});

  @override
  State<FieldSelectionDialog> createState() => _FieldSelectionDialogState();
}

class _FieldSelectionDialogState extends State<FieldSelectionDialog> {
  final Map<String, bool> _fields = {
    'name': true,
    'dob': true,
    'gender': true,
    'bloodGroup': false,
    'phone': false,
    'email': false,
    'isMarried': false,
    'spouseName': false,
    'spouseGender': false,
    'spouseDob': false,
    'spousePhone': false,
    'spouseBloodGroup': false,
    'createdAt': false,
    'createdBy': false,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Select Fields"),
      content: SingleChildScrollView(
        child: Column(
          children: _fields.keys.map((field) {
            return CheckboxListTile(
              title: Text(field),
              value: _fields[field],
              onChanged: (value) {
                setState(() {
                  _fields[field] = value ?? false;
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            final selectedFields = _fields.entries
                .where((e) => e.value)
                .map((e) => e.key)
                .toList();
            Navigator.pop(context);
            widget.onCreatePdf(selectedFields);
          },
          child: const Text("Create PDF"),
        ),
      ],
    );
  }
}
