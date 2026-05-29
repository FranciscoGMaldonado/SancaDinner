import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginController extends ChangeNotifier {
  static const String _baseUrl = 'http://host.docker.internal:8080/api/auth';

  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  String? _userName;
  String? _userRole;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  String? get userName => _userName;
  String? get userRole => _userRole;
  bool get isAuthenticated => _token != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        _token = data['token'] as String?;
        _userName = data['name'] as String?;
        _userRole = data['role'] as String?;
        _setLoading(false);
        return true;
      } else {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        _setError(body['message'] as String? ?? 'Erro desconhecido.');
        _setLoading(false);
        return false;
      }
    } on http.ClientException {
      _setError('Não foi possível conectar ao servidor. Verifique sua conexão.');
      _setLoading(false);
      return false;
    } catch (_) {
      _setError('Ocorreu um erro inesperado. Tente novamente.');
      _setLoading(false);
      return false;
    }
  }

  void logout() {
    _token = null;
    _userName = null;
    _userRole = null;
    _errorMessage = null;
    notifyListeners();
  }
}