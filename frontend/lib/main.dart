import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/controllers/login_controller.dart';
import 'features/auth/screens/login_screen.dart';

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
        home: const LoginScreen(),
      ),
    );
  }
}