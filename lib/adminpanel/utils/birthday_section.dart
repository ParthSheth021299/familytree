import 'package:family_tree/adminpanel/utils/enhance_birthday_card.dart';
import 'package:family_tree/models/family_member.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BirthdaySection extends StatelessWidget {
  final String title;
  final List<FamilyMember> members;
  final String emptyMessage;
  final bool isToday;
  const BirthdaySection({
    super.key,
    required this.title,
    required this.members,
    required this.emptyMessage,
    required this.isToday,
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
          Row(
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              if (members.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isToday ? Colors.red[50] : Colors.orange[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${members.length}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isToday ? Colors.red : Colors.orange,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          members.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          isToday ? Icons.cake_outlined : Icons.event_outlined,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          emptyMessage,
                          style: GoogleFonts.poppins(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      return EnhanceBirthdayCard(
                        member: members[index],
                        isToday: isToday,
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
