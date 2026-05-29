import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/admin_product_controller.dart';
import '../models/admin_models.dart';

class AdminProductsScreen extends StatefulWidget {
  const AdminProductsScreen({super.key});

  @override
  State<AdminProductsScreen> createState() => _AdminProductsScreenState();
}

class _AdminProductsScreenState extends State<AdminProductsScreen> {
  static const _accentColor = Color(0xFFD4552A);
  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminProductController>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AdminProductController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0D0A),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(context),
        backgroundColor: _accentColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _buildBody(ctrl),
    );
  }

  Widget _buildBody(AdminProductController ctrl) {
    if (ctrl.loading && ctrl.products.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
            color: Color(0xFFD4552A), strokeWidth: 2),
      );
    }

    if (ctrl.error != null && ctrl.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                color: Color(0xFF7A7570), size: 40),
            const SizedBox(height: 16),
            Text(ctrl.error!,
                style:
                    const TextStyle(color: Color(0xFF7A7570), fontSize: 14)),
            const SizedBox(height: 20),
            TextButton(
              onPressed: ctrl.fetchProducts,
              child: const Text('Tentar novamente',
                  style: TextStyle(color: Color(0xFFD4552A))),
            ),
          ],
        ),
      );
    }

    if (ctrl.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fastfood_outlined,
                color: Color(0xFF7A7570), size: 40),
            const SizedBox(height: 16),
            const Text('Nenhum produto cadastrado.',
                style:
                    TextStyle(color: Color(0xFF7A7570), fontSize: 14)),
            const SizedBox(height: 8),
            const Text('Toque em + para adicionar.',
                style:
                    TextStyle(color: Color(0xFF5A5550), fontSize: 13)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: ctrl.products.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _ProductTile(product: ctrl.products[i]),
    );
  }

  void _showProductDialog(BuildContext context, {AdminProduct? product}) {
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<AdminProductController>(),
        child: _ProductDialog(product: product),
      ),
    );
  }
}

// ── Product Tile ─────────────────────────────────────────────────────────────

class _ProductTile extends StatelessWidget {
  final AdminProduct product;
  const _ProductTile({required this.product});

  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);
  static const _accentColor = Color(0xFFD4552A);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<AdminProductController>();

    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(color: _textMuted, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              product.formattedPrice,
              style: const TextStyle(
                  color: _accentColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 12),
            // Editar
            _IconBtn(
              icon: Icons.edit_outlined,
              color: const Color(0xFF7A7570),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => ChangeNotifierProvider.value(
                    value: ctrl,
                    child: _ProductDialog(product: product),
                  ),
                );
              },
            ),
            const SizedBox(width: 6),
            // Excluir
            _IconBtn(
              icon: Icons.delete_outline_rounded,
              color: _accentColor,
              onTap: () => _confirmDelete(context, ctrl),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, AdminProductController ctrl) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1714),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF2E2A25)),
        ),
        title: const Text('Excluir produto?',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Text(
          'Deseja excluir "${product.name}"?',
          style: const TextStyle(color: Color(0xFF7A7570), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: Color(0xFF7A7570))),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final err = await ctrl.deleteProduct(product.id);
              if (err != null && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(err),
                      backgroundColor: const Color(0xFFD4552A)),
                );
              }
            },
            child: const Text('Excluir',
                style: TextStyle(color: Color(0xFFD4552A))),
          ),
        ],
      ),
    );
  }
}

// ── Product Dialog (create / edit) ───────────────────────────────────────────

class _ProductDialog extends StatefulWidget {
  final AdminProduct? product;
  const _ProductDialog({this.product});

  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _descCtrl;
  bool _saving = false;
  String? _error;

  static const _accentColor = Color(0xFFD4552A);
  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  bool get _isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl =
        TextEditingController(text: widget.product?.name ?? '');
    _priceCtrl = TextEditingController(
        text: widget.product != null
            ? widget.product!.price.toStringAsFixed(2)
            : '');
    _descCtrl =
        TextEditingController(text: widget.product?.description ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });

    final ctrl = context.read<AdminProductController>();
    final price =
        double.parse(_priceCtrl.text.trim().replaceAll(',', '.'));

    String? err;
    if (_isEdit) {
      err = await ctrl.updateProduct(
        productId: widget.product!.id,
        name: _nameCtrl.text.trim(),
        price: price,
        description: _descCtrl.text.trim(),
      );
    } else {
      err = await ctrl.createProduct(
        name: _nameCtrl.text.trim(),
        price: price,
        description: _descCtrl.text.trim(),
      );
    }

    if (!mounted) return;
    if (err == null) {
      Navigator.pop(context);
    } else {
      setState(() {
        _saving = false;
        _error = err;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: _borderColor),
      ),
      title: Text(
        _isEdit ? 'Editar produto' : 'Novo produto',
        style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600),
      ),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField(
                controller: _nameCtrl,
                label: 'Nome',
                hint: 'Ex: X-Burguer',
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Informe o nome.' : null,
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _priceCtrl,
                label: 'Preço',
                hint: 'Ex: 29.90',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Informe o preço.';
                  final n = double.tryParse(v.replaceAll(',', '.'));
                  if (n == null || n <= 0) return 'Preço inválido.';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _descCtrl,
                label: 'Descrição',
                hint: 'Ex: Pão, carne, queijo...',
                maxLines: 2,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Informe a descrição.'
                    : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A1010),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF5A2020)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline,
                          size: 16, color: Color(0xFFFF6B6B)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(_error!,
                            style: const TextStyle(
                                color: Color(0xFFFF6B6B),
                                fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar',
              style: TextStyle(color: _textMuted)),
        ),
        ElevatedButton(
          onPressed: _saving ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: _accentColor,
            disabledBackgroundColor: _accentColor.withOpacity(0.5),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                )
              : Text(_isEdit ? 'Salvar' : 'Criar'),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFFB0AA9F),
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(color: _textMuted, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFF0F0D0A),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 12),
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
              borderSide:
                  const BorderSide(color: _accentColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: Colors.redAccent.shade200, width: 1),
            ),
            errorStyle: TextStyle(
                color: Colors.redAccent.shade200, fontSize: 11),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

// ── Icon Button ───────────────────────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _IconBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF2E2A25)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}
