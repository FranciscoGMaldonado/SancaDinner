import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/comanda_controller.dart';
import '../models/order_item_draft.dart';

class ComandaReviewStep extends StatefulWidget {
  const ComandaReviewStep({super.key});

  @override
  State<ComandaReviewStep> createState() => _ComandaReviewStepState();
}

class _ComandaReviewStepState extends State<ComandaReviewStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _fade;

  static const _accentColor = Color(0xFFD4552A);
  static const _bgColor = Color(0xFF0F0D0A);
  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ComandaController>();

    return FadeTransition(
      opacity: _fade,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoCard(ctrl),
                  const SizedBox(height: 20),
                  _buildItemsSection(ctrl),
                  if (ctrl.submitError != null) ...[
                    const SizedBox(height: 16),
                    _buildErrorBanner(ctrl.submitError!),
                  ],
                ],
              ),
            ),
          ),
          _buildActions(ctrl),
        ],
      ),
    );
  }

  Widget _buildInfoCard(ComandaController ctrl) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _accentColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.table_restaurant_outlined, color: _accentColor, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(ctrl.customerName,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text('Mesa ${ctrl.tableNumber}',
                  style: TextStyle(color: _textMuted, fontSize: 13)),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => ctrl.goTo(ComandaStep.customerInfo),
            child: Text('Editar', style: TextStyle(color: _accentColor, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsSection(ComandaController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Itens da comanda',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => ctrl.goTo(ComandaStep.addItems),
              child: Text('Editar', style: TextStyle(color: _accentColor, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...ctrl.items.map((item) => _ReviewItemRow(item: item)),
        const Divider(color: Color(0xFF2E2A25), height: 28),
        Row(
          children: [
            const Text('Total', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
            const Spacer(),
            Text(ctrl.formattedTotal,
                style: const TextStyle(color: Color(0xFFD4552A), fontSize: 18, fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }

  Widget _buildErrorBanner(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1010),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF5A2020)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFFF6B6B), size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(msg,
                style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(ComandaController ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        border: Border(top: BorderSide(color: _borderColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          OutlinedButton(
            onPressed: ctrl.submitting ? null : () => ctrl.goTo(ComandaStep.addItems),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF2E2A25)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
            child: const Text('Voltar', style: TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: ctrl.submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accentColor,
                  disabledBackgroundColor: _accentColor.withOpacity(0.5),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: ctrl.submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.send_rounded, size: 16),
                          SizedBox(width: 8),
                          Text('Enviar para a cozinha',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final ctrl = context.read<ComandaController>();
    await ctrl.submitOrder();
  }
}

// ── Review Item Row ─────────────────────────────────────────────────────────

class _ReviewItemRow extends StatefulWidget {
  final OrderItemDraft item;
  const _ReviewItemRow({required this.item});

  @override
  State<_ReviewItemRow> createState() => _ReviewItemRowState();
}

class _ReviewItemRowState extends State<_ReviewItemRow> {
  late TextEditingController _specCtrl;
  bool _expanded = false;

  static const _accentColor = Color(0xFFD4552A);
  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  @override
  void initState() {
    super.initState();
    _specCtrl = TextEditingController(text: widget.item.specification);
  }

  @override
  void dispose() {
    _specCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<ComandaController>();
    final subtotal =
        'R\$ ${widget.item.subtotal.toStringAsFixed(2).replaceAll('.', ',')}';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _borderColor),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: _accentColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        '${widget.item.quantity}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.item.product.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                        if (widget.item.specification.isNotEmpty)
                          Text(
                            widget.item.specification,
                            style: TextStyle(color: _textMuted, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Text(subtotal,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => setState(() => _expanded = !_expanded),
                    child: Icon(
                      _expanded ? Icons.expand_less : Icons.expand_more,
                      color: _textMuted,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => ctrl.removeItemFully(widget.item.product.id),
                    child: const Icon(Icons.close_rounded,
                        color: Color(0xFF5A5550), size: 16),
                  ),
                ],
              ),
            ),
            if (_expanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: TextField(
                  controller: _specCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  onChanged: (v) =>
                      ctrl.updateSpecification(widget.item.product.id, v),
                  decoration: InputDecoration(
                    hintText: 'Observação (sem cebola, mal passado…)',
                    hintStyle: TextStyle(color: _textMuted, fontSize: 12),
                    filled: true,
                    fillColor: const Color(0xFF0F0D0A),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: _borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: _borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide:
                          const BorderSide(color: _accentColor, width: 1.5),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
