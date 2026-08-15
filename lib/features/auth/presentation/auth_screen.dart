import 'package:flutter/material.dart';
import 'package:mc_express/core/network/api_exception.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/security/session_lock_service.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/auth/data/auth_api.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authApi = AuthApi();

  bool _isRegister = true;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      if (_isRegister) {
        await _authApi.register(
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
      } else {
        await _authApi.login(
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        );
      }
      if (!mounted) return;
      await _offerSessionLock();
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    } on ApiException catch (error) {
      setState(() => _error = error.message);
    } catch (_) {
      setState(() => _error = 'No se pudo conectar con el servidor');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _offerSessionLock() async {
    if (await SessionLockService.instance.isEnabled || !mounted) return;
    final enable = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF171716),
        title: const Text(
          'Guardar acceso seguro',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        content: const Text(
          'Puedes mantener tu sesión y protegerla con Face ID, huella, rostro o PIN del teléfono cuando esté disponible.',
          style: TextStyle(
            color: AppTheme.mutedText,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Después'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Activar'),
          ),
        ],
      ),
    );
    if (enable == true) {
      await SessionLockService.instance.enable();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BrandedScaffold(
      showBack: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            const Center(child: McWordmark()),
            const SizedBox(height: 42),
            Text(
              _isRegister ? 'Crear cuenta' : 'Ingresar',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Conecta con profesionales reales cerca de tu ubicación.',
              style: TextStyle(
                color: AppTheme.mutedText,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.35,
                letterSpacing: 0,
              ),
            ),
            const SizedBox(height: 26),
            if (_isRegister)
              _AuthField(
                controller: _nameController,
                label: 'Nombre completo',
                icon: Icons.person_rounded,
              ),
            if (_isRegister) const SizedBox(height: 14),
            _AuthField(
              controller: _phoneController,
              label: 'Teléfono',
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            if (_isRegister)
              _AuthField(
                controller: _emailController,
                label: 'Correo opcional',
                icon: Icons.mail_rounded,
                keyboardType: TextInputType.emailAddress,
              ),
            if (_isRegister) const SizedBox(height: 14),
            _AuthField(
              controller: _passwordController,
              label: 'Contraseña',
              icon: Icons.lock_rounded,
              obscureText: true,
            ),
            if (_error != null) ...[
              const SizedBox(height: 14),
              Text(
                _error!,
                style: const TextStyle(
                  color: Color(0xFFFF5A52),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
            const SizedBox(height: 26),
            AppButton(
              label: _isLoading
                  ? 'CONECTANDO...'
                  : _isRegister
                  ? 'REGISTRARME'
                  : 'INGRESAR',
              onPressed: _isLoading ? () {} : _submit,
            ),
            const SizedBox(height: 14),
            AppButton(
              label: _isRegister ? 'YA TENGO CUENTA' : 'CREAR CUENTA',
              outlined: true,
              onPressed: () {
                setState(() {
                  _isRegister = !_isRegister;
                  _error = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthField extends StatefulWidget {
  const _AuthField({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;

  @override
  State<_AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<_AuthField> {
  late bool _hidden;

  @override
  void initState() {
    super.initState();
    _hidden = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      obscureText: _hidden,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(color: AppTheme.mutedText),
        prefixIcon: Icon(widget.icon, color: AppTheme.yellow),
        suffixIcon: widget.obscureText
            ? IconButton(
                onPressed: () => setState(() => _hidden = !_hidden),
                icon: Icon(
                  _hidden
                      ? Icons.visibility_rounded
                      : Icons.visibility_off_rounded,
                  color: AppTheme.yellow,
                ),
              )
            : null,
        filled: true,
        fillColor: const Color(0xFF181816),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.10)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppTheme.yellow, width: 2),
        ),
      ),
    );
  }
}
