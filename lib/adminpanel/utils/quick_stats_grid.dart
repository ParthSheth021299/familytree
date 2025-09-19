import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:family_tree/adminpanel/utils/stat_card.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuickStatsGrid extends StatelessWidget {
  final int total;
  final int male;
  final int female;
  final int alive;
  final int children;
  final int adults;
  const QuickStatsGrid({
    super.key,
    required this.total,
    required this.male,
    required this.female,
    required this.alive,
    required this.children,
    required this.adults,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.familyOverview,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
          children: [
            StatCard(
              title: AppLocalizations.of(context)!.totalMembers,
              count: total.toString(),
              icon: Icons.group,
              color: AppColors.orangePrimary,
              gradient: [AppColors.orangePrimary, Colors.orange[300]!],
            ),
            StatCard(
              title: AppLocalizations.of(context)!.male,
              count: male.toString(),
              icon: Icons.male,
              color: Colors.blue,
              gradient: [Colors.blue, Colors.blue[300]!],
            ),
            StatCard(
              title: AppLocalizations.of(context)!.female,
              count: female.toString(),
              icon: Icons.female,
              color: Colors.pink,
              gradient: [Colors.pink, Colors.pink[300]!],
            ),
          ],
        ),
      ],
    );
  }
}
