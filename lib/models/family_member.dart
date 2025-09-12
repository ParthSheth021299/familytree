// class FamilyMember {
//   final String id;
//   final String parentId;
//   final String name;
//   final String mainRoot;
//   final String gender;
//   final String bloodGroup;
//   final String phone;
//   final String isMarried;
//   final String spouseName;
//   final String hasChildren;
//   final String email;
//   final String isRoot;
//   final String dob;
//   // final String spouseId;
//   final String spousePhotoUrl;
//   final String spouseWhatsapp;
//   final String spouseBloodGroup;
//   final String spouseEmail;
//   final String spouseLocation;
//   final String spouseGender;

//   final String createdBy;

//   FamilyMember({
//     required this.id,
//     required this.parentId,
//     required this.name,
//     required this.mainRoot,
//     required this.gender,
//     required this.bloodGroup,
//     required this.phone,
//     required this.isMarried,
//     required this.spouseName,
//     required this.hasChildren,
//     required this.email,
//     // required this.spouseId,
//     required this.isRoot,
//     required this.dob,
//     required this.spousePhotoUrl,
//     required this.spouseWhatsapp,
//     required this.spouseBloodGroup,
//     required this.spouseEmail,
//     required this.spouseLocation,
//     required this.spouseGender,
//     required this.createdBy,
//   });

//   factory FamilyMember.fromJson(Map<String, dynamic> json) {
//     return FamilyMember(
//       id: json['id'].toString(),
//       parentId: json['parentId'].toString(),
//       name: json['name'] ?? '',
//       mainRoot: json['mainRoot'] ?? '',
//       gender: json['gender'] ?? '',
//       bloodGroup: json['bloodGroup'] ?? '',
//       phone: json['phone'].toString(),
//       isMarried: json['isMarried'].toString() ?? '',
//       spouseName: json['spouseName'] ?? '',
//       hasChildren: json['hasChildren'].toString(),
//       email: json['email'] ?? '',
//       spouseGender: json['spouseGender'] ?? '',
//       isRoot: json['isRoot'].toString(),
//       dob: json['dob'].toString(),
//       spousePhotoUrl: json['spousePhotoUrl'].toString(),
//       spouseWhatsapp: json['spouseWhatsapp'].toString(),
//       spouseBloodGroup: json['spouseBloodGroup'].toString(),
//       spouseEmail: json['spouseEmail'].toString(),
//       spouseLocation: json['spouseLocation'].toString(),

//       // spouseId: json['spouseId'].toString(),
//       createdBy: json['createdBy'].toString(),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id.toString(),
//       'parentId': parentId.toString(),
//       'name': name,
//       'houseRoot': mainRoot,
//       'gender': gender,
//       'bloodGroup': bloodGroup,
//       'phone': phone.toString(),
//       'maritalStatus': isMarried,
//       'spouseName': spouseName,
//       'hasChildren': hasChildren
//           .toString(), // Convert bool to String for Sheets
//       'email': email,
//       'spouseGender': spouseGender,
//       'isRoot': isRoot.toString(), // Convert bool to String for Sheets
//       'dob': dob.toString(),
//       'spousePhotoUrl': spousePhotoUrl.toString(),
//       'spouseWhatsapp': spouseWhatsapp.toString(),
//       'spouseBloodGroup': spouseBloodGroup.toString(),
//       'spouseEmail': spouseEmail.toString(),
//       'spouseLocation': spouseLocation.toString(),
//       // 'spouseId': spouseId.toString(),
//       'createdBy': createdBy.toString(),
//     };
//   }

//   factory FamilyMember.empty() => FamilyMember(
//     id: '',
//     name: '',
//     parentId: '',
//     mainRoot: '',
//     gender: '',
//     bloodGroup: '',
//     phone: '',
//     isMarried: '',
//     spouseName: '',
//     hasChildren: '',
//     email: '',
//     spouseGender: '',
//     isRoot: '',
//     dob: '',
//     spousePhotoUrl: '',
//     spouseWhatsapp: '',
//     spouseBloodGroup: '',
//     spouseEmail: '',
//     spouseLocation: '',
//     // spouseId: '',
//     createdBy: '',
//   );
// }

// extension FamilyMemberCopyWith on FamilyMember {
//   FamilyMember copyWith({
//     String? name,
//     String? phone,
//     String? email,
//     String? spouseGender,
//     String? dob,
//     String? bloodGroup,
//     String? gender,
//     String? mainRoot,
//     String? isMarried,
//     String? spouseName,
//     String? spouseWhatsapp,
//     String? spouseEmail,
//     String? spouseLocation,
//     String? spouseBloodGroup,
//     String? isRoot,
//     String? hasChildren,
//     String? parentId,
//     String? isAlive,
//     String? createdBy,
//     // String? spouseId,
//   }) {
//     return FamilyMember(
//       id: id,
//       parentId: parentId ?? this.parentId,
//       name: name ?? this.name,
//       mainRoot: mainRoot ?? this.mainRoot,
//       gender: gender ?? this.gender,
//       bloodGroup: bloodGroup ?? this.bloodGroup,
//       phone: phone ?? this.phone,
//       isMarried: isMarried ?? this.isMarried,
//       spouseName: spouseName ?? this.spouseName,
//       hasChildren: hasChildren ?? this.hasChildren,
//       email: email ?? this.email,
//       spouseGender: spouseGender ?? this.spouseGender,
//       isRoot: isRoot ?? this.isRoot,
//       dob: dob ?? this.dob,
//       spousePhotoUrl: spousePhotoUrl,
//       spouseWhatsapp: spouseWhatsapp ?? this.spouseWhatsapp,
//       spouseBloodGroup: spouseBloodGroup ?? this.spouseBloodGroup,
//       spouseEmail: spouseEmail ?? this.spouseEmail,
//       spouseLocation: spouseLocation ?? this.spouseLocation,
//       // spouseId: spouseId ?? this.spouseId,
//       createdBy: createdBy ?? this.createdBy,
//     );
//   }
// }
// models/family_member.dart

class FamilyMember {
  final String id;
  final String? parentId; // null for root
  final String name;
  final String mainRoot;
  final String gender;
  final String bloodGroup;
  final String phone;
  final String location;

  // booleans: stored consistently as bool in the model
  final bool isMarried;
  final bool hasChildren;
  final bool isRoot;
  final bool isAlive;

  final String email;
  final String dob;

  // link to spouse document (nullable)
  final String? spouseId;

  // optional in-memory/loaded spouse object (not stored inline)
  Spouse? spouse;

  final String createdBy;

  FamilyMember({
    required this.id,
    this.parentId,
    required this.name,
    required this.location,
    required this.mainRoot,
    required this.gender,
    required this.bloodGroup,
    required this.phone,
    required this.isMarried,
    required this.hasChildren,
    required this.isRoot,
    required this.isAlive,
    required this.email,
    required this.dob,
    this.spouseId,
    this.spouse,
    required this.createdBy,
  });

  // Robust parser helpers
  static bool _toBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final s = v.trim().toLowerCase();
      return s == 'true' || s == '1' || s == 'yes';
    }
    return false;
  }

  static String _toStr(dynamic v) => v?.toString() ?? '';

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    final parsedSpouseId =
        json['spouseId'] != null && _toStr(json['spouseId']).isNotEmpty
        ? _toStr(json['spouseId'])
        : null;
    return FamilyMember(
      id: _toStr(json['id']) != ''
          ? _toStr(json['id'])
          : _toStr(json['documentId'] ?? ''),
      parentId: json.containsKey('parentId') && json['parentId'] != null
          ? _toStr(json['parentId'])
          : null,
      name: json['name'] ?? '',
      location: json['location'] ?? '',
      mainRoot: json['mainRoot'] ?? '',
      gender: json['gender'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      phone: _toStr(json['phone']),
      isMarried: _toBool(json['isMarried']),
      hasChildren: _toBool(json['hasChildren']),
      isRoot: _toBool(json['isRoot']),
      isAlive: json.containsKey('isAlive') ? _toBool(json['isAlive']) : true,
      email: json['email'] ?? '',
      dob: _toStr(json['dob']),
      spouseId: json['spouseId'] != null && _toStr(json['spouseId']).isNotEmpty
          ? _toStr(json['spouseId'])
          : null,

      // spouse: spouseId != null && json['spouse'] is Map<String, dynamic>
      //     ? Spouse.fromJson(Map<String, dynamic>.from(json['spouse']))
      //     : null,
      spouse: parsedSpouseId != null && json['spouse'] is Map<String, dynamic>
          ? Spouse.fromJson(Map<String, dynamic>.from(json['spouse']))
          : null,
      createdBy: _toStr(json['createdBy']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parentId': parentId,
      'name': name,
      'mainRoot': mainRoot,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'phone': phone,
      'isMarried': isMarried,
      'hasChildren': hasChildren,
      'isRoot': isRoot,
      'isAlive': isAlive,
      'email': email,
      'dob': dob,
      'location': location,
      'spouseId': spouseId,
      // Note: don't serialize `spouse` object here if you want spouse as separate doc.
      'createdBy': createdBy,
    };
  }

  FamilyMember copyWith({
    String? id,
    String? parentId,
    String? name,
    String? mainRoot,
    String? gender,
    String? bloodGroup,
    String? phone,
    bool? isMarried,
    bool? hasChildren,
    bool? isRoot,
    bool? isAlive,
    String? email,
    String? dob,
    String? spouseId,
    Spouse? spouse,
    String? createdBy,
    String? location,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      mainRoot: mainRoot ?? this.mainRoot,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      phone: phone ?? this.phone,
      isMarried: isMarried ?? this.isMarried,
      hasChildren: hasChildren ?? this.hasChildren,
      isRoot: isRoot ?? this.isRoot,
      isAlive: isAlive ?? this.isAlive,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      spouseId: spouseId ?? this.spouseId,
      spouse: spouse ?? this.spouse,
      createdBy: createdBy ?? this.createdBy,
      location: location ?? this.location,
    );
  }

  factory FamilyMember.empty() => FamilyMember(
    id: '',
    parentId: null,
    name: '',
    mainRoot: '',
    gender: '',
    bloodGroup: '',
    phone: '',
    isMarried: false,
    hasChildren: false,
    isRoot: false,
    isAlive: true,
    email: '',
    dob: '',
    spouseId: null,
    spouse: null,
    createdBy: '',
    location: '',
  );
}

// models/spouse.dart

class Spouse {
  final String id;
  final String name;
  final String gender;
  final String dob;
  final String bloodGroup;
  final String phone;
  final String email;
  final String location;
  final String whatsapp;
  final String photoUrl;
  final bool isAlive;
  final String createdBy;
  final String? spouseId; // link back to main member (optional)

  Spouse({
    required this.id,
    required this.name,
    required this.gender,
    required this.dob,
    required this.bloodGroup,
    required this.phone,
    required this.email,
    required this.location,
    required this.whatsapp,
    required this.photoUrl,
    required this.isAlive,
    required this.createdBy,
    this.spouseId,
  });

  static bool _toBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is num) return v != 0;
    if (v is String) {
      final s = v.trim().toLowerCase();
      return s == 'true' || s == '1' || s == 'yes';
    }
    return false;
  }

  static String _toStr(dynamic v) => v?.toString() ?? '';

  factory Spouse.fromJson(Map<String, dynamic> json) {
    return Spouse(
      id: _toStr(json['id']) != ''
          ? _toStr(json['id'])
          : _toStr(json['documentId'] ?? ''),
      name: json['name'] ?? '',
      gender: json['gender'] ?? '',
      dob: _toStr(json['dob']),
      bloodGroup: json['bloodGroup'] ?? '',
      phone: _toStr(json['phone']),
      email: json['email'] ?? '',
      location: json['location'] ?? '',
      whatsapp: json['whatsapp'] ?? _toStr(json['spouseWhatsapp']) ?? '',
      photoUrl: json['photoUrl'] ?? _toStr(json['spousePhotoUrl']) ?? '',
      isAlive: json.containsKey('isAlive') ? _toBool(json['isAlive']) : true,
      createdBy: _toStr(json['createdBy']),
      spouseId: json['spouseId'] != null && _toStr(json['spouseId']).isNotEmpty
          ? _toStr(json['spouseId'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'dob': dob,
      'bloodGroup': bloodGroup,
      'phone': phone,
      'email': email,
      'location': location,
      'whatsapp': whatsapp,
      'photoUrl': photoUrl,
      'isAlive': isAlive,
      'createdBy': createdBy,
      'spouseId': spouseId,
    };
  }

  Spouse copyWith({
    String? id,
    String? name,
    String? gender,
    String? dob,
    String? bloodGroup,
    String? phone,
    String? email,
    String? location,
    String? whatsapp,
    String? photoUrl,
    bool? isAlive,
    String? createdBy,
    String? spouseId,
  }) {
    return Spouse(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      location: location ?? this.location,
      whatsapp: whatsapp ?? this.whatsapp,
      photoUrl: photoUrl ?? this.photoUrl,
      isAlive: isAlive ?? this.isAlive,
      createdBy: createdBy ?? this.createdBy,
      spouseId: spouseId ?? this.spouseId,
    );
  }

  factory Spouse.empty() => Spouse(
    id: '',
    name: '',
    gender: '',
    dob: '',
    bloodGroup: '',
    phone: '',
    email: '',
    location: '',
    whatsapp: '',
    photoUrl: '',
    isAlive: true,
    createdBy: '',
    spouseId: null,
  );
}
