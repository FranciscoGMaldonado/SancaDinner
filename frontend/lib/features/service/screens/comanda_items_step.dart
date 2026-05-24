import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/comanda_controller.dart';
import '../models/product_model.dart';

class ComandaItemsStep extends StatefulWidget {
  const ComandaItemsStep({super.key});

  @override
  State<ComandaItemsStep> createState() => _ComandaItemsStepState();
}

class _ComandaItemsStepState extends State<ComandaItemsStep>
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
          _buildSearchBar(ctrl),
          Expanded(child: _buildProductArea(ctrl)),
          if (ctrl.totalItems > 0) _buildBottomBar(ctrl),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ComandaController ctrl) {
    return Container(
      color: _surfaceColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: ctrl.setSearch,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Buscar produto…',
                hintStyle: TextStyle(color: _textMuted, fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: _textMuted, size: 20),
                filled: true,
                fillColor: _bgColor,
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${ctrl.filteredProducts.length} produto${ctrl.filteredProducts.length != 1 ? 's' : ''}',
            style: TextStyle(fontSize: 12, color: _textMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildProductArea(ComandaController ctrl) {
    if (ctrl.loadingProducts) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFFD4552A), strokeWidth: 2),
            SizedBox(height: 16),
            Text('Carregando cardápio…',
                style: TextStyle(color: Color(0xFF7A7570), fontSize: 14)),
          ],
        ),
      );
    }

    if (ctrl.productsError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, color: Color(0xFF7A7570), size: 40),
            const SizedBox(height: 16),
            Text(ctrl.productsError!,
                style: const TextStyle(color: Color(0xFF7A7570), fontSize: 14)),
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

    final products = ctrl.filteredProducts;
    if (products.isEmpty) {
      return Center(
        child: Text('Nenhum produto encontrado.',
            style: TextStyle(color: _textMuted, fontSize: 14)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        mainAxisExtent: 160,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (_, i) => _ProductCard(product: products[i]),
    );
  }

  Widget _buildBottomBar(ComandaController ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        border: Border(top: BorderSide(color: _borderColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${ctrl.totalItems} ite${ctrl.totalItems != 1 ? 'ns' : 'm'}',
                style: TextStyle(color: _textMuted, fontSize: 12),
              ),
              Text(
                ctrl.formattedTotal,
                style: const TextStyle(
                    color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const Spacer(),
          SizedBox(
            height: 46,
            child: ElevatedButton(
              onPressed: () => ctrl.goTo(ComandaStep.review),
              style: ElevatedButton.styleFrom(
                backgroundColor: _accentColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: const Row(
                children: [
                  Text('Revisar comanda',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward_rounded, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Product Card ──────────────────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  static const _accentColor = Color(0xFFD4552A);
  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<ComandaController>();
    final qty = ctrl.quantityOf(product.id);
    final inCart = qty > 0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: inCart ? _accentColor.withOpacity(0.6) : _borderColor,
          width: inCart ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (inCart)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _accentColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$qty',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              product.description,
              style: TextStyle(color: _textMuted, fontSize: 12, height: 1.4),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  product.formattedPrice,
                  style: const TextStyle(
                    color: Color(0xFFD4552A),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                _QuantityControl(product: product, qty: qty),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _QuantityControl extends StatelessWidget {
  final ProductModel product;
  final int qty;
  const _QuantityControl({required this.product, required this.qty});

  static const _accentColor = Color(0xFFD4552A);
  static const _borderColor = Color(0xFF2E2A25);

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<ComandaController>();

    if (qty == 0) {
      return GestureDetector(
        onTap: () => ctrl.addItem(product),
        child: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: _accentColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.add, size: 16, color: Colors.white),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ControlBtn(
          icon: Icons.remove,
          onTap: () => ctrl.removeItem(product.id),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '$qty',
            style: const TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
          ),
        ),
        _ControlBtn(
          icon: Icons.add,
          onTap: () => ctrl.addItem(product),
        ),
      ],
    );
  }
}

class _ControlBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ControlBtn({required this.icon, required this.onTap});

  static const _accentColor = Color(0xFFD4552A);
  static const _borderColor = Color(0xFF2E2A25);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          border: Border.all(color: _borderColor),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 14, color: _accentColor),
      ),
    );
  }
}
