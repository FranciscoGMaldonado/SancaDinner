import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/admin_models.dart';

class AdminUserController extends ChangeNotifier {
  static const String _baseUrl = 'http://host.docker.internal:8080/api';

  final String token;
  AdminUserController({required this.token});

  List<AdminUser> _users = [];
  List<AdminUser> get users => _users;

  bool _loading = false;
  bool get loading => _loading;

  // null = não testado ainda, false = endpoint não existe
  bool? _listSupported;
  bool get listSupported => _listSupported ?? false;

  bool? _updateSupported;
  bool get updateSupported => _updateSupported ?? false;

  String? _error;
  String? get error => _error;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // ── Fetch all ─────────────────────────────────────────
  // GET /api/users
  Future<void> fetchUsers() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await http
          .get(Uri.parse('$_baseUrl/users'), headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        _users = list
            .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
            .toList();
        _listSupported = true;
      } else if (res.statusCode == 404 || res.statusCode == 405) {
        _listSupported = false;
      } else {
        _error = 'Erro ao carregar usuários (${res.statusCode}).';
      }
    } catch (_) {
      _error = 'Sem conexão com o servidor.';
    }
    _loading = false;
    notifyListeners();
  }

  // ── Create ────────────────────────────────────────────
  // POST /api/auth/register
  // Body: { name, email, password, role }
  Future<String?> createUser({
    required String name,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse('$_baseUrl/auth/register'),
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'email': email,
              'password': password,
              'role': role.value,
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 || res.statusCode == 201) {
        await fetchUsers();
        return null;
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>?;
      return body?['message'] as String? ??
          'Erro ao criar usuário (${res.statusCode}).';
    } catch (_) {
      return 'Sem conexão com o servidor.';
    }
  }

  // ── Update ────────────────────────────────────────────
  // PUT /api/users
  // Body: { userId, name, email, role }
  // TODO: implementar endpoint no backend
  Future<String?> updateUser({
    required int userId,
    required String name,
    required String email,
    required UserRole role,
  }) async {
    try {
      final res = await http
          .put(
            Uri.parse('$_baseUrl/users'),
            headers: _headers,
            body: jsonEncode({
              'userId': userId,
              'name': name,
              'email': email,
              'role': role.value,
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        _updateSupported = true;
        await fetchUsers();
        return null;
      } else if (res.statusCode == 404 || res.statusCode == 405) {
        _updateSupported = false;
        return 'Edição de usuários ainda não disponível no servidor.';
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>?;
      return body?['message'] as String? ??
          'Erro ao atualizar usuário (${res.statusCode}).';
    } catch (_) {
      return 'Sem conexão com o servidor.';
    }
  }

  // ── Delete ────────────────────────────────────────────
  // DELETE /api/users/{userId}
  // TODO: implementar endpoint no backend
  Future<String?> deleteUser(int userId) async {
    try {
      final res = await http
          .delete(
            Uri.parse('$_baseUrl/users/$userId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 || res.statusCode == 204) {
        _users.removeWhere((u) => u.id == userId);
        notifyListeners();
        return null;
      } else if (res.statusCode == 404 || res.statusCode == 405) {
        return 'Exclusão de usuários ainda não disponível no servidor.';
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>?;
      return body?['message'] as String? ??
          'Erro ao remover usuário (${res.statusCode}).';
    } catch (_) {
      return 'Sem conexão com o servidor.';
    }
  }
}
