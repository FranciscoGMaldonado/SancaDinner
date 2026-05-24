import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/comanda_controller.dart';
import 'comanda_customer_step.dart';
import 'comanda_items_step.dart';
import 'comanda_review_step.dart';
import 'comanda_success_screen.dart';

class ComandaScreen extends StatelessWidget {
  const ComandaScreen({super.key});

  static const _accentColor = Color(0xFFD4552A);
  static const _bgColor = Color(0xFF0F0D0A);
  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ComandaController>();

    if (ctrl.submitted) {
      return const ComandaSuccessScreen();
    }

    return Scaffold(
      backgroundColor: _bgColor,
      appBar: _buildAppBar(context, ctrl),
      body: Column(
        children: [
          _StepIndicator(current: ctrl.step),
          Expanded(child: _buildBody(ctrl)),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ComandaController ctrl) {
    // Determina se há navegação para trás possível
    final canGoBack = ctrl.step != ComandaStep.customerInfo;

    return AppBar(
      backgroundColor: _surfaceColor,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: _borderColor),
      ),
      leading: canGoBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
              onPressed: () {
                if (ctrl.step == ComandaStep.addItems) {
                  ctrl.goTo(ComandaStep.customerInfo);
                } else if (ctrl.step == ComandaStep.review) {
                  ctrl.goTo(ComandaStep.addItems);
                }
              },
            )
          : Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _accentColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.dinner_dining,
                        color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
      leadingWidth: 52,
      title: const Text(
        'Nova Comanda',
        style: TextStyle(
          fontFamily: 'Georgia',
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
      actions: [
        if (ctrl.totalItems > 0 && ctrl.step == ComandaStep.addItems)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _CartBadge(count: ctrl.totalItems, total: ctrl.formattedTotal),
          ),
      ],
    );
  }

  Widget _buildBody(ComandaController ctrl) {
    switch (ctrl.step) {
      case ComandaStep.customerInfo:
        return const ComandaCustomerStep();
      case ComandaStep.addItems:
        return const ComandaItemsStep();
      case ComandaStep.review:
        return const ComandaReviewStep();
    }
  }
}

// ── Step Indicator ──────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  final ComandaStep current;
  const _StepIndicator({required this.current});

  static const _accentColor = Color(0xFFD4552A);
  static const _borderColor = Color(0xFF2E2A25);
  static const _surfaceColor = Color(0xFF1A1714);

  int get _currentIndex => ComandaStep.values.indexOf(current);

  @override
  Widget build(BuildContext context) {
    const labels = ['Cliente', 'Itens', 'Revisão'];
    return Container(
      color: _surfaceColor,
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Row(
            children: List.generate(3, (i) {
              final done = i < _currentIndex;
              final active = i == _currentIndex;
              return Expanded(
                child: Row(
                  children: [
                    _StepDot(
                        index: i + 1,
                        done: done,
                        active: active,
                        label: labels[i]),
                    if (i < 2)
                      Expanded(
                        child: Container(
                          height: 1,
                          color: done ? _accentColor : _borderColor,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int index;
  final bool done;
  final bool active;
  final String label;

  const _StepDot({
    required this.index,
    required this.done,
    required this.active,
    required this.label,
  });

  static const _accentColor = Color(0xFFD4552A);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done || active ? _accentColor : Colors.transparent,
            border: Border.all(
              color: done || active ? _accentColor : _borderColor,
              width: 1.5,
            ),
          ),
          child: Center(
            child: done
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    '$index',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : _textMuted,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: active ? Colors.white : _textMuted,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// ── Cart Badge ──────────────────────────────────────────────────────────────

class _CartBadge extends StatelessWidget {
  final int count;
  final String total;
  const _CartBadge({required this.count, required this.total});

  static const _accentColor = Color(0xFFD4552A);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _accentColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _accentColor.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.receipt_long_outlined, size: 14, color: _accentColor),
          const SizedBox(width: 6),
          Text(
            '$count  ·  $total',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _accentColor,
            ),
          ),
        ],
      ),
    );
  }
}