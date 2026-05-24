import 'product_model.dart';

class OrderItemDraft {
  final ProductModel product;
  final int quantity;
  final String specification;

  const OrderItemDraft({
    required this.product,
    required this.quantity,
    this.specification = '',
  });

  OrderItemDraft copyWith({
    ProductModel? product,
    int? quantity,
    String? specification,
  }) {
    return OrderItemDraft(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      specification: specification ?? this.specification,
    );
  }

  double get subtotal => product.price * quantity;
}
