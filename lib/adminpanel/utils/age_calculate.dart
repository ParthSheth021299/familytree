int? calculateAgeFromString(String dobString) {
  try {
    // Parse the string into DateTime
    final parts = dobString.split("-");
    if (parts.length != 3) return null;

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    final birthDate = DateTime(year, month, day);
    final today = DateTime.now();

    int age = today.year - birthDate.year;

    // Adjust if birthday hasn't occurred yet this year
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }

    return age;
  } catch (e) {
    return null; // return null if parsing fails
  }
}
