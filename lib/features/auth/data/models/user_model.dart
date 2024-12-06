import 'package:asar/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    super.phoneNumber,
    super.name,
  });

  /// Factory method to create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phoneNumber: json['mobile'] as String?,
      name: json['name'] as String?,
    );
  }

  /// Method to convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mobile': phoneNumber,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'UserModel{id: $id, phoneNumber: $phoneNumber, name: $name}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserModel &&
        other.id == id &&
        other.phoneNumber == phoneNumber &&
        other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ phoneNumber.hashCode ^ name.hashCode;
}