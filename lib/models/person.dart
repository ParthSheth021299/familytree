class PersonInput {
  String name;
  String gender;
  String bloodGroup;
  String whatsapp;
  String email;
  String location;

  PersonInput({
    required this.name,
    this.gender = '',
    this.bloodGroup = '',
    this.whatsapp = '',
    this.email = '',
    this.location = '',
  });
}
