import 'package:family_tree/models/family_member.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EnhanceBirthdayCard extends StatelessWidget {
  final FamilyMember member;
  final bool isToday;
  const EnhanceBirthdayCard({
    super.key,
    required this.member,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isToday
              ? [Colors.red[50]!, Colors.red[100]!]
              : [Colors.orange[50]!, Colors.orange[100]!],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isToday ? Colors.red[200]! : Colors.orange[200]!,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage('assets/images/avatar.jpg'),
              ),
              if (isToday)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.cake, size: 12, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            member.name,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            member.dob,
            style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
