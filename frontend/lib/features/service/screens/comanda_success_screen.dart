import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/comanda_controller.dart';

class ComandaSuccessScreen extends StatefulWidget {
  const ComandaSuccessScreen({super.key});

  @override
  State<ComandaSuccessScreen> createState() => _ComandaSuccessScreenState();
}

class _ComandaSuccessScreenState extends State<ComandaSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;
  late Animation<double> _scale;
  late Animation<double> _fade;

  static const _accentColor = Color(0xFFD4552A);
  static const _bgColor = Color(0xFF0F0D0A);
  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scale = Tween<double>(begin: 0.6, end: 1.0).animate(
        CurvedAnimation(parent: _anim, curve: Curves.elasticOut));
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

    return Scaffold(
      backgroundColor: _bgColor,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _scale,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D2A0D),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF1A5A1A), width: 2),
                    ),
                    child: const Icon(Icons.check_rounded,
                        color: Color(0xFF4CAF50), size: 40),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Comanda enviada!',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  ctrl.createdOrderId != null
                      ? 'Pedido #${ctrl.createdOrderId} registrado e\nenviado para a cozinha com sucesso.'
                      : 'Pedido registrado e enviado\npara a cozinha com sucesso.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: _textMuted, fontSize: 15, height: 1.6),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _surfaceColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _borderColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person_outline_rounded,
                          size: 16, color: _textMuted),
                      const SizedBox(width: 8),
                      Text(
                        ctrl.customerName,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                            width: 1, height: 16, color: _borderColor),
                      ),
                      Icon(Icons.table_restaurant_outlined,
                          size: 16, color: _textMuted),
                      const SizedBox(width: 8),
                      Text(
                        'Mesa ${ctrl.tableNumber}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => ctrl.reset(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _accentColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Nova comanda',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
