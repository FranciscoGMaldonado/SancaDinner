import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/kitchen_controller.dart';
import '../models/kitchen_models.dart';

class KitchenOrderCard extends StatelessWidget {
  final KitchenOrder order;
  const KitchenOrderCard({super.key, required this.order});

  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);
  static const _accentColor = Color(0xFFD4552A);

  @override
  Widget build(BuildContext context) {
    final allReady = order.allReady;

    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: allReady
              ? const Color(0xFF4CAF50).withOpacity(0.5)
              : _borderColor,
          width: allReady ? 1.5 : 1,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1, color: _borderColor),
          ...order.items.map((item) => _ItemRow(orderId: order.id, item: item)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          // Número do pedido
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _accentColor.withOpacity(0.3)),
            ),
            child: Text(
              '#${order.id}',
              style: const TextStyle(
                color: _accentColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Cliente + mesa
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customerName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.table_restaurant_outlined,
                        size: 12, color: _textMuted),
                    const SizedBox(width: 4),
                    Text(
                      'Mesa ${order.tableNumber}',
                      style: const TextStyle(color: _textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Progresso
          _ProgressBadge(order: order),
        ],
      ),
    );
  }
}

// ── Progress Badge ──────────────────────────────────────────────────────────

class _ProgressBadge extends StatelessWidget {
  final KitchenOrder order;
  const _ProgressBadge({required this.order});

  @override
  Widget build(BuildContext context) {
    final total = order.items.length;
    final done = order.items
        .where((i) =>
            i.status == OrderItemStatus.finished ||
            i.status == OrderItemStatus.delivered)
        .length;

    final color = done == total
        ? const Color(0xFF4CAF50)
        : done > 0
            ? const Color(0xFFE8A020)
            : const Color(0xFF7A7570);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '$done/$total',
        style: TextStyle(
            color: color, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}

// ── Item Row ────────────────────────────────────────────────────────────────

class _ItemRow extends StatelessWidget {
  final int orderId;
  final KitchenOrderItem item;
  const _ItemRow({required this.orderId, required this.item});

  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  Color get _statusColor {
    switch (item.status) {
      case OrderItemStatus.pending:
        return const Color(0xFFE8A020);
      case OrderItemStatus.finished:
        return const Color(0xFF4CAF50);
      case OrderItemStatus.delivered:
        return const Color(0xFF5090D0);
      case OrderItemStatus.canceled:
        return const Color(0xFF7A7570);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<KitchenController>();
    final updating = ctrl.isUpdating(item.id);
    final isCanceled = item.status == OrderItemStatus.canceled;
    final nextStatus = item.status.next;

    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _borderColor, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          // Status dot
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 10, top: 2),
            decoration: BoxDecoration(
              color: isCanceled ? Colors.transparent : _statusColor,
              shape: BoxShape.circle,
              border: isCanceled
                  ? Border.all(color: _statusColor, width: 1.5)
                  : null,
            ),
          ),
          // Nome + especificação
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    color: isCanceled
                        ? _textMuted
                        : Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    decoration: isCanceled
                        ? TextDecoration.lineThrough
                        : null,
                    decorationColor: _textMuted,
                  ),
                ),
                if (item.specification != null &&
                    item.specification!.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.notes_rounded,
                          size: 11, color: Color(0xFFE8A020)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          item.specification!,
                          style: const TextStyle(
                              color: Color(0xFFE8A020), fontSize: 11),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Ações
          if (updating)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFFD4552A),
              ),
            )
          else if (!isCanceled) ...[
            // Botão cancelar
            if (item.status == OrderItemStatus.pending)
              GestureDetector(
                onTap: () => _confirmCancel(context, ctrl),
                child: Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: _borderColor),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.close_rounded,
                      size: 14, color: Color(0xFF7A7570)),
                ),
              ),
            // Botão avançar status
            if (nextStatus != null)
              GestureDetector(
                onTap: () => ctrl.progressItem(orderId, item.id),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: _statusColor.withOpacity(0.4)),
                  ),
                  child: Text(
                    item.status.nextLabel,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ] else
            Text(
              'Cancelado',
              style: TextStyle(color: _textMuted, fontSize: 11),
            ),
        ],
      ),
    );
  }

  void _confirmCancel(BuildContext context, KitchenController ctrl) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1714),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF2E2A25)),
        ),
        title: const Text(
          'Cancelar item?',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Text(
          'Deseja cancelar "${item.productName}"?',
          style: const TextStyle(color: Color(0xFF7A7570), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Não',
                style: TextStyle(color: Color(0xFF7A7570))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ctrl.cancelItem(orderId, item.id);
            },
            child: const Text('Cancelar item',
                style: TextStyle(color: Color(0xFFD4552A))),
          ),
        ],
      ),
    );
  }
}
