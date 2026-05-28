import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/order_controller.dart';

class OrderCustomerStep extends StatefulWidget {
  const OrderCustomerStep({super.key});

  @override
  State<OrderCustomerStep> createState() => _OrderCustomerStepState();
}

class _OrderCustomerStepState extends State<OrderCustomerStep>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _tableCtrl;
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  static const _accentColor = Color(0xFFD4552A);
  static const _bgColor = Color(0xFF0F0D0A);
  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  @override
  void initState() {
    super.initState();
    final ctrl = context.read<OrderController>();
    _nameCtrl = TextEditingController(text: ctrl.customerName);
    _tableCtrl = TextEditingController(
        text: ctrl.tableNumber != null ? ctrl.tableNumber.toString() : '');

    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    _nameCtrl.dispose();
    _tableCtrl.dispose();
    super.dispose();
  }

  void _proceed() {
    if (!_formKey.currentState!.validate()) return;
    final ctrl = context.read<OrderController>();
    ctrl.customerName = _nameCtrl.text.trim();
    ctrl.tableNumber = int.tryParse(_tableCtrl.text.trim());
    ctrl.fetchProducts();
    ctrl.goTo(OrderStep.addItems);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 460),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildLabel('Nome do cliente'),
                    const SizedBox(height: 8),
                    _buildNameField(),
                    const SizedBox(height: 24),
                    _buildLabel('Número da mesa'),
                    const SizedBox(height: 8),
                    _buildTableField(),
                    const SizedBox(height: 40),
                    _buildNextButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _accentColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: _accentColor.withOpacity(0.3)),
          ),
          child: const Icon(Icons.person_outline_rounded, color: _accentColor, size: 22),
        ),
        const SizedBox(height: 16),
        const Text(
          'Dados do Cliente',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontSize: 26,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Informe o nome e a mesa para iniciar a comanda.',
          style: TextStyle(fontSize: 14, color: _textMuted, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFFB0AA9F),
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameCtrl,
      textCapitalization: TextCapitalization.words,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: _inputDecoration(
        hint: 'Ex: João Silva',
        icon: Icons.badge_outlined,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Informe o nome do cliente.';
        return null;
      },
      onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
    );
  }

  Widget _buildTableField() {
    return TextFormField(
      controller: _tableCtrl,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: _inputDecoration(
        hint: 'Ex: 5',
        icon: Icons.table_restaurant_outlined,
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Informe o número da mesa.';
        final n = int.tryParse(v);
        if (n == null || n < 0) return 'Número de mesa inválido.';
        return null;
      },
      onFieldSubmitted: (_) => _proceed(),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: _textMuted, fontSize: 14),
      prefixIcon: Icon(icon, size: 18, color: _textMuted),
      filled: true,
      fillColor: _surfaceColor,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _accentColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.redAccent.shade200, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.redAccent.shade200, width: 1.5),
      ),
      errorStyle: TextStyle(color: Colors.redAccent.shade200, fontSize: 12),
    );
  }

  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _proceed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selecionar itens',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.3),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
