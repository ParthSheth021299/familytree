import 'package:family_tree/screens/home_screen.dart';
import 'package:family_tree/service/google_sheet_service.dart';
import 'package:flutter/material.dart';


class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  AddMemberScreenState createState() => AddMemberScreenState();
}

class AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = GoogleSheetsService();

  final Map<String, dynamic> formData = {
    "ID": DateTime.now().millisecondsSinceEpoch.toString(),
    "ParentID": "",
    "Name": "",
    "Gender": "Male",
    "BloodGroup": "A+",
    "WhatsApp": "",
    "MaritalStatus": "Single",
    "SpouseName": "",
    "Children": "No",
    "Email": "",
    "Location": "",
    "PhotoUrl": "", // placeholder
    "HouseRoot": "",
  };

  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _service.addFamilyMember(formData);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Member Added!")));
        
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  Widget _buildTextInput(String label, String key, {TextInputType? inputType}) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      keyboardType: inputType,
      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      onSaved: (value) => formData[key] = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Family Member')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextInput('Name', 'Name'),
              _buildTextInput('Parent ID', 'ParentID'),
              DropdownButtonFormField(
                value: formData['Gender'],
                decoration: InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other'].map((gender) {
                  return DropdownMenuItem(value: gender, child: Text(gender));
                }).toList(),
                onChanged: (val) => setState(() => formData['Gender'] = val),
              ),
              DropdownButtonFormField(
                value: formData['BloodGroup'],
                decoration: InputDecoration(labelText: 'Blood Group'),
                items: bloodGroups.map((bg) {
                  return DropdownMenuItem(value: bg, child: Text(bg));
                }).toList(),
                onChanged: (val) => setState(() => formData['BloodGroup'] = val),
              ),
              _buildTextInput('WhatsApp Number', 'WhatsApp', inputType: TextInputType.phone),
              DropdownButtonFormField(
                value: formData['MaritalStatus'],
                decoration: InputDecoration(labelText: 'Marital Status'),
                items: ['Single', 'Married'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status));
                }).toList(),
                onChanged: (val) => setState(() => formData['MaritalStatus'] = val),
              ),
              if (formData['MaritalStatus'] == 'Married')
                _buildTextInput('Spouse Name', 'SpouseName'),
              DropdownButtonFormField(
                value: formData['Children'],
                decoration: InputDecoration(labelText: 'Has Children?'),
                items: ['Yes', 'No'].map((opt) {
                  return DropdownMenuItem(value: opt, child: Text(opt));
                }).toList(),
                onChanged: (val) => setState(() => formData['Children'] = val),
              ),
              _buildTextInput('Email', 'Email', inputType: TextInputType.emailAddress),
              _buildTextInput('Location', 'Location'),
              _buildTextInput('House Root', 'HouseRoot'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Add Member'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
