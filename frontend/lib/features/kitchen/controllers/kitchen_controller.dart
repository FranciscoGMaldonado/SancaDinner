import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/kitchen_models.dart';

class KitchenController extends ChangeNotifier {
  static const String _baseUrl = 'http://host.docker.internal:8080/api';
  static const Duration _pollInterval = Duration(seconds: 15);

  final String token;
  KitchenController({required this.token});

  // ── State ─────────────────────────────────────────────
  List<KitchenOrder> _orders = [];
  List<KitchenOrder> get orders => _orders;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  DateTime? _lastUpdated;
  DateTime? get lastUpdated => _lastUpdated;

  Timer? _timer;

  // ── Filtered views ────────────────────────────────────
  List<KitchenOrder> get pendingOrders => _orders
      .where((o) => o.status == OrderStatus.active && o.pendingCount > 0)
      .toList();

  List<KitchenOrder> get readyOrders => _orders
      .where((o) => o.status == OrderStatus.active && o.allReady)
      .toList();

  // ── Lifecycle ─────────────────────────────────────────
  void startPolling() {
    fetchOrders();
    _timer = Timer.periodic(_pollInterval, (_) => fetchOrders());
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // ── Fetch orders ──────────────────────────────────────
  Future<void> fetchOrders() async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/orders/active'),
        headers: _headers,
      ).timeout(const Duration(seconds: 10));

      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List<dynamic>;
        _orders = list
            .map((e) => KitchenOrder.fromJson(e as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.id.compareTo(b.id));
        _lastUpdated = DateTime.now();
      } else {
        _error = 'Erro ao carregar pedidos (${res.statusCode}).';
      }
    } catch (_) {
      _error = 'Sem conexão com o servidor.';
    }

    _loading = false;
    notifyListeners();
  }

  // ── Progress item ─────────────────────────────────────
  // POST /api/orders/order_items/progress
  // Body: { orderId, orderItemId }
  final Set<int> _updatingItems = {};
  bool isUpdating(int itemId) => _updatingItems.contains(itemId);

  Future<void> progressItem(int orderId, int itemId) async {
    _updatingItems.add(itemId);
    notifyListeners();

    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/orders/order_items/progress'),
        headers: _headers,
        body: jsonEncode({
          'orderId': orderId,
          'orderItemId': itemId,
        }),
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200 || res.statusCode == 201) {
        final idx = _orders.indexWhere((o) => o.id == orderId);
        if (idx >= 0) {
          final item = _orders[idx].items.firstWhere((i) => i.id == itemId);
          final next = item.status.next;
          if (next != null) {
            _orders[idx] = _orders[idx].withUpdatedItem(itemId, next);
          }
        }
      }
    } catch (_) {}

    _updatingItems.remove(itemId);
    notifyListeners();
  }

  // ── Cancel item ───────────────────────────────────────
  // DELETE /api/orders/order_items
  // Body: { orderId, orderItemId }
  Future<void> cancelItem(int orderId, int itemId) async {
    _updatingItems.add(itemId);
    notifyListeners();

    try {
      final res = await http.delete(
        Uri.parse('$_baseUrl/orders/order_items'),
        headers: _headers,
        body: jsonEncode({
          'orderId': orderId,
          'orderItemId': itemId,
        }),
      ).timeout(const Duration(seconds: 8));

      if (res.statusCode == 200 || res.statusCode == 201) {
        final idx = _orders.indexWhere((o) => o.id == orderId);
        if (idx >= 0) {
          _orders[idx] =
              _orders[idx].withUpdatedItem(itemId, OrderItemStatus.canceled);
        }
      }
    } catch (_) {}

    _updatingItems.remove(itemId);
    notifyListeners();
  }
}
