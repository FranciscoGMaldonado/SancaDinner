import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../shared/widgets/logout_button.dart';
import '../controllers/admin_product_controller.dart';
import '../controllers/admin_user_controller.dart';
import 'admin_products_screen.dart';
import 'admin_users_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentIndex = 0;

  static const _bgColor = Color(0xFF0F0D0A);
  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _accentColor = Color(0xFFD4552A);
  static const _textMuted = Color(0xFF7A7570);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AdminProductController(
            token: context.read<String>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => AdminUserController(
            token: context.read<String>(),
          ),
        ),
      ],
      child: Scaffold(
        backgroundColor: _bgColor,
        appBar: _buildAppBar(),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _currentIndex == 0
              ? const AdminProductsScreen()
              : const AdminUsersScreen(),
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
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
            'Painel Administrativo',
            style: TextStyle(
              fontSize: 11,
              color: _textMuted,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          Text(
            _currentIndex == 0 ? 'Produtos' : 'Usuários',
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      actions: const [
        LogoutButton(),
        SizedBox(width: 8),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        border: Border(
          top: BorderSide(
            color: _borderColor,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _NavItem(
              icon: Icons.fastfood_outlined,
              label: 'Produtos',
              selected: _currentIndex == 0,
              onTap: () => setState(() => _currentIndex = 0),
            ),
            _NavItem(
              icon: Icons.people_outline_rounded,
              label: 'Usuários',
              selected: _currentIndex == 1,
              onTap: () => setState(() => _currentIndex = 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const _accentColor = Color(0xFFD4552A);
  static const _textMuted = Color(0xFF7A7570);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: selected ? _accentColor : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: selected ? 1.05 : 1,
                child: Icon(
                  icon,
                  size: 22,
                  color: selected ? _accentColor : _textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                  color: selected ? _accentColor : _textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}