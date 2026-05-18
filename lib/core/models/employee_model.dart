import 'package:flutter/material.dart';

class Employee {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String avatarUrl;

  Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarUrl,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'].toString(),
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      avatarUrl: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'avatar': avatarUrl,
    };
  }
}