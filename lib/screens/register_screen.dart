import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _fullnameController  = TextEditingController();
  final _emailController     = TextEditingController();
  final _passwordController  = TextEditingController();
  final _confirmController   = TextEditingController();

  String  _selectedRole  = 'Seeking Support';
  bool    _agreePolicy   = false;
  bool    _consentAI     = false;
  bool    _showPassword  = false;
  bool    _showConfirm   = false;
  bool    _isLoading     = false;
  String? _errorMessage;

  late AnimationController _entranceController;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  // ── Palette ───────────────────────────────────────────────────────────────
  static const Color _bg         = Color(0xFFF6F4F0);
  static const Color _surface    = Color(0xFFFFFFFF);
  static const Color _sage       = Color(0xFF7CA982);
  static const Color _sageLight  = Color(0xFFD4EAD7);
  static const Color _teal       = Color(0xFF4A9EAF);
  static const Color _tealLight  = Color(0xFFD6EEF3);
  static const Color _peach      = Color(0xFFE8926A);
  static const Color _peachLight = Color(0xFFFAE2D5);
  static const Color _lavender   = Color(0xFF9B8EC4);
  static const Color _lavLight   = Color(0xFFEAE6F5);
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7280);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  // ── Password strength ─────────────────────────────────────────────────────
  double get _passwordStrength {
    final p = _passwordController.text;
    if (p.isEmpty) return 0;
    double s = 0;
    if (p.length >= 8)  s += 0.25;
    if (p.length >= 12) s += 0.25;
    if (p.contains(RegExp(r'[A-Z]'))) s += 0.25;
    if (p.contains(RegExp(r'[0-9!@#\$%^&*]'))) s += 0.25;
    return s;
  }

  String get _strengthLabel {
    final s = _passwordStrength;
    if (s <= 0.25) return 'Weak';
    if (s <= 0.50) return 'Fair';
    if (s <= 0.75) return 'Good';
    return 'Strong';
  }

  Color get _strengthColor {
    final s = _passwordStrength;
    if (s <= 0.25) return _peach;
    if (s <= 0.50) return const Color(0xFFF4C542);
    if (s <= 0.75) return _teal;
    return _sage;
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _fadeAnim = CurvedAnimation(
        parent: _entranceController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _entranceController, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  void _createAccount() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    final fullname = _fullnameController.text.trim();
    final email    = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm  = _confirmController.text;

    if (fullname.isEmpty || email.isEmpty || password.isEmpty || confirm.isEmpty) {
      setState(() { _errorMessage = 'All fields are required.'; _isLoading = false; });
      return;
    }
    if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+").hasMatch(email)) {
      setState(() { _errorMessage = 'Please enter a valid email address.'; _isLoading = false; });
      return;
    }
    if (password.length < 8) {
      setState(() { _errorMessage = 'Password must be at least 8 characters long.'; _isLoading = false; });
      return;
    }
    if (password != confirm) {
      setState(() { _errorMessage = 'Passwords do not match.'; _isLoading = false; });
      return;
    }
    if (!_agreePolicy || !_consentAI) {
      setState(() { _errorMessage = 'Please agree to the policy and consent to data usage.'; _isLoading = false; });
      return;
    }

    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: _textDark, fontSize: 13.5, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(color: _textDark, fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: _textLight),
            prefixIcon: Icon(icon, color: _textLight, size: 20),
            suffixIcon: suffix,
            filled: true,
            fillColor: _bg,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _border)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _border)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _sage, width: 1.5)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _roleButton(String role, IconData icon, Color accent, Color accentLight) {
    final selected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedRole = role),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? accent : _bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: selected ? accent : _border, width: selected ? 0 : 1),
            boxShadow: selected
                ? [BoxShadow(color: accent.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4))]
                : [],
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? Colors.white : _textMid, size: 24),
              const SizedBox(height: 6),
              Text(
                role,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? Colors.white : _textMid,
                  fontSize: 12.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _consentTile(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool?> onChanged,
    Color accent,
    Color accentLight,
  ) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: value ? accentLight : _bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: value ? accent.withOpacity(0.35) : _border),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: value ? accent : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: value ? accent : _border, width: 2),
              ),
              child: value
                  ? const Icon(Icons.check_rounded,
                      color: Colors.white, size: 14)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: _textDark,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600)),
                  if (subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            color: _textLight, fontSize: 11.5)),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ── Header ───────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 36, 24, 30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9B8EC4), Color(0xFF4A9EAF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _lavender.withOpacity(0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.spa_rounded,
                              color: Colors.white, size: 36),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Create Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Begin your journey to mental wellness',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '"Your story matters, and we\'re here to listen"',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.5,
                                fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── Form ─────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: SlideTransition(
                    position: _slideAnim,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        // ── Role Selector ──────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: _lavLight,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(Icons.person_outline_rounded,
                                      color: _lavender, size: 18),
                                ),
                                const SizedBox(width: 10),
                                const Text('I am joining as…',
                                    style: TextStyle(
                                        color: _textDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                              ]),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  _roleButton(
                                      'Seeking Support',
                                      Icons.self_improvement_rounded,
                                      _sage,
                                      _sageLight),
                                  const SizedBox(width: 12),
                                  _roleButton(
                                      'Counsellor',
                                      Icons.psychology_rounded,
                                      _teal,
                                      _tealLight),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Personal Info Card ─────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: _sageLight,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(Icons.edit_note_rounded,
                                      color: _sage, size: 18),
                                ),
                                const SizedBox(width: 10),
                                const Text('Tell Us About Yourself',
                                    style: TextStyle(
                                        color: _textDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                              ]),
                              const SizedBox(height: 20),
                              _inputField(
                                controller: _fullnameController,
                                label: 'Full Name',
                                hint: 'Alex Thompson',
                                icon: Icons.badge_outlined,
                              ),
                              const SizedBox(height: 14),
                              _inputField(
                                controller: _emailController,
                                label: 'Email Address',
                                hint: 'user@example.com',
                                icon: Icons.mail_outline_rounded,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 14),
                              _inputField(
                                controller: _passwordController,
                                label: 'Password',
                                hint: '••••••••',
                                icon: Icons.lock_outline_rounded,
                                obscure: !_showPassword,
                                suffix: IconButton(
                                  icon: Icon(
                                    _showPassword
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: _textLight,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                      () => _showPassword = !_showPassword),
                                ),
                              ),

                              // Password strength
                              if (_passwordController.text.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: _passwordStrength,
                                    color: _strengthColor,
                                    backgroundColor: _bg,
                                    minHeight: 6,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                          color: _strengthColor,
                                          shape: BoxShape.circle),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Password strength: $_strengthLabel',
                                      style: TextStyle(
                                          color: _strengthColor,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 14),
                              _inputField(
                                controller: _confirmController,
                                label: 'Confirm Password',
                                hint: '••••••••',
                                icon: Icons.lock_reset_rounded,
                                obscure: !_showConfirm,
                                suffix: IconButton(
                                  icon: Icon(
                                    _showConfirm
                                        ? Icons.visibility_rounded
                                        : Icons.visibility_off_rounded,
                                    color: _textLight,
                                    size: 20,
                                  ),
                                  onPressed: () => setState(
                                      () => _showConfirm = !_showConfirm),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Consent Card ───────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: _tealLight,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Icon(Icons.shield_outlined,
                                      color: _teal, size: 18),
                                ),
                                const SizedBox(width: 10),
                                const Text('Your Consent',
                                    style: TextStyle(
                                        color: _textDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700)),
                              ]),
                              const SizedBox(height: 16),
                              _consentTile(
                                'Privacy Policy & Terms',
                                'I agree to the terms and conditions',
                                _agreePolicy,
                                (v) => setState(() => _agreePolicy = v ?? false),
                                _sage,
                                _sageLight,
                              ),
                              const SizedBox(height: 10),
                              _consentTile(
                                'Consent to Data Usage',
                                'Anonymous data used to improve AI support',
                                _consentAI,
                                (v) => setState(() => _consentAI = v ?? false),
                                _teal,
                                _tealLight,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // ── Error ──────────────────────────────────────────
                        if (_errorMessage != null) ...[
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: _peachLight,
                              borderRadius: BorderRadius.circular(16),
                              border:
                                  Border.all(color: _peach.withOpacity(0.3)),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline_rounded,
                                    color: _peach, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(_errorMessage!,
                                      style: TextStyle(
                                          color: _peach, fontSize: 13)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // ── Submit Button ──────────────────────────────────
                        ElevatedButton(
                          onPressed: _isLoading ? null : _createAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _sage,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: _sage.withOpacity(0.6),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Create My Account',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700),
                                ),
                        ),
                        const SizedBox(height: 16),

                        // ── Sign in link ───────────────────────────────────
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: const TextStyle(
                                  color: _textMid, fontSize: 14),
                              children: [
                                TextSpan(
                                  text: 'Sign In',
                                  style: TextStyle(
                                    color: _teal,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ── Trust Footer ───────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _trustBadge('🔒', 'Secure'),
                              _dividerV(),
                              _trustBadge('🤝', 'Confidential'),
                              _dividerV(),
                              _trustBadge('👨‍⚕️', 'Professional'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _trustBadge(String emoji, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: _textLight, fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _dividerV() =>
      Container(width: 1, height: 32, color: _border);
}