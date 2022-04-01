import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? name;
  final String userRole;
  final String userId;
  final String emailId;
  final String? mobileNumber;
  final DateTime dateOfReg;

  const User({
    this.name,
    required this.userRole,
    required this.userId,
    required this.emailId,
    this.mobileNumber,
    required this.dateOfReg
  });

  User.fromJson(Map<String, Object?> json)
    : this(
        name: json['name']! as String,
        userRole: json['user_role']! as String,
        userId: json['user_id']! as String,
        emailId: json['email_id']! as String,
        mobileNumber: json['mobile_number'] as String,
        dateOfReg: (json['date_of_reg']! as Timestamp).toDate()
      );

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'user_role': userRole.toString(),
      'user_id': userId,
      'email_id': emailId,
      'mobile_number': mobileNumber,
      'date_of_reg': dateOfReg
    };
  }

  static const userRolesList = ['admin', 'supervisor', 'agent'];
}

enum UserRole{
  agent,
  supervisor,
  admin
}
