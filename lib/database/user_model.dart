import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String fullName;
  final String email;
  final String password;

  const UserModel(
      {this.id,
      required this.fullName,
      required this.password,
      required this.email});

  toJson() {
    return {"fullName": fullName, "Email": email, "Password": password};
  }

  // static UserModel formJson(Map<String, dynamic> json) =>
  //   UserModel(fullName: json["fullName"], password: json["password"], email: json["Email"]);


  // MAP USER FETCHED FROM FIREBASE TO UserModel


  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;

    return UserModel(
        id: document.id,
        fullName: data["fullName"],
        password: data["Password"],
        email: data["Email"]);
  }
}
