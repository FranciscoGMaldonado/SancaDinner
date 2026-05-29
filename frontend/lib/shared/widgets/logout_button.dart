import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/auth/controllers/login_controller.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Logout',
      icon: const Icon(Icons.logout_rounded),
      onPressed: () {
        context.read<LoginController>().logout();
      },
    );
  }
}