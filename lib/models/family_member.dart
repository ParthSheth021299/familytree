class FamilyMember {
  final String id;
  final String parentId;
  final String name;
  final String mainRoot;
  final String gender;
  final String bloodGroup;
  final String phone;
  final String isMarried;
  final String spouseName;
  final String hasChildren;
  final String email;
  final String location;
  final String photoUrl;
  final String isRoot;
  final String dob;
  final String spousePhotoUrl;
  final String spouseWhatsapp;
  final String spouseBloodGroup;
  final String spouseEmail;
  final String spouseLocation;

  FamilyMember({
    required this.id,
    required this.parentId,
    required this.name,
    required this.mainRoot,
    required this.gender,
    required this.bloodGroup,
    required this.phone,
    required this.isMarried,
    required this.spouseName,
    required this.hasChildren,
    required this.email,
    required this.location,
    required this.photoUrl,
    required this.isRoot,
    required this.dob,
    required this.spousePhotoUrl,
    required this.spouseWhatsapp,
    required this.spouseBloodGroup,
    required this.spouseEmail,
    required this.spouseLocation,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'].toString(),
      parentId: json['parentId'].toString(),
      name: json['name'] ?? '',
      mainRoot: json['mainRoot'] ?? '',
      gender: json['gender'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      phone: json['phone'].toString(),
      isMarried: json['isMarried'].toString() ?? '',
      spouseName: json['spouseName'] ?? '',
      hasChildren: json['hasChildren'].toString(),
      email: json['email'] ?? '',
      location: json['location'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      isRoot: json['isRoot'].toString(),
      dob: json['dob'].toString(),
      spousePhotoUrl: json['spousePhotoUrl'].toString(),
      spouseWhatsapp: json['spouseWhatsapp'].toString(),
      spouseBloodGroup: json['spouseBloodGroup'].toString(),
      spouseEmail: json['spouseEmail'].toString(),
      spouseLocation: json['spouseLocation'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'parentId': parentId.toString(),
      'name': name,
      'houseRoot': mainRoot,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'phone': phone.toString(),
      'maritalStatus': isMarried,
      'spouseName': spouseName,
      'hasChildren': hasChildren
          .toString(), // Convert bool to String for Sheets
      'email': email,
      'location': location,
      'photoUrl': photoUrl,
      'isRoot': isRoot.toString(), // Convert bool to String for Sheets
      'dob': dob.toString(),
      'spousePhotoUrl': spousePhotoUrl.toString(),
      'spouseWhatsapp': spouseWhatsapp.toString(),
      'spouseBloodGroup': spouseBloodGroup.toString(),
      'spouseEmail': spouseEmail.toString(),
      'spouseLocation': spouseLocation.toString(),
    };
  }

  factory FamilyMember.empty() => FamilyMember(
    id: '',
    name: '',
    parentId: '',
    mainRoot: '',
    gender: '',
    bloodGroup: '',
    phone: '',
    isMarried: '',
    spouseName: '',
    hasChildren: '',
    email: '',
    location: '',
    photoUrl: '',
    isRoot: '',
    dob: '',
    spousePhotoUrl: '',
    spouseWhatsapp: '',
    spouseBloodGroup: '',
    spouseEmail: '',
    spouseLocation: '',
  );
}

extension FamilyMemberCopyWith on FamilyMember {
  FamilyMember copyWith({
    String? name,
    String? phone,
    String? email,
    String? location,
    String? dob,
    String? bloodGroup,
    String? gender,
    String? mainRoot,
    String? isMarried,
    String? spouseName,
    String? spouseWhatsapp,
    String? spouseEmail,
    String? spouseLocation,
    String? spouseBloodGroup,
    String? isRoot,
    String? hasChildren,
    String? parentId,
  }) {
    return FamilyMember(
      id: id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
      mainRoot: mainRoot ?? this.mainRoot,
      gender: gender ?? this.gender,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      phone: phone ?? this.phone,
      isMarried: isMarried ?? this.isMarried,
      spouseName: spouseName ?? this.spouseName,
      hasChildren: hasChildren ?? this.hasChildren,
      email: email ?? this.email,
      location: location ?? this.location,
      photoUrl: photoUrl,
      isRoot: isRoot ?? this.isRoot,
      dob: dob ?? this.dob,
      spousePhotoUrl: spousePhotoUrl,
      spouseWhatsapp: spouseWhatsapp ?? this.spouseWhatsapp,
      spouseBloodGroup: spouseBloodGroup ?? this.spouseBloodGroup,
      spouseEmail: spouseEmail ?? this.spouseEmail,
      spouseLocation: spouseLocation ?? this.spouseLocation,
    );
  }
}


// id,
// parentId, 
//name,
// gender, 
//bloodGroup, 
//whatsapp,
// maritalStatus,
// spouseName, 
//hasChildren, 
//email,
// location, 
//photoUrl,
// houseRoot,
// isRoot,
// dob,
// spousePhotoUrl,
// spouseWhatsapp,
// spouseBloodGroup, 
//spouseEmail, spouseLocation
