import 'package:flutter/material.dart';
import 'package:mc_express/core/network/api_exception.dart';
import 'package:mc_express/core/routes/app_routes.dart';
import 'package:mc_express/core/security/session_lock_service.dart';
import 'package:mc_express/core/theme/app_theme.dart';
import 'package:mc_express/core/widgets/branded_scaffold.dart';
import 'package:mc_express/features/auth/data/app_settings_api.dart';
import 'package:mc_express/features/auth/data/auth_api.dart';
import 'package:mc_express/features/profile/data/account_api.dart';

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
  final _accountApi = AccountApi();
  final _settingsApi = AppSettingsApi();

  bool _isRegister = true;
  bool _isLoading = false;
  bool _readArgs = false;
  String? _error;
  String _targetRole = 'client';
  int? _categoryId;
  String? _categoryName;
  late final Future<AppSettings> _settingsFuture;

  @override
  void initState() {
    super.initState();
    _settingsFuture = _settingsApi.publicSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_readArgs) return;
    _readArgs = true;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _targetRole = args['role']?.toString() ?? _targetRole;
      _categoryId = int.tryParse(args['category_id']?.toString() ?? '');
      _categoryName = args['category_name']?.toString();
      _isRegister = args['mode']?.toString() != 'login';
    }
  }

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
        if (_targetRole == 'professional' && _categoryId != null) {
          await _accountApi.registerProfessional(
            categoryId: _categoryId!,
            basePrice: 28,
            bio:
                'Profesional de ${_categoryName ?? 'MC Express'} disponible para solicitudes cercanas.',
          );
        }
      } else {
        await _authApi.login(
          identifier: _phoneController.text.trim(),
          password: _passwordController.text,
        );
      }
      if (!mounted) return;
      await _offerSessionLock();
      if (!mounted) return;
      if (_targetRole == 'professional' && _isRegister) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.professionalWork, (route) => false);
        return;
      }
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
            FutureBuilder<AppSettings>(
              future: _settingsFuture,
              builder: (context, snapshot) {
                final settings = snapshot.data;
                return _AuthOptions(
                  settings: settings,
                  isRegister: _isRegister,
                  targetRole: _targetRole,
                  categoryName: _categoryName,
                );
              },
            ),
            const SizedBox(height: 18),
            if (_isRegister)
              _AuthField(
                controller: _nameController,
                label: 'Nombre completo',
                icon: Icons.person_rounded,
              ),
            if (_isRegister) const SizedBox(height: 14),
            _AuthField(
              controller: _phoneController,
              label: _isRegister ? 'Teléfono' : 'Teléfono o correo',
              icon: Icons.phone_rounded,
              keyboardType: _isRegister
                  ? TextInputType.phone
                  : TextInputType.emailAddress,
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
                  if (_isRegister && _targetRole == 'client') {
                    _targetRole = 'client';
                  }
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

class _AuthOptions extends StatelessWidget {
  const _AuthOptions({
    required this.settings,
    required this.isRegister,
    required this.targetRole,
    this.categoryName,
  });

  final AppSettings? settings;
  final bool isRegister;
  final String targetRole;
  final String? categoryName;

  @override
  Widget build(BuildContext context) {
    final activeButtons = <Widget>[
      if (settings?.facebookEnabled == true)
        const _SocialButton(icon: Icons.facebook_rounded, label: 'Facebook'),
      if (settings?.tiktokEnabled == true)
        const _SocialButton(icon: Icons.music_note_rounded, label: 'TikTok'),
      if (settings?.googleEnabled == true)
        const _SocialButton(icon: Icons.g_mobiledata_rounded, label: 'Google'),
    ];

    if (!isRegister) {
      if (activeButtons.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...activeButtons,
          const SizedBox(height: 8),
          const Text(
            'También puedes ingresar con teléfono o correo.',
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _IntentBadge(
          icon: targetRole == 'professional'
              ? Icons.engineering_rounded
              : Icons.person_rounded,
          text: targetRole == 'professional'
              ? 'Registro como profesional${categoryName == null ? '' : ' · $categoryName'}'
              : 'Registro como cliente',
        ),
        if (isRegister && settings?.phoneVerificationEnabled == true) ...[
          const SizedBox(height: 10),
          const _IntentBadge(
            icon: Icons.verified_user_rounded,
            text: 'Verificación telefónica activa',
          ),
        ],
        if (activeButtons.isNotEmpty) ...[
          const SizedBox(height: 14),
          ...activeButtons,
          const SizedBox(height: 8),
          const Text(
            'Las redes están activadas en el panel. Falta conectar OAuth para producción.',
            style: TextStyle(
              color: AppTheme.mutedText,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ],
    );
  }
}

class _IntentBadge extends StatelessWidget {
  const _IntentBadge({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF181816),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.yellow.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.yellow),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF10100F),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.yellow),
          const SizedBox(width: 10),
          Text(
            'Continuar con $label',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
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
