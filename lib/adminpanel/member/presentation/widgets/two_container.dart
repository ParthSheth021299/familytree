import 'package:family_tree/adminpanel/utils/colors.dart';
import 'package:flutter/material.dart';

class CoupleCard extends StatelessWidget {
  final Person person;

  const CoupleCard({super.key, required this.person});

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

    return Container(
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
          ),
          if (hasSpouse) ...[
            SizedBox(width: 5),
            // Container(width: 1.5, height: 150, color: Colors.grey.shade400),
            // SizedBox(width: 5),
            _InfoPanel(
              person: rightPerson!,
              borderColor: rightPerson.gender == Gender.male
                  ? Colors.blue
                  : Colors.pink,
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  final Person person;
  final Color borderColor;

  const _InfoPanel({required this.person, required this.borderColor});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
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

          SizedBox(height: 5),
          Align(
            alignment: Alignment.center,
            child: Text(
              person.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 2),
          Text('📱 ${person.phone}', style: textTheme.bodyMedium),
          SizedBox(height: 2),
          Text('📧 ${person.email}', style: textTheme.bodyMedium),
          SizedBox(height: 2),
          Text('📍 ${person.location}', style: textTheme.bodyMedium),
          SizedBox(height: 2),
          Text('🩸 ${person.bloodGroup}', style: textTheme.bodyMedium),
        ],
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
  });
}
