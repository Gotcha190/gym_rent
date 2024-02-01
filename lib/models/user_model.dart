enum UserRole {
  user,
  coach,
  admin,
}

class UserModel {
  String? uid;
  String firstName;
  String lastName;
  String role;
  String? phoneNumber;

  UserModel({this.uid,required this.firstName, required this.lastName, required this.role, this.phoneNumber});

  // Metoda do konwersji modelu na mapę
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'role': role,
      'uid': uid,
    };
  }

  // Metoda do tworzenia modelu z mapy
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        uid: map['uid'] ?? '',
        firstName: map['firstName'] ?? '',
        lastName: map['lastName'] ?? '',
        phoneNumber: map['phoneNumber'] ?? '',
        role: map['role'] ?? 'user',
    );
  }

  static UserModel loading() {
    return UserModel(
      uid: 'loading',
      firstName: 'Loading',
      lastName: 'User',
      role: '',
    );
  }

  Map<String, dynamic> getUserFieldsNames() {
    return {
      'First name': firstName,
      'Last name': lastName,
    };
  }

  Map<String, dynamic> getCoachFieldsNames() {
    return {
      'First name': firstName,
      'Last name': lastName,
      'Phone number': phoneNumber ?? ""
    };
  }

  Map<String, dynamic> getAdminFieldsNames() {
    return {
      'First name': firstName,
      'Last name': lastName,
      'Phone number': phoneNumber ?? "",
      'role': role
    };
  }

  String getUserId() {
    return uid ?? '';
  }

  UserRole parseUserRole(String role) {
    switch (role.toLowerCase()) {
      case 'user':
        return UserRole.user;
      case 'coach':
        return UserRole.coach;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.user; // Domyślna wartość, możesz dostosować do własnych potrzeb
    }
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
    return 'UserModel{id: $uid, firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, role: $role}';
  }
}