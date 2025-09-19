import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  const LegendItem({super.key, required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }
}
