import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/logout_button.dart';
import '../controllers/kitchen_controller.dart';
import '../models/kitchen_models.dart';
import 'kitchen_order_card.dart';

class KitchenScreen extends StatefulWidget {
  const KitchenScreen({super.key});

  @override
  State<KitchenScreen> createState() => _KitchenScreenState();
}

class _KitchenScreenState extends State<KitchenScreen> {
  static const _bgColor = Color(0xFF0F0D0A);
  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _accentColor = Color(0xFFD4552A);
  static const _textMuted = Color(0xFF7A7570);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KitchenController>().startPolling();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<KitchenController>();

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: _buildAppBar(ctrl),
      body: _buildBody(ctrl),
    );
  }

  PreferredSizeWidget _buildAppBar(KitchenController ctrl) {
    return AppBar(
      backgroundColor: _surfaceColor,
      elevation: 0,
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: _borderColor,
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: _accentColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(
            Icons.dinner_dining,
            color: Colors.white,
            size: 16,
          ),
        ),
      ),
      leadingWidth: 52,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Painel da Cozinha',
            style: TextStyle(
              fontSize: 11,
              color: _textMuted,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const Text(
            'Pedidos',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: [
        if (ctrl.lastUpdated != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                'Atualizado às ${_formatTime(ctrl.lastUpdated!)}',
                style: const TextStyle(
                  color: _textMuted,
                  fontSize: 12,
                ),
              ),
            ),
          ),

        IconButton(
          tooltip: 'Atualizar',
          onPressed: ctrl.loading ? null : ctrl.fetchOrders,
          icon: ctrl.loading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _accentColor,
                  ),
                )
              : const Icon(
                  Icons.refresh_rounded,
                  color: _textMuted,
                  size: 20,
                ),
        ),

        const LogoutButton(),

        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBody(KitchenController ctrl) {
    if (ctrl.loading && ctrl.orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: _accentColor,
              strokeWidth: 2,
            ),
            SizedBox(height: 16),
            Text(
              'Carregando pedidos…',
              style: TextStyle(
                color: _textMuted,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (ctrl.error != null && ctrl.orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              color: _textMuted,
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              ctrl.error!,
              style: const TextStyle(
                color: _textMuted,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: ctrl.fetchOrders,
              child: const Text(
                'Tentar novamente',
                style: TextStyle(color: _accentColor),
              ),
            ),
          ],
        ),
      );
    }

    if (ctrl.orders.isEmpty) {
      return _buildEmptyState();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _KanbanColumn(
          title: 'Em preparo',
          count: ctrl.pendingOrders.length,
          color: const Color(0xFFE8A020),
          orders: ctrl.pendingOrders,
        ),

        Container(
          width: 1,
          color: _borderColor,
        ),

        _KanbanColumn(
          title: 'Pronto para entregar',
          count: ctrl.readyOrders.length,
          color: const Color(0xFF4CAF50),
          orders: ctrl.readyOrders,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF4CAF50),
              size: 32,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Nenhum pedido no momento',
            style: TextStyle(
              fontFamily: 'Georgia',
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Os pedidos enviados pelo atendimento\naparecerão aqui automaticamente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _textMuted,
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ── Kanban Column ───────────────────────────────────────────────────────────

class _KanbanColumn extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final List<KitchenOrder> orders;

  const _KanbanColumn({
    required this.title,
    required this.count,
    required this.color,
    required this.orders,
  });

  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            color: _surfaceColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 1,
            color: _borderColor,
          ),

          Expanded(
            child: orders.isEmpty
                ? Center(
                    child: Text(
                      'Nenhum pedido aqui',
                      style: TextStyle(
                        color: _textMuted,
                        fontSize: 13,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: orders.length,
                    itemBuilder: (_, i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: KitchenOrderCard(
                          order: orders[i],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}