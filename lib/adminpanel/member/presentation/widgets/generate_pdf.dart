import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'pdf_saver.dart'; // <- the conditional file

Future<void> generateFamilyPdf(
  List<String> fields,
  List<Map<String, dynamic>> familyData,
) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Table.fromTextArray(
          headers: fields,
          data: familyData.map((row) {
            return fields.map((field) {
              final value = row[field];
              if (field == 'createdAt' && value != null) {
                return value.toString();
              }
              if (value is bool) return value ? 'Yes' : 'No';
              if (value == null || value.toString().isEmpty) return '-';
              return value.toString();
            }).toList();
          }).toList(),
        );
      },
    ),
  );

  final bytes = await pdf.save();
  await savePdf(bytes, "family_data.pdf"); // conditional saver for web/mobile
}
