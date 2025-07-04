
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/family_member.dart';

class GoogleSheetsService {
  static const String sheetUrl = 'https://script.google.com/macros/s/AKfycbx0f37-9pS14YMj4cz7QoPVUd3d5nKT-7zsPBmpsln_Xt2q82w5MZEVvFMjmA-PG15oZQ/exec';

  Future<List<FamilyMember>> fetchFamilyData() async {
   
    try {
  final response = await http.get(Uri.parse(sheetUrl));
  if (response.statusCode == 200 ) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    
    return jsonList.map((json) => FamilyMember.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch data: ${response.statusCode} ${response.body}');
  }
} catch (e) {
  print("Error fetching data: $e");  // <-- This should print the real error now
  rethrow;
}

  }

  Future<void> addFamilyMember(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse(sheetUrl),    
      headers: {
        "Content-Type": "application/json",
      "Access-Control-Allow-Origin": "*"},
      body: jsonEncode(data),
    );

   

    if (response.statusCode == 200 || response.statusCode == 302) {
      
    } else if (response.statusCode != 200 || response.statusCode !=302) {
      
    }
  }

  Future<void> insertMember(FamilyMember member) async {
    
    final Map<String, dynamic> data = {
  'id': member.id,
  'parentId': member.parentId,
  'name': member.name,
  'houseRoot': member.houseRoot,
  'gender': member.gender,
  'bloodGroup': member.bloodGroup,
  'whatsapp': member.whatsapp,
  'maritalStatus': member.maritalStatus.toString(),
  'spouseName': member.spouseName,
  'hasChildren': member.hasChildren.toString(),
  'email': member.email,
  'location': member.location,
  'photoUrl': member.photoUrl,
  'isRoot': member.isRoot.toString(),
  'dob': member.dob,
  'spousePhotoUrl': member.spousePhotoUrl,
  'spouseWhatsapp': member.spouseWhatsapp,
  'spouseBloodGroup': member.spouseBloodGroup,
  'spouseEmail': member.spouseEmail,
  'spouseLocation': member.spouseLocation,
};


    await addFamilyMember(data);
  }

  Future<void> insertMultipleMembers(List<FamilyMember> members) async {
    for (var member in members) {
      await insertMember(member);
      await Future.delayed(const Duration(milliseconds: 200));
    }
  }
}
