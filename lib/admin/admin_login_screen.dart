import 'package:flutter/material.dart';
import 'admin_service.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;
  bool _isLoading = false;
  String? _errorMessage;
  final AdminService _adminService = AdminService();

  // Color Palette
  static const Color _darkBg = Color(0xFF1A1A2E);
  static const Color _cardBg = Color(0xFF16213E);
  static const Color _surface = Color(0xFF0F3460);
  static const Color _accentBlue = Color(0xFF00A3FF);
  static const Color _accentGold = Color(0xFFFFB700);
  static const Color _textLight = Color(0xFFEAEAEA);
  static const Color _textMuted = Color(0xFF9CA3AF);
  static const Color _errorRed = Color(0xFFFF4757);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);
    _errorMessage = null;

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please fill in all fields';
        _isLoading = false;
      });
      return;
    }

    final adminUser = await _adminService.loginAdmin(email, password);

    if (!mounted) return;

    if (adminUser != null) {
      Navigator.of(context)
          .pushReplacementNamed('/admin-dashboard', arguments: adminUser);
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              // ── Header ────────────────────────────────────────────────────
              Expanded(
                flex: 2,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_surface, _accentBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: _accentGold,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _accentGold.withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.admin_panel_settings_rounded,
                            size: 48,
                            color: _darkBg,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Mind Path Admin',
                        style: TextStyle(
                          color: _textLight,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Administration Portal',
                        style: TextStyle(
                          color: _textMuted,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Login Form ────────────────────────────────────────────────
              Expanded(
                flex: 3,
                child: Container(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // ── Title ──────────────────────────────────────────────
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Admin Login',
                          style: TextStyle(
                            color: _textLight,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── Error Message ──────────────────────────────────────
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _errorRed.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: _errorRed, width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_rounded,
                                  color: _errorRed, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _errorMessage!,
                                  style: const TextStyle(
                                    color: _errorRed,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (_errorMessage != null) const SizedBox(height: 20),

                      // ── Email Field ────────────────────────────────────────
                      TextField(
                        controller: _emailController,
                        enabled: !_isLoading,
                        style: const TextStyle(color: _textLight),
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          labelStyle:
                              const TextStyle(color: _textMuted, fontSize: 13),
                          prefixIcon: const Icon(Icons.email_rounded,
                              color: _accentBlue, size: 20),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _surface, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _accentBlue, width: 2),
                          ),
                          filled: true,
                          fillColor: _cardBg,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Password Field ─────────────────────────────────────
                      TextField(
                        controller: _passwordController,
                        enabled: !_isLoading,
                        obscureText: !_showPassword,
                        style: const TextStyle(color: _textLight),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle:
                              const TextStyle(color: _textMuted, fontSize: 13),
                          prefixIcon: const Icon(Icons.lock_rounded,
                              color: _accentBlue, size: 20),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: _accentBlue,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() => _showPassword = !_showPassword);
                            },
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _surface, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _accentBlue, width: 2),
                          ),
                          filled: true,
                          fillColor: _cardBg,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // ── Login Button ────────────────────────────────────────
                      GestureDetector(
                        onTap: _isLoading ? null : _handleLogin,
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [_accentBlue, _accentGold],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: _accentBlue.withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Center(
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Login to Admin Portal',
                                    style: TextStyle(
                                      color: _darkBg,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // ── Back to User Login ─────────────────────────────────
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.arrow_back_rounded,
                                color: _textMuted, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Back to User Login',
                              style: TextStyle(
                                color: _textMuted,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Demo Credentials ────────────────────────────────────
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _surface.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: _accentGold.withValues(alpha: 0.3),
                              width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(Icons.info_rounded,
                                    color: _accentGold, size: 16),
                                SizedBox(width: 8),
                                Text(
                                  'Demo Credentials',
                                  style: TextStyle(
                                    color: _accentGold,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Email: superadmin@mindpath.com',
                              style: TextStyle(
                                color: _textMuted,
                                fontSize: 11.5,
                                fontFamily: 'Courier',
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Password: SuperAdmin@2024',
                              style: TextStyle(
                                color: _textMuted,
                                fontSize: 11.5,
                                fontFamily: 'Courier',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
