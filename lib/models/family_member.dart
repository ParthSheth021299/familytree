class FamilyMember {
  final String id;
  final String parentId;
  final String name;
  final String houseRoot;
  final String gender;
  final String bloodGroup;
  final String whatsapp;
  final String maritalStatus;
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
    required this.houseRoot,
    required this.gender,
    required this.bloodGroup,
    required this.whatsapp,
    required this.maritalStatus,
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
      houseRoot: json['houseRoot'] ?? '',
      gender: json['gender'] ?? '',
      bloodGroup: json['bloodGroup'] ?? '',
      whatsapp: json['whatsapp'].toString(),
      maritalStatus: json['maritalStatus'] ?? '',
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
      'houseRoot': houseRoot,
      'gender': gender,
      'bloodGroup': bloodGroup,
      'whatsapp': whatsapp.toString(),
      'maritalStatus': maritalStatus,
      'spouseName': spouseName,
      'hasChildren': hasChildren.toString(), // Convert bool to String for Sheets
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
