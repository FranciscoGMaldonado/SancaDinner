import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/order_item_draft.dart';

enum OrderStep { customerInfo, addItems, review }

class OrderController extends ChangeNotifier {
  static const String _baseUrl = 'http://localhost:8080/api';

  final String token;
  OrderController({required this.token});

  // ── Navigation ────────────────────────────────────────
  OrderStep _step = OrderStep.customerInfo;
  OrderStep get step => _step;

  void goTo(OrderStep s) {
    _step = s;
    notifyListeners();
  }

  // ── Customer Info ─────────────────────────────────────
  String customerName = '';
  int? tableNumber;

  bool get customerInfoValid =>
      customerName.trim().isNotEmpty && tableNumber != null && tableNumber! >= 0;

  // ── Products ──────────────────────────────────────────
  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _loadingProducts = false;
  bool get loadingProducts => _loadingProducts;

  String? _productsError;
  String? get productsError => _productsError;

  String _search = '';
  String get search => _search;

  void setSearch(String v) {
    _search = v;
    notifyListeners();
  }

  List<ProductModel> get filteredProducts {
    if (_search.isEmpty) return _products;
    final q = _search.toLowerCase();
    return _products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
  }

  Future<void> fetchProducts() async {
    _loadingProducts = true;
    _productsError = null;
    notifyListeners();
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/products'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        _products = list
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _productsError = 'Erro ao carregar produtos.';
      }
    } catch (_) {
      _productsError = 'Não foi possível conectar ao servidor.';
    }
    _loadingProducts = false;
    notifyListeners();
  }

  // ── Items / Order ───────────────────────────────────
  final List<OrderItemDraft> _items = [];
  List<OrderItemDraft> get items => List.unmodifiable(_items);

  bool isInCart(int productId) => _items.any((i) => i.product.id == productId);

  int quantityOf(int productId) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    return idx >= 0 ? _items[idx].quantity : 0;
  }

  void addItem(ProductModel product) {
    final idx = _items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      _items[idx] = _items[idx].copyWith(quantity: _items[idx].quantity + 1);
    } else {
      _items.add(OrderItemDraft(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(int productId) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx < 0) return;
    if (_items[idx].quantity > 1) {
      _items[idx] = _items[idx].copyWith(quantity: _items[idx].quantity - 1);
    } else {
      _items.removeAt(idx);
    }
    notifyListeners();
  }

  void removeItemFully(int productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  void updateSpecification(int productId, String spec) {
    final idx = _items.indexWhere((i) => i.product.id == productId);
    if (idx < 0) return;
    _items[idx] = _items[idx].copyWith(specification: spec);
    notifyListeners();
  }

  double get totalPrice => _items.fold(0.0, (acc, i) => acc + i.subtotal);

  String get formattedTotal =>
      'R\$ ${totalPrice.toStringAsFixed(2).replaceAll('.', ',')}';

  int get totalItems => _items.fold(0, (acc, i) => acc + i.quantity);

  // ── Submit ────────────────────────────────────────────
  // O backend separa criação da ordem e adição de itens:
  // 1. POST /api/orders         → { customerName, tableId }       → retorna orderId
  // 2. POST /api/orders/order_items (repetido por item+quantidade)
  //                             → { orderId, productId, specification }

  bool _submitting = false;
  bool get submitting => _submitting;

  String? _submitError;
  String? get submitError => _submitError;

  bool _submitted = false;
  bool get submitted => _submitted;

  int? _createdOrderId;
  int? get createdOrderId => _createdOrderId;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<bool> submitOrder() async {
    _submitting = true;
    _submitError = null;
    notifyListeners();

    try {
      // ── Passo 1: criar a ordem ─────────────────────────
      final orderRes = await http.post(
        Uri.parse('$_baseUrl/orders'),
        headers: _headers,
        body: jsonEncode({
          'customerName': customerName.trim(),
          'tableId': tableNumber,       // campo correto do backend
        }),
      );

      if (orderRes.statusCode != 201 && orderRes.statusCode != 200) {
        _submitError = 'Erro ao criar comanda. Tente novamente.';
        _submitting = false;
        notifyListeners();
        return false;
      }

      final orderData = jsonDecode(orderRes.body) as Map<String, dynamic>;
      final orderId = orderData['id'] as int;

      // ── Passo 2: adicionar itens (quantity × POST) ──────
      for (final item in _items) {
        for (int q = 0; q < item.quantity; q++) {
          final itemRes = await http.post(
            Uri.parse('$_baseUrl/orders/order_items'),
            headers: _headers,
            body: jsonEncode({
              'orderId': orderId,
              'productId': item.product.id,
              if (item.specification.isNotEmpty)
                'specification': item.specification,
            }),
          );

          if (itemRes.statusCode != 201 && itemRes.statusCode != 200) {
            _submitError = 'Erro ao adicionar item "${item.product.name}".';
            _submitting = false;
            notifyListeners();
            return false;
          }
        }
      }

      _createdOrderId = orderId;
      _submitted = true;
      _submitting = false;
      notifyListeners();
      return true;
    } on http.ClientException {
      _submitError = 'Sem conexão com o servidor.';
    } catch (_) {
      _submitError = 'Erro inesperado ao enviar comanda.';
    }

    _submitting = false;
    notifyListeners();
    return false;
  }

  // ── Reset ─────────────────────────────────────────────
  void reset() {
    _step = OrderStep.customerInfo;
    customerName = '';
    tableNumber = null;
    _items.clear();
    _submitted = false;
    _createdOrderId = null;
    _submitError = null;
    _search = '';
    notifyListeners();
  }
}
