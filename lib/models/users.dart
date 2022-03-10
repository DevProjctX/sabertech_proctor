import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? name;
  final String userRole;
  final String userId;
  final String emailId;
  final DateTime dateOfReg;

  const User({
    required this.name,
    required this.userRole,
    required this.userId,
    required this.emailId,
    required this.dateOfReg
  });

  User.fromJson(Map<String, Object?> json)
    : this(
        name: json['name']! as String?,
        userRole: json['user_role']! as String,
        userId: json['user_id']! as String,
        emailId: json['email_id']! as String,
        dateOfReg: (json['date_of_reg']! as Timestamp).toDate()
      );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'user_role': userRole.toString(),
      'user_id': userId,
      'email_id': emailId,
      'date_of_reg': dateOfReg
    };
  }

  static const userRolesList = ['admin', 'supervisor', 'agent'];
  // User copy({
  //   String? name,
  //   String? lastName,
  //   int? age,
  // }) =>
  //     User(
  //       name: name ?? this.name,
  //       lastName: lastName ?? this.lastName,
  //       age: age ?? this.age,
  //     );

  // @override
  // bool operator ==(Object other) =>
  //     identical(this, other) ||
  //     other is User &&
  //         runtimeType == other.runtimeType &&
  //         name == other.name &&
  //         lastName == other.lastName &&
  //         age == other.age;

  // @override
  // int get hashCode => name.hashCode ^ lastName.hashCode ^ age.hashCode;
}

enum UserRole{
  agent,
  supervisor,
  admin
}
