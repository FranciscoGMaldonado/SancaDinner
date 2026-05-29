import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/admin_user_controller.dart';
import '../models/admin_models.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  static const _accentColor = Color(0xFFD4552A);
  static const _textMuted = Color(0xFF7A7570);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminUserController>().fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<AdminUserController>();

    return Scaffold(
      backgroundColor: const Color(0xFF0F0D0A),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(context),
        backgroundColor: _accentColor,
        child: const Icon(Icons.person_add_outlined, color: Colors.white),
      ),
      body: _buildBody(ctrl),
    );
  }

  Widget _buildBody(AdminUserController ctrl) {
    if (ctrl.loading && ctrl.users.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
            color: Color(0xFFD4552A), strokeWidth: 2),
      );
    }

    if (ctrl.error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                color: Color(0xFF7A7570), size: 40),
            const SizedBox(height: 16),
            Text(ctrl.error!,
                style: const TextStyle(
                    color: Color(0xFF7A7570), fontSize: 14)),
            const SizedBox(height: 20),
            TextButton(
              onPressed: ctrl.fetchUsers,
              child: const Text('Tentar novamente',
                  style: TextStyle(color: Color(0xFFD4552A))),
            ),
          ],
        ),
      );
    }

    // Endpoint GET ainda não implementado
    if (!ctrl.listSupported) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1714),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF2E2A25)),
              ),
              child: const Icon(Icons.people_outline_rounded,
                  color: Color(0xFF7A7570), size: 28),
            ),
            const SizedBox(height: 20),
            const Text(
              'Listagem indisponível',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'O endpoint GET /api/users ainda não foi\nimplementado no backend.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFF7A7570), fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () => _showUserDialog(context),
              icon: const Icon(Icons.person_add_outlined,
                  size: 16, color: Color(0xFFD4552A)),
              label: const Text('Criar usuário',
                  style: TextStyle(color: Color(0xFFD4552A))),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFD4552A)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      );
    }

    if (ctrl.users.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.people_outline_rounded,
                color: Color(0xFF7A7570), size: 40),
            const SizedBox(height: 16),
            const Text('Nenhum usuário cadastrado.',
                style: TextStyle(
                    color: Color(0xFF7A7570), fontSize: 14)),
            const SizedBox(height: 8),
            const Text('Toque em + para adicionar.',
                style: TextStyle(
                    color: Color(0xFF5A5550), fontSize: 13)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: ctrl.users.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) => _UserTile(
        user: ctrl.users[i],
        onEdit: () => _showUserDialog(context, user: ctrl.users[i]),
      ),
    );
  }

  void _showUserDialog(BuildContext context, {AdminUser? user}) {
    showDialog(
      context: context,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<AdminUserController>(),
        child: _UserDialog(user: user),
      ),
    );
  }
}

// ── User Tile ─────────────────────────────────────────────────────────────────

class _UserTile extends StatelessWidget {
  final AdminUser user;
  final VoidCallback onEdit;
  const _UserTile({required this.user, required this.onEdit});

  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);
  static const _accentColor = Color(0xFFD4552A);

  Color get _roleColor {
    switch (user.role) {
      case UserRole.admin:   return const Color(0xFFD4552A);
      case UserRole.kitchen: return const Color(0xFFE8A020);
      case UserRole.service: return const Color(0xFF5090D0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = context.read<AdminUserController>();

    return Container(
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Avatar inicial
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _roleColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                style: TextStyle(
                    color: _roleColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Nome + email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(user.email,
                    style:
                        TextStyle(color: _textMuted, fontSize: 12)),
              ],
            ),
          ),
          // Role badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _roleColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _roleColor.withOpacity(0.3)),
            ),
            child: Text(
              user.role.label,
              style: TextStyle(
                  color: _roleColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          // Editar
          _IconBtn(
            icon: Icons.edit_outlined,
            color: _textMuted,
            onTap: onEdit,
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
    );
  }

  void _confirmDelete(BuildContext context, AdminUserController ctrl) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1714),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFF2E2A25)),
        ),
        title: const Text('Excluir usuário?',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        content: Text(
          'Deseja excluir "${user.name}"?',
          style: const TextStyle(
              color: Color(0xFF7A7570), fontSize: 14),
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
              final err = await ctrl.deleteUser(user.id);
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

// ── User Dialog (create / edit) ───────────────────────────────────────────────

class _UserDialog extends StatefulWidget {
  final AdminUser? user;
  const _UserDialog({this.user});

  @override
  State<_UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends State<_UserDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  final _passCtrl = TextEditingController();
  late UserRole _selectedRole;
  bool _obscure = true;
  bool _saving = false;
  String? _error;

  static const _accentColor = Color(0xFFD4552A);
  static const _surfaceColor = Color(0xFF1A1714);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  bool get _isEdit => widget.user != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user?.name ?? '');
    _emailCtrl = TextEditingController(text: widget.user?.email ?? '');
    _selectedRole = widget.user?.role ?? UserRole.service;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });

    final ctrl = context.read<AdminUserController>();
    String? err;

    if (_isEdit) {
      err = await ctrl.updateUser(
        userId: widget.user!.id,
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        role: _selectedRole,
      );
    } else {
      err = await ctrl.createUser(
        name: _nameCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
        role: _selectedRole,
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
        _isEdit ? 'Editar usuário' : 'Novo usuário',
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
                hint: 'Ex: João Silva',
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Informe o nome.'
                    : null,
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _emailCtrl,
                label: 'E-mail',
                hint: 'Ex: joao@email.com',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty)
                    return 'Informe o e-mail.';
                  if (!v.contains('@')) return 'E-mail inválido.';
                  return null;
                },
              ),
              if (!_isEdit) ...[
                const SizedBox(height: 14),
                _buildPasswordField(),
              ],
              const SizedBox(height: 14),
              _buildRoleSelector(),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A1010),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: const Color(0xFF5A2020)),
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

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Senha',
            style: TextStyle(
                color: Color(0xFFB0AA9F),
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 6),
        TextFormField(
          controller: _passCtrl,
          obscureText: _obscure,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Mínimo 6 caracteres',
            hintStyle:
                const TextStyle(color: _textMuted, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFF0F0D0A),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 10, horizontal: 12),
            suffixIcon: IconButton(
              icon: Icon(
                _obscure
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 18,
                color: _textMuted,
              ),
              onPressed: () => setState(() => _obscure = !_obscure),
            ),
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
          validator: (v) {
            if (v == null || v.isEmpty) return 'Informe a senha.';
            if (v.length < 6) return 'Mínimo de 6 caracteres.';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRoleSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Perfil',
            style: TextStyle(
                color: Color(0xFFB0AA9F),
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: UserRole.values
              .map((role) => _RoleChip(
                    role: role,
                    selected: _selectedRole == role,
                    onTap: () =>
                        setState(() => _selectedRole = role),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

// ── Role Chip ─────────────────────────────────────────────────────────────────

class _RoleChip extends StatelessWidget {
  final UserRole role;
  final bool selected;
  final VoidCallback onTap;
  const _RoleChip(
      {required this.role,
      required this.selected,
      required this.onTap});

  static const _accentColor = Color(0xFFD4552A);
  static const _borderColor = Color(0xFF2E2A25);
  static const _textMuted = Color(0xFF7A7570);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? _accentColor.withOpacity(0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? _accentColor : _borderColor,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          role.label,
          style: TextStyle(
            color: selected ? _accentColor : _textMuted,
            fontSize: 13,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
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
