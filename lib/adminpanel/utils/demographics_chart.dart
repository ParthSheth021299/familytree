import 'package:family_tree/adminpanel/utils/legend_item.dart';
import 'package:family_tree/l10n/app_localizations.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DemographicsChart extends StatelessWidget {
  final int maleCount;
  final int femaleCount;
  final int childrenCount;
  final int adultsCount;
  const DemographicsChart({
    super.key,
    required this.maleCount,
    required this.femaleCount,
    required this.childrenCount,
    required this.adultsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.demographics,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                // Gender Chart
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.genderDistribution,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: PieChart(
                          PieChartData(
                            sections: [
                              PieChartSectionData(
                                color: Colors.blueAccent,
                                value: maleCount.toDouble(),
                                title: '$maleCount',
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                radius: 60,
                              ),
                              PieChartSectionData(
                                color: Colors.pinkAccent,
                                value: femaleCount.toDouble(),
                                title: '$femaleCount',
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                radius: 60,
                              ),
                            ],
                            sectionsSpace: 2,
                            centerSpaceRadius: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),

                // Age Groups Chart
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Legends
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              LegendItem(
                color: Colors.blueAccent,
                label: '${AppLocalizations.of(context)!.male} ($maleCount)',
              ),
              LegendItem(
                color: Colors.pinkAccent,
                label: '${AppLocalizations.of(context)!.female} ($femaleCount)',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
