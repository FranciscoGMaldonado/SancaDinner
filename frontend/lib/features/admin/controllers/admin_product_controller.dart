import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/admin_models.dart';

class AdminProductController extends ChangeNotifier {
  static const String _baseUrl = 'http://localhost:8080/api/products';

  final String token;
  AdminProductController({required this.token});

  List<AdminProduct> _products = [];
  List<AdminProduct> get products => _products;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // ── Fetch all ─────────────────────────────────────────
  Future<void> fetchProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await http
          .get(Uri.parse(_baseUrl), headers: _headers)
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        _products = list
            .map((e) => AdminProduct.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _error = 'Erro ao carregar produtos (${res.statusCode}).';
      }
    } catch (_) {
      _error = 'Sem conexão com o servidor.';
    }
    _loading = false;
    notifyListeners();
  }

  // ── Create ────────────────────────────────────────────
  // POST /api/products
  // Body: { name, price, description }
  Future<String?> createProduct({
    required String name,
    required double price,
    required String description,
  }) async {
    try {
      final res = await http
          .post(
            Uri.parse(_baseUrl),
            headers: _headers,
            body: jsonEncode({
              'name': name,
              'price': price,
              'description': description,
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 201 || res.statusCode == 200) {
        await fetchProducts();
        return null;
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>?;
      return body?['message'] as String? ??
          'Erro ao criar produto (${res.statusCode}).';
    } catch (_) {
      return 'Sem conexão com o servidor.';
    }
  }

  // ── Update ────────────────────────────────────────────
  // PUT /api/products
  // Body: { productId, name, price, description }
  Future<String?> updateProduct({
    required int productId,
    required String name,
    required double price,
    required String description,
  }) async {
    try {
      final res = await http
          .put(
            Uri.parse(_baseUrl),
            headers: _headers,
            body: jsonEncode({
              'productId': productId,
              'name': name,
              'price': price,
              'description': description,
            }),
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        await fetchProducts();
        return null;
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>?;
      return body?['message'] as String? ??
          'Erro ao atualizar produto (${res.statusCode}).';
    } catch (_) {
      return 'Sem conexão com o servidor.';
    }
  }

  // ── Delete ────────────────────────────────────────────
  // DELETE /api/products/{productId}
  Future<String?> deleteProduct(int productId) async {
    try {
      final res = await http
          .delete(
            Uri.parse('$_baseUrl/$productId'),
            headers: _headers,
          )
          .timeout(const Duration(seconds: 10));
      if (res.statusCode == 200 || res.statusCode == 204) {
        _products.removeWhere((p) => p.id == productId);
        notifyListeners();
        return null;
      }
      final body = jsonDecode(res.body) as Map<String, dynamic>?;
      return body?['message'] as String? ??
          'Erro ao remover produto (${res.statusCode}).';
    } catch (_) {
      return 'Sem conexão com o servidor.';
    }
  }
}
