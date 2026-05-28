enum OrderItemStatus { pending, finished, delivered, canceled }

enum OrderStatus { active, finished }

extension OrderItemStatusX on OrderItemStatus {
  String get label {
    switch (this) {
      case OrderItemStatus.pending:   return 'Pendente';
      case OrderItemStatus.finished:  return 'Pronto';
      case OrderItemStatus.delivered: return 'Entregue';
      case OrderItemStatus.canceled:  return 'Cancelado';
    }
  }

  static OrderItemStatus fromString(String s) {
    switch (s.toUpperCase()) {
      case 'PENDING':   return OrderItemStatus.pending;
      case 'FINISHED':  return OrderItemStatus.finished;
      case 'DELIVERED': return OrderItemStatus.delivered;
      case 'CANCELED':  return OrderItemStatus.canceled;
      default:          return OrderItemStatus.pending;
    }
  }

  OrderItemStatus? get next {
    switch (this) {
      case OrderItemStatus.pending:  return OrderItemStatus.finished;
      case OrderItemStatus.finished: return OrderItemStatus.delivered;
      default: return null;
    }
  }

  String get nextLabel {
    switch (this) {
      case OrderItemStatus.pending:  return 'Marcar como pronto';
      case OrderItemStatus.finished: return 'Marcar como entregue';
      default: return '';
    }
  }
}

class KitchenOrderItem {
  final int id;
  final int productId;
  final String productName;
  final double productPrice;
  final String? specification;
  final OrderItemStatus status;

  const KitchenOrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productPrice,
    this.specification,
    required this.status,
  });

  factory KitchenOrderItem.fromJson(Map<String, dynamic> json) {
    final productId = json['productId'] as int;
    return KitchenOrderItem(
      id: json['id'] as int,
      productId: productId,
      productName: 'Produto #$productId', // TODO: resolver nome via productId
      productPrice: (json['productPrice'] as num).toDouble(),
      specification: json['specification'] as String?,
      status: OrderItemStatusX.fromString(
          json['orderItemStatus'] as String? ?? 'PENDING'),
    );
  }

  KitchenOrderItem copyWith({OrderItemStatus? status}) {
    return KitchenOrderItem(
      id: id,
      productId: productId,
      productName: productName,
      productPrice: productPrice,
      specification: specification,
      status: status ?? this.status,
    );
  }
}

class KitchenOrder {
  final int id;
  final String customerName;
  final int tableNumber;
  final OrderStatus status;
  final List<KitchenOrderItem> items;

  const KitchenOrder({
    required this.id,
    required this.customerName,
    required this.tableNumber,
    required this.status,
    required this.items,
  });

  factory KitchenOrder.fromJson(Map<String, dynamic> json) {
    final rawItems = json['orderItems'] as List<dynamic>? ?? [];
    return KitchenOrder(
      id: json['id'] as int,
      customerName: json['customerName'] as String,
      tableNumber: json['tableNumber'] as int,
      status: (json['orderStatus'] as String?) == 'FINISHED'
          ? OrderStatus.finished
          : OrderStatus.active,
      items: rawItems
          .map((e) => KitchenOrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  int get pendingCount =>
      items.where((i) => i.status == OrderItemStatus.pending).length;

  bool get allDelivered =>
      items.isNotEmpty &&
      items.every((i) =>
          i.status == OrderItemStatus.delivered ||
          i.status == OrderItemStatus.canceled);

  bool get allReady =>
      items.isNotEmpty &&
      items.every((i) =>
          i.status == OrderItemStatus.finished ||
          i.status == OrderItemStatus.delivered ||
          i.status == OrderItemStatus.canceled);

  KitchenOrder withUpdatedItem(int itemId, OrderItemStatus newStatus) {
    return KitchenOrder(
      id: id,
      customerName: customerName,
      tableNumber: tableNumber,
      status: status,
      items: items
          .map((i) => i.id == itemId ? i.copyWith(status: newStatus) : i)
          .toList(),
    );
  }
}
