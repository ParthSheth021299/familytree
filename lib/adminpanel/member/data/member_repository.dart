import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/models/family_member.dart';

class FamilyRepository {
  final _collection = FirebaseFirestore.instance.collection('family_members');

  // Realtime stream
  Stream<List<FamilyMember>> getMembersStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return FamilyMember(
          id: data['id'] ?? doc.id,
          parentId: data['parentId'] ?? '',
          name: data['name'] ?? '',
          mainRoot: data['mainRoot'] ?? '',
          isRoot: (data['isRoot'] ?? false).toString(),
          photoUrl: data['photoUrl'] ?? '',
          gender: data['gender'] ?? '',
          bloodGroup: data['bloodGroup'] ?? '',
          phone: data['whatsapp'] ?? '',
          isMarried: data['maritalStatus'] ?? '',
          spouseName: data['spouseName'] ?? '',
          hasChildren: (data['hasChildren'] ?? false).toString(),
          email: data['email'] ?? '',
          location: data['location'] ?? '',
          dob: data['dob'] ?? '',
          spousePhotoUrl: data['spousePhotoUrl'] ?? '',
          spouseWhatsapp: data['spouseWhatsapp'] ?? '',
          spouseBloodGroup: data['spouseBloodGroup'] ?? '',
          spouseEmail: data['spouseEmail'] ?? '',
          spouseLocation: data['spouseLocation'] ?? '',
        );
      }).toList();
    });
  }

  // Optional fallback fetch method (not needed if you only use stream)
  Future<List<FamilyMember>> fetchAllMembers() async {
    final snapshot = await _collection.get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return FamilyMember(
        id: data['id'] ?? doc.id,
        parentId: data['parentId'] ?? '',
        name: data['name'] ?? '',
        mainRoot: data['mainRoot'] ?? '',
        isRoot: (data['isRoot'] ?? false).toString(),
        photoUrl: data['photoUrl'] ?? '',
        gender: data['gender'] ?? '',
        bloodGroup: data['bloodGroup'] ?? '',
        phone: data['whatsapp'] ?? '',
        isMarried: data['maritalStatus'] ?? '',
        spouseName: data['spouseName'] ?? '',
        hasChildren: (data['hasChildren'] ?? false).toString(),
        email: data['email'] ?? '',
        location: data['location'] ?? '',
        dob: data['dob'] ?? '',
        spousePhotoUrl: data['spousePhotoUrl'] ?? '',
        spouseWhatsapp: data['spouseWhatsapp'] ?? '',
        spouseBloodGroup: data['spouseBloodGroup'] ?? '',
        spouseEmail: data['spouseEmail'] ?? '',
        spouseLocation: data['spouseLocation'] ?? '',
      );
    }).toList();
  }
}
