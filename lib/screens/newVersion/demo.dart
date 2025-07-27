import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/models/family_member.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RootMember {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // 🔑 Generate a unique ID for the member
  final id = DateTime.now().millisecondsSinceEpoch.toString();
  Future<void> addTransaction() async {
    // 🧠 Create the FamilyMember object
    final rootMember = FamilyMember(
      id: id,
      parentId: id, // self-referencing for root
      name: 'Suresh Sheth',
      mainRoot: 'dahibanagar',
      gender: 'Male',
      bloodGroup: 'B+',
      phone: '9876543210',
      isMarried: 'Married',
      spouseName: 'Kokila Sheth',
      hasChildren: 'true',
      email: 'suresh@example.com',
      location: 'Ahmedabad',
      photoUrl: '', // optional
      isRoot: 'true',
      dob: '07-07-1970',
      spousePhotoUrl: '',
      spouseWhatsapp: '9876543211',
      spouseBloodGroup: 'B+',
      spouseEmail: 'kokila@example.com',
      spouseLocation: 'Ahmedabad',
    );
    await _firebaseFirestore
        .collection('users')
        .doc(id)
        .collection('transactions')
        .add(rootMember.toJson());
  }
}
