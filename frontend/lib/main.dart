import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/controllers/login_controller.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/service/controllers/order_controller.dart';
import 'features/service/screens/order_screen.dart';
import 'features/kitchen/controllers/kitchen_controller.dart';
import 'features/kitchen/screens/kitchen_screen.dart';

void main() {
  runApp(const SancaDinnerApp());
}

class SancaDinnerApp extends StatelessWidget {
  const SancaDinnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginController(),
      child: MaterialApp(
        title: 'Sanca Dinner',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: const ColorScheme.dark(),
          useMaterial3: true,
        ),
        home: const _RootRouter(),
      ),
    );
  }
}

class _RootRouter extends StatelessWidget {
  const _RootRouter();

  @override
  Widget build(BuildContext context) {
    final login = context.watch<LoginController>();

    if (!login.isAuthenticated) {
      return const LoginScreen();
    }

    switch (login.userRole) {
      case 'SERVICE':
        return ChangeNotifierProvider(
          create: (_) => OrderController(token: login.token!),
          child: const OrderScreen(),
        );
      case 'KITCHEN':
        return ChangeNotifierProvider(
          create: (_) => KitchenController(token: login.token!),
          child: const KitchenScreen(),
        );
      default:
        return _PlaceholderScreen(role: login.userRole ?? 'UNKNOWN');
    }
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String role;
  const _PlaceholderScreen({required this.role});

  static const _bgColor = Color(0xFF0F0D0A);
  static const _accentColor = Color(0xFFD4552A);
  static const _textMuted = Color(0xFF7A7570);

  @override
  Widget build(BuildContext context) {
    final login = context.read<LoginController>();
    return Scaffold(
      backgroundColor: _bgColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction_outlined, color: _textMuted, size: 48),
            const SizedBox(height: 20),
            const Text(
              'Em construção',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A tela para o perfil "$role" ainda não foi implementada.',
              style: const TextStyle(color: _textMuted, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: login.logout,
              child: const Text('Sair', style: TextStyle(color: _accentColor)),
            ),
          ],
        ),
      ),
    );
  }
}
