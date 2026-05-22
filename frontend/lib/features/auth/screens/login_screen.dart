import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/login_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;

  static const _accentColor = Color(0xFFD4552A);
  static const _bgColor = Color(0xFF0F0D0A);
  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<LoginController>();
    final success = await controller.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      // Navigator.of(context).pushReplacementNamed('/home');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bem-vindo, ${controller.userName}!'),
          backgroundColor: _accentColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<LoginController>();

    return Scaffold(
      backgroundColor: _bgColor,
      body: Row(
        children: [
          _buildBrandPanel(),
          _buildFormPanel(controller),
        ],
      ),
    );
  }

  Widget _buildBrandPanel() {
    return Expanded(
      flex: 5,
      child: Container(
        color: _surfaceColor,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: _GridPainter()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Logo(),
                  const Spacer(),
                  Text(
                    'A melhor\nferramenta\ngastronômica\nde São Carlos.',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontSize: 44,
                      height: 1.15,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormPanel(LoginController controller) {
    return Expanded(
      flex: 4,
      child: Container(
        color: _bgColor,
        child: Center(
          child: FadeTransition(
            opacity: _fadeIn,
            child: SlideTransition(
              position: _slideUp,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Entrar',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontSize: 30,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Acesse sua conta Sanca Dinner',
                          style: TextStyle(fontSize: 14, color: _textMuted),
                        ),
                        const SizedBox(height: 40),
                        const _FieldLabel(label: 'Email'),
                        const SizedBox(height: 8),
                        _buildEmailField(),
                        const SizedBox(height: 20),
                        const _FieldLabel(label: 'Senha'),
                        const SizedBox(height: 8),
                        _buildPasswordField(),
                        const SizedBox(height: 12),
                        if (controller.errorMessage != null)
                          _buildErrorMessage(controller.errorMessage!),
                        const SizedBox(height: 28),
                        _buildSubmitButton(controller),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      autofillHints: const [AutofillHints.email],
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: _inputDecoration(
        hint: 'seu@email.com',
        icon: Icons.mail_outline_rounded,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Informe seu email.';
        if (!v.contains('@')) return 'Email inválido.';
        return null;
      },
      onFieldSubmitted: (_) => _submit(),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: _inputDecoration(
        hint: '••••••••',
        icon: Icons.lock_outline_rounded,
        suffix: IconButton(
          icon: Icon(
            _obscurePassword
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            size: 18,
            color: _textMuted,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Informe sua senha.';
        if (v.length < 6) return 'Mínimo de 6 caracteres.';
        return null;
      },
      onFieldSubmitted: (_) => _submit(),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: _textMuted, fontSize: 14),
      prefixIcon: Icon(icon, size: 18, color: _textMuted),
      suffixIcon: suffix,
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

  Widget _buildErrorMessage(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1010),
        border: Border.all(color: const Color(0xFF5A2020)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, size: 16, color: Color(0xFFFF6B6B)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Color(0xFFFF6B6B), fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(LoginController controller) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: controller.isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          disabledBackgroundColor: _accentColor.withOpacity(0.5),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: controller.isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                'Entrar',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFFB0AA9F),
        letterSpacing: 0.2,
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFD4552A),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.dinner_dining, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 10),
        const Text(
          'Sanca Dinner',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2E2A25).withOpacity(0.4)
      ..strokeWidth = 0.5;

    const step = 48.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}