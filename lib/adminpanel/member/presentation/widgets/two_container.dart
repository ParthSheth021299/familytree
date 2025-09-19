import 'package:family_tree/adminpanel/member/model/visibility_model.dart';
import 'package:family_tree/adminpanel/member/presentation/screens/member_detail.dart';
import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CoupleCard extends StatelessWidget {
  final Person person;
  final VisibilityModel visibility;

  const CoupleCard({super.key, required this.person, required this.visibility});

  @override
  Widget build(BuildContext context) {
    final hasSpouse = person.isMarried && person.spouse != null;

    // Decide left-right based on gender
    Person leftPerson;
    Person? rightPerson;

    if (person.gender == Gender.male) {
      leftPerson = person;
      rightPerson = hasSpouse ? person.spouse : null;
    } else {
      leftPerson = hasSpouse ? person.spouse! : person;
      rightPerson = hasSpouse ? person : null;
    }

    return !visibility.showAliveStatus && !person.isAlive
        ? SizedBox.shrink()
        : Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.orangePrimary, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _InfoPanel(
                  person: leftPerson,
                  borderColor: leftPerson.gender == Gender.male
                      ? Colors.blue
                      : Colors.pink,
                  visibility: visibility,
                ),

                if (hasSpouse && visibility.showSpouse) ...[
                  SizedBox(width: 5),

                  _InfoPanel(
                    person: rightPerson!,
                    borderColor: rightPerson.gender == Gender.male
                        ? Colors.blue
                        : Colors.pink,
                    visibility: visibility,
                  ),
                ],
              ],
            ),
          );
  }
}

class _InfoPanel extends StatelessWidget {
  final Person person;
  final VisibilityModel visibility;
  final Color borderColor;

  const _InfoPanel({
    required this.person,
    required this.borderColor,
    required this.visibility,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => MemberDetailScreen(
              name: person.name,
              location: person.location,
              phoneNumber: person.phone,
              bloodGroup: person.bloodGroup,
              isAlive: person.isAlive,
              dob: person.dob,
              email: person.email,
              gender: person.gender == Gender.male ? 'male' : 'female',
            ),
          ),
        );
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: person.isAlive ? null : Colors.grey,
          border: Border.all(
            color: person.gender == Gender.male ? Colors.blue : Colors.pink,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 30,

                backgroundImage: AssetImage(
                  person.gender == Gender.male
                      ? 'assets/images/male.png'
                      : 'assets/images/female.png',
                ),
              ),
            ),

            SizedBox(height: 8),
            Align(
              alignment: Alignment.center,
              child: Text(
                person.name,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            // SizedBox(height: 2),
            // if (visibility.showContact)
            //   Text('📱 ${person.phone}', style: textTheme.bodyMedium),
            // SizedBox(height: 2),
            // if (visibility.showEmail)
            //   Text('📧 ${person.email}', style: textTheme.bodyMedium),
            // SizedBox(height: 2),
            // if (visibility.showLocation)
            //   Text('📍 ${person.location}', style: textTheme.bodyMedium),
            // SizedBox(height: 2),
            // if (visibility.showBloodGroup)
            //   Text('🩸 ${person.bloodGroup}', style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

enum Gender { male, female }

class Person {
  final String name;
  final String phone;
  final String email;
  final Gender gender;
  final bool isMarried;
  final Person? spouse;
  final String location;
  final String bloodGroup;
  final bool isAlive;
  final String dob;

  const Person({
    required this.name,
    required this.phone,
    required this.email,
    required this.gender,
    this.isMarried = false,
    this.spouse,
    required this.location,
    required this.bloodGroup,
    required this.isAlive,
    required this.dob,
  });
}
