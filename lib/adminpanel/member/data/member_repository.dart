// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:family_tree/models/family_member.dart';

// class FamilyRepository {
//   final _collection = FirebaseFirestore.instance.collection('family_members');

//   // Realtime stream
//   Stream<List<FamilyMember>> getMembersStream() {
//     return _collection.snapshots().map((snapshot) {
//       return snapshot.docs.map((doc) {
//         final data = doc.data();
//         return FamilyMember(
//           id: data['id'] ?? doc.id,
//           parentId: data['parentId'] ?? '',
//           name: data['name'] ?? '',
//           mainRoot: data['mainRoot'] ?? '',
//           isRoot: (data['isRoot'] ?? false).toString(),

//           gender: data['gender'] ?? '',
//           bloodGroup: data['bloodGroup'] ?? '',
//           phone: data['phone'] ?? '',
//           isMarried: data['isMarried'].toString(),
//           spouseName: data['spouseName'] ?? '',
//           hasChildren: (data['hasChildren'] ?? false).toString(),
//           email: data['email'] ?? '',

//           dob: data['dob'] ?? '',
//           spousePhotoUrl: data['spousePhotoUrl'] ?? '',
//           spouseWhatsapp: data['spousePhone'] ?? '',
//           spouseBloodGroup: data['spouseBloodGroup'] ?? '',
//           spouseEmail: data['spouseEmail'] ?? '',
//           spouseLocation: data['spouseLocation'] ?? '',
//           spouseGender: data['spouseGender'] ?? '',

//           createdBy: data['createdBy'] ?? '',
//           // spouseId: data['spouseId'],
//         );
//       }).toList();
//     });
//   }

//   // Optional fallback fetch method (not needed if you only use stream)
//   Future<List<FamilyMember>> fetchAllMembers() async {
//     final snapshot = await _collection.get();

//     return snapshot.docs.map((doc) {
//       final data = doc.data();
//       return FamilyMember(
//         id: data['id'] ?? doc.id,
//         parentId: data['parentId'] ?? '',
//         name: data['name'] ?? '',
//         mainRoot: data['mainRoot'] ?? '',
//         isRoot: (data['isRoot'] ?? false).toString(),
//         spouseGender: data['spouseGender'] ?? '',
//         gender: data['gender'] ?? '',
//         bloodGroup: data['bloodGroup'] ?? '',
//         phone: data['phone'] ?? '',
//         isMarried: data['isMarried'].toString() ?? '',
//         spouseName: data['spouseName'] ?? '',
//         hasChildren: (data['hasChildren'] ?? false).toString(),
//         email: data['email'] ?? '',

//         dob: data['dob'] ?? '',
//         spousePhotoUrl: data['spousePhotoUrl'] ?? '',
//         spouseWhatsapp: data['spousePhone'] ?? '',
//         spouseBloodGroup: data['spouseBloodGroup'] ?? '',
//         spouseEmail: data['spouseEmail'] ?? '',
//         spouseLocation: data['spouseLocation'] ?? '',
//         // spouseId: data['spouseId'],
//         createdBy: data['createdBy'] ?? '',
//       );
//     }).toList();
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:family_tree/models/family_member.dart';

class FamilyRepository {
  final _collection = FirebaseFirestore.instance.collection('family_members');

  /// Realtime stream of members
  Stream<List<FamilyMember>> getMembersStream() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();

        return FamilyMember(
          id: data['id'] ?? doc.id,
          parentId: data['parentId'] ?? '',
          mainRoot: data['mainRoot'] ?? '',
          isRoot: (data['isRoot'] ?? false),
          name: data['name'] ?? '',
          gender: data['gender'] ?? '',
          bloodGroup: data['bloodGroup'] ?? '',
          phone: data['phone'] ?? '',
          isMarried: (data['isMarried'] ?? false),
          spouseId: data['spouseId'] ?? '',
          hasChildren: (data['hasChildren'] ?? false),
          email: data['email'] ?? '',
          dob: data['dob'] ?? '',
          location: data['location'] ?? '',
          // whatsapp: data['whatsapp'] ?? '',
          // photoUrl: data['photoUrl'] ?? '',
          isAlive: (data['isAlive'] ?? true),
          createdBy: data['createdBy'] ?? '',

          spouse: Spouse(
            id: data['spouseId'] ?? '',
            name: data['name'] ?? '',
            gender: data['gender'] ?? '',
            dob: data['dob'] ?? '',
            bloodGroup: data['bloodGroup'] ?? '',
            phone: data['phone'] ?? '',
            email: data['email'] ?? '',
            location: data['location'] ?? '',
            whatsapp: data['phone'] ?? '',
            photoUrl: data['spousePhotoUrl'] ?? '',
            isAlive: (data['isAlive'] ?? true),
            createdBy: data['createdBy'] ?? '',
          ),
        );
      }).toList();
    });
  }

  /// Fetch all members once
  // Future<List<FamilyMember>> fetchAllMembers() async {
  //   final snapshot = await _collection.get();

  //   return snapshot.docs.map((doc) {
  //     final data = doc.data();

  //     return FamilyMember(
  //       id: data['id'] ?? doc.id,
  //       parentId: data['parentId'] ?? '',
  //       mainRoot: data['mainRoot'] ?? '',
  //       isRoot: (data['isRoot'] ?? false),
  //       name: data['name'] ?? '',
  //       gender: data['gender'] ?? '',
  //       bloodGroup: data['bloodGroup'] ?? '',
  //       phone: data['phone'] ?? '',
  //       isMarried: data['isMarried'] ?? false,
  //       spouseId: data['spouseId'] ?? '',
  //       hasChildren: (data['hasChildren'] ?? false),
  //       email: data['email'] ?? '',
  //       dob: data['dob'] ?? '',
  //       // location: data['location'] ?? '',
  //       // whatsapp: data['whatsapp'] ?? '',
  //       // photoUrl: data['photoUrl'] ?? '',
  //       isAlive: (data['isAlive'] ?? true),
  //       createdBy: data['createdBy'] ?? '',

  //       spouse: Spouse(
  //         id: data['spouseId'] ?? '',
  //         name: data['name'] ?? '',
  //         gender: data['gender'] ?? '',
  //         dob: data['dob'] ?? '',
  //         bloodGroup: data['bloodGroup'] ?? '',
  //         phone: data['phone'] ?? '',
  //         email: data['email'] ?? '',
  //         location: data['location'] ?? '',
  //         whatsapp: data['phone'] ?? '',
  //         photoUrl: data['spousePhotoUrl'] ?? '',
  //         isAlive: (data['isAlive'] ?? true),
  //         createdBy: data['createdBy'] ?? '',
  //       ),
  //     );
  //   }).toList();
  // }
  Future<List<FamilyMember>> fetchAllMembers() async {
    final snapshot = await _collection.get();

    // Step 1: Create members without spouse
    final members = snapshot.docs.map((doc) {
      final data = doc.data();
      return FamilyMember(
        id: data['id'] ?? doc.id,
        parentId: data['parentId'] ?? '',
        mainRoot: data['mainRoot'] ?? '',
        isRoot: data['isRoot'] ?? false,
        name: data['name'] ?? '',
        gender: data['gender'] ?? '',
        bloodGroup: data['bloodGroup'] ?? '',
        phone: data['phone'] ?? '',
        isMarried: data['isMarried'] ?? false,
        spouseId: data['spouseId'] ?? '',
        hasChildren: data['hasChildren'] ?? false,
        email: data['email'] ?? '',
        dob: data['dob'] ?? '',
        location: data['location'] ?? '',
        isAlive: data['isAlive'] ?? true,
        createdBy: data['createdBy'] ?? '',
        spouse: null,
      );
    }).toList();

    // Step 2: Map of memberId -> FamilyMember
    final memberMap = {for (var m in members) m.id: m};

    // Step 3: Assign spouse
    for (var member in members) {
      if (member.spouseId!.isNotEmpty &&
          memberMap.containsKey(member.spouseId)) {
        final spouseData = memberMap[member.spouseId]!;

        // Assign spouse object
        member.spouse = Spouse(
          id: spouseData.id,
          name: spouseData.name,
          gender: spouseData.gender,
          dob: spouseData.dob,
          bloodGroup: spouseData.bloodGroup,
          phone: spouseData.phone,
          email: spouseData.email,
          // location: spouseData.,
          whatsapp: spouseData.phone,
          photoUrl: '', // add if stored
          isAlive: spouseData.isAlive,
          createdBy: spouseData.createdBy,
          location: '',
        );
      }
    }

    return members;
  }
}
