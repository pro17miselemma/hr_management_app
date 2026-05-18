import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../services/api_service.dart';

class EmployeeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Employee> _employees = [];
  bool _isLoading = false;
  String? _error;

  List<Employee> get employees => _employees;
  bool get isLoading => _isLoading;
  String? get error => _error;

  
  Future<void> fetchEmployees() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _employees = await _apiService.fetchEmployees();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<bool> addEmployee(String firstName, String lastName, String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newEmployee = await _apiService.createEmployee(firstName, lastName, email);
      _employees.insert(0, newEmployee);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<bool> updateEmployee(String id, String firstName, String lastName, String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedEmployee = await _apiService.updateEmployee(id, firstName, lastName, email);
      final index = _employees.indexWhere((emp) => emp.id == id);
      if (index != -1) {
        _employees[index] = updatedEmployee;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  
  Future<bool> deleteEmployee(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteEmployee(id);
      _employees.removeWhere((emp) => emp.id == id);
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
