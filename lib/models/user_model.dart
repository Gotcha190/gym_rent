class UserProfile {
  String firstName;
  String lastName;

  UserProfile({required this.firstName, required this.lastName});

  // Metoda do konwersji modelu na mapę
  Map<String, dynamic> toMap() {
    return {
      'First name': firstName,
      'Last name': lastName,
    };
  }

  // Metoda do tworzenia modelu z mapy
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
    );
  }
}
