class UserModel {
  String? uid;
  String firstName;
  String lastName;
  String role;

  UserModel({this.uid,required this.firstName, required this.lastName, this.role = 'user'});

  // Metoda do konwersji modelu na mapę
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'uid': uid,
    };
  }

  Map<String, dynamic> getFieldsNames() {
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
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;

  @override
  String toString() {
    return 'UserModel{id: $uid, firstName: $firstName, lastName: $lastName}';
  }
}
