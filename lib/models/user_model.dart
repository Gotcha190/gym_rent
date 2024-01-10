class UserModel {
  String? uid;
  String firstName;
  String lastName;
  String role;

  UserModel({this.uid,required this.firstName, required this.lastName, this.role = 'user'});

  // Metoda do konwersji modelu na mapę
  Map<String, dynamic> toMap() {
    return {
      'First name': firstName,
      'Last name': lastName,
    };
  }

  // Metoda do tworzenia modelu z mapy
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
    );
  }
  String getUserId() {
    return uid ?? '';
  }
}
