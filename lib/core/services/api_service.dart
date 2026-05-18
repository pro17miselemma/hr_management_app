import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/employee_model.dart';

class ApiService {
  final String baseUrl = 'https://reqres.in/api/users';
  final String _apiKey = 'free_user_3Di5VQdyhV6ntTVFTp97K7h4iIM';

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
      };

  
  Future<List<Employee>> fetchEmployees() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['data'];
        return data.map((json) => Employee.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load employees: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  
  Future<Employee> createEmployee(String firstName, String lastName, String email) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: _headers,
        body: json.encode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        }),
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        // ReqRes returns the created object with an ID and timestamp
        // We add a dummy avatar for UI consistency
        data['avatar'] = 'https://reqres.in/img/faces/7-image.jpg';
        return Employee.fromJson(data);
      } else {
        throw Exception('Failed to create employee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Create Error: $e');
    }
  }

  // UPDATE
  Future<Employee> updateEmployee(String id, String firstName, String lastName, String email) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: _headers,
        body: json.encode({
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        data['id'] = id; // Ensure ID is preserved
        data['avatar'] = 'https://reqres.in/img/faces/7-image.jpg';
        return Employee.fromJson(data);
      } else {
        throw Exception('Failed to update employee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Update Error: $e');
    }
  }

  // DELETE
  Future<void> deleteEmployee(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$id'),
        headers: _headers,
      );

      if (response.statusCode != 204) {
        throw Exception('Failed to delete employee: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Delete Error: $e');
    }
  }
}
