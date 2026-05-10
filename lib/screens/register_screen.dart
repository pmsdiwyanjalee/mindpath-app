import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final _fullnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _licenseController = TextEditingController();
  final _institutionController = TextEditingController();
  final _otpController = TextEditingController();

  String _selectedRole = 'Patient';
  bool _agreePolicy = false;
  bool _consentAI = false;
  bool _showPassword = false;
  bool _showConfirm = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Counsellor sub-flow: 'form' → 'pending' → 'otp'
  String _counsellorStep = 'form';

  // Real file state
  PlatformFile? _credFile; // Professional credentials
  PlatformFile? _certFile; // Degree / qualification
  bool _isPickingCred = false;
  bool _isPickingCert = false;

  late AnimationController _entranceController;
  late AnimationController _stepController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _stepFade;

  // ── Palette ───────────────────────────────────────────────────────────────
  static const Color _bg = Color(0xFFF6F4F0);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _sage = Color(0xFF7CA982);
  static const Color _sageLight = Color(0xFFD4EAD7);
  static const Color _teal = Color(0xFF4A9EAF);
  static const Color _tealLight = Color(0xFFD6EEF3);
  static const Color _peach = Color(0xFFE8926A);
  static const Color _peachLight = Color(0xFFFAE2D5);
  static const Color _lavender = Color(0xFF9B8EC4);
  static const Color _lavLight = Color(0xFFEAE6F5);
  static const Color _gold = Color(0xFFF4C542);
  static const Color _goldLight = Color(0xFFFDF3CC);
  static const Color _textDark = Color(0xFF2D3142);
  static const Color _textMid = Color(0xFF6B7280);
  static const Color _textLight = Color(0xFF9CA3AF);
  static const Color _border = Color(0xFFE8E5E0);

  // ── Password strength ─────────────────────────────────────────────────────
  double get _passwordStrength {
    final p = _passwordController.text;
    if (p.isEmpty) return 0;
    double s = 0;
    if (p.length >= 8) s += 0.25;
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
    if (s <= 0.50) return _gold;
    if (s <= 0.75) return _teal;
    return _sage;
  }

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));

    _entranceController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..forward();
    _fadeAnim =
        CurvedAnimation(parent: _entranceController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entranceController, curve: Curves.easeOutCubic));

    _stepController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400))
      ..forward();
    _stepFade = CurvedAnimation(parent: _stepController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _licenseController.dispose();
    _institutionController.dispose();
    _otpController.dispose();
    _entranceController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  void _switchStep(String step) {
    _stepController.reset();
    setState(() => _counsellorStep = step);
    _stepController.forward();
  }

  // ── File Picking ──────────────────────────────────────────────────────────

  Future<void> _pickCredFile() async {
    setState(() => _isPickingCred = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
        withData: false,
        withReadStream: false,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() => _credFile = result.files.first);
      }
    } catch (e) {
      _showPickError('Could not open file picker. Please try again.');
    } finally {
      setState(() => _isPickingCred = false);
    }
  }

  Future<void> _pickCertFile() async {
    setState(() => _isPickingCert = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        allowMultiple: false,
        withData: false,
        withReadStream: false,
      );
      if (result != null && result.files.isNotEmpty) {
        setState(() => _certFile = result.files.first);
      }
    } catch (e) {
      _showPickError('Could not open file picker. Please try again.');
    } finally {
      setState(() => _isPickingCert = false);
    }
  }

  void _removeCredFile() => setState(() => _credFile = null);
  void _removeCertFile() => setState(() => _certFile = null);

  void _showPickError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: _peach,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  /// Returns a human-friendly file size string
  String _fileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  // ── Validation ────────────────────────────────────────────────────────────

  void _createPatientAccount() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final f = _fullnameController.text.trim();
    final e = _emailController.text.trim();
    final p = _passwordController.text;
    final c = _confirmController.text;

    if (f.isEmpty || e.isEmpty || p.isEmpty || c.isEmpty)
      return _err('All fields are required.');
    if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+").hasMatch(e))
      return _err('Please enter a valid email address.');
    if (p.length < 8) return _err('Password must be at least 8 characters.');
    if (p != c) return _err('Passwords do not match.');
    if (!_agreePolicy || !_consentAI)
      return _err('Please agree to the policy and consent to data usage.');

    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _submitCounsellorApplication() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    final f = _fullnameController.text.trim();
    final e = _emailController.text.trim();
    final p = _passwordController.text;
    final c = _confirmController.text;
    final l = _licenseController.text.trim();
    final i = _institutionController.text.trim();

    if (f.isEmpty ||
        e.isEmpty ||
        p.isEmpty ||
        c.isEmpty ||
        l.isEmpty ||
        i.isEmpty) return _err('All fields are required.');
    if (!RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+").hasMatch(e))
      return _err('Please enter a valid email address.');
    if (p.length < 8) return _err('Password must be at least 8 characters.');
    if (p != c) return _err('Passwords do not match.');
    if (_credFile == null)
      return _err('Please upload your professional credentials (PDF/JPG).');
    if (!_agreePolicy) return _err('Please agree to the terms and policy.');

    // Here you would upload _credFile and _certFile to your backend/storage
    // e.g. await uploadFileToStorage(_credFile!);

    setState(() => _isLoading = false);
    _switchStep('pending');
  }

  void _verifyOtp() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    final otp = _otpController.text.trim();
    if (otp.length != 6)
      return _err('Please enter the 6-digit code sent to your email.');

    setState(() => _isLoading = false);
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _err(String msg) => setState(() {
        _errorMessage = msg;
        _isLoading = false;
      });

  // ── Shared Widgets ────────────────────────────────────────────────────────

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

  Widget _passwordStrengthBar() {
    if (_passwordController.text.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(height: 10),
      ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
              value: _passwordStrength,
              color: _strengthColor,
              backgroundColor: _bg,
              minHeight: 6)),
      const SizedBox(height: 6),
      Row(children: [
        Container(
            width: 8,
            height: 8,
            decoration:
                BoxDecoration(color: _strengthColor, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text('Password strength: $_strengthLabel',
            style: TextStyle(
                color: _strengthColor,
                fontSize: 12.5,
                fontWeight: FontWeight.w600)),
      ]),
    ]);
  }

  Widget _consentTile(String title, String subtitle, bool value,
      ValueChanged<bool?> onChanged, Color accent, Color accentLight) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: value ? accentLight : _bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: value ? accent.withValues(alpha: 0.35) : _border),
        ),
        child: Row(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 22,
            height: 22,
            decoration: BoxDecoration(
                color: value ? accent : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: value ? accent : _border, width: 2)),
            child: value
                ? const Icon(Icons.check_rounded, color: Colors.white, size: 14)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(title,
                    style: const TextStyle(
                        color: _textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600)),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(color: _textLight, fontSize: 11.5))
                ],
              ])),
        ]),
      ),
    );
  }

  // ── File Upload Tile ──────────────────────────────────────────────────────
  // Shows real file info after picking; allows removal.

  Widget _uploadTile({
    required String label,
    required String sublabel,
    required PlatformFile? file,
    required bool isPicking,
    required VoidCallback onPick,
    required VoidCallback onRemove,
    bool required = false,
  }) {
    final uploaded = file != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label row
        Row(children: [
          Text(label,
              style: const TextStyle(
                  color: _textDark,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600)),
          if (required) ...[
            const SizedBox(width: 4),
            Text('*',
                style: TextStyle(
                    color: _peach,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700)),
          ],
        ]),
        const SizedBox(height: 6),

        // Main tile
        GestureDetector(
          onTap: uploaded || isPicking ? null : onPick,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: uploaded ? _sageLight : _bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: uploaded ? _sage.withValues(alpha: 0.4) : _border,
                width: uploaded ? 1.5 : 1,
              ),
            ),
            child: Row(children: [
              // Left icon
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: uploaded
                      ? _sage
                      : isPicking
                          ? _tealLight
                          : _border,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isPicking
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: _teal),
                      )
                    : Icon(
                        uploaded
                            ? Icons.insert_drive_file_rounded
                            : Icons.upload_file_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
              ),
              const SizedBox(width: 14),

              // File info or prompt
              Expanded(
                child: uploaded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(file.name,
                                style: const TextStyle(
                                    color: _textDark,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 3),
                            Row(children: [
                              // File type chip
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 7, vertical: 2),
                                decoration: BoxDecoration(
                                    color: _sage,
                                    borderRadius: BorderRadius.circular(6)),
                                child: Text(
                                    (file.extension ?? 'FILE').toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700)),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                  file.size > 0
                                      ? _fileSize(file.size)
                                      : 'Ready',
                                  style: const TextStyle(
                                      color: _textLight, fontSize: 11.5)),
                            ]),
                          ])
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text('Tap to choose file',
                                style: const TextStyle(
                                    color: _textDark,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5)),
                            const SizedBox(height: 2),
                            Text(sublabel,
                                style: const TextStyle(
                                    color: _textLight, fontSize: 11.5)),
                          ]),
              ),

              // Right action
              if (uploaded)
                GestureDetector(
                  onTap: onRemove,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: _peachLight, shape: BoxShape.circle),
                    child: Icon(Icons.close_rounded, color: _peach, size: 16),
                  ),
                )
              else if (!isPicking)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: _teal, borderRadius: BorderRadius.circular(20)),
                  child: const Text('Browse',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _sectionCard(
      {required String title,
      required IconData icon,
      required Color accent,
      required Color accentLight,
      required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: accentLight, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: accent, size: 18)),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  color: _textDark, fontSize: 16, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 18),
        child,
      ]),
    );
  }

  Widget _errorBanner() => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: _peachLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _peach.withValues(alpha: 0.3))),
        child: Row(children: [
          Icon(Icons.error_outline_rounded, color: _peach, size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text(_errorMessage!,
                  style: TextStyle(color: _peach, fontSize: 13))),
        ]),
      );

  Widget _submitButton(String label, VoidCallback onPressed) => ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: _sage,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _sage.withValues(alpha: 0.6),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5))
            : Text(label,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      );

  Widget _signInLink() => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Already have an account? ',
            style: const TextStyle(color: _textMid, fontSize: 14),
            children: [
              TextSpan(
                  text: 'Sign In',
                  style: TextStyle(
                      color: _teal, fontWeight: FontWeight.w700, fontSize: 14))
            ],
          ),
        ),
      );

  Widget _trustFooter() => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: _border)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _trustBadge('🔒', 'Secure'),
          _dividerV(),
          _trustBadge('🤝', 'Confidential'),
          _dividerV(),
          _trustBadge('👨‍⚕️', 'Professional'),
        ]),
      );

  Widget _trustBadge(String emoji, String label) => Column(children: [
        Text(emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                color: _textLight, fontSize: 11, fontWeight: FontWeight.w500)),
      ]);

  Widget _dividerV() => Container(width: 1, height: 32, color: _border);

  Widget _roleTab(String role, IconData icon, Color accent) {
    final selected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedRole != role) {
            setState(() {
              _selectedRole = role;
              _counsellorStep = 'form';
              _errorMessage = null;
            });
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? accent : _bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? accent : _border),
            boxShadow: selected
                ? [
                    BoxShadow(
                        color: accent.withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4))
                  ]
                : [],
          ),
          child: Column(children: [
            Icon(icon, color: selected ? Colors.white : _textMid, size: 24),
            const SizedBox(height: 6),
            Text(role,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: selected ? Colors.white : _textMid,
                    fontSize: 12.5,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
          ]),
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
          child: Column(children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 36, 24, 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF9B8EC4), Color(0xFF4A9EAF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36)),
                boxShadow: [
                  BoxShadow(
                      color: _lavender.withValues(alpha: 0.3),
                      blurRadius: 24,
                      offset: const Offset(0, 8))
                ],
              ),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(children: [
                    Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle),
                        child: const Icon(Icons.spa_rounded,
                            color: Colors.white, size: 36)),
                    const SizedBox(height: 14),
                    const Text('Create Account',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5)),
                    const SizedBox(height: 6),
                    const Text('Begin your journey to mental wellness',
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                          '"Your story matters, and we\'re here to listen"',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontStyle: FontStyle.italic)),
                    ),
                  ]),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 40),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Role toggle
                        _sectionCard(
                          title: 'I am joining as…',
                          icon: Icons.person_outline_rounded,
                          accent: _lavender,
                          accentLight: _lavLight,
                          child: Row(children: [
                            _roleTab('Patient', Icons.self_improvement_rounded,
                                _sage),
                            const SizedBox(width: 12),
                            _roleTab(
                                'Counsellor', Icons.psychology_rounded, _teal),
                          ]),
                        ),
                        const SizedBox(height: 16),

                        if (_selectedRole == 'Patient')
                          _buildPatientForm()
                        else
                          FadeTransition(
                              opacity: _stepFade,
                              child: _buildCounsellorFlow()),
                      ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ── Patient Form ──────────────────────────────────────────────────────────

  Widget _buildPatientForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _sectionCard(
        title: 'Tell Us About Yourself',
        icon: Icons.edit_note_rounded,
        accent: _sage,
        accentLight: _sageLight,
        child: Column(children: [
          _inputField(
              controller: _fullnameController,
              label: 'Full Name',
              hint: 'Alex Thompson',
              icon: Icons.badge_outlined),
          const SizedBox(height: 14),
          _inputField(
              controller: _emailController,
              label: 'Email Address',
              hint: 'user@example.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress),
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
                      size: 20),
                  onPressed: () =>
                      setState(() => _showPassword = !_showPassword))),
          _passwordStrengthBar(),
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
                      size: 20),
                  onPressed: () =>
                      setState(() => _showConfirm = !_showConfirm))),
        ]),
      ),
      const SizedBox(height: 16),
      _sectionCard(
        title: 'Your Consent',
        icon: Icons.shield_outlined,
        accent: _teal,
        accentLight: _tealLight,
        child: Column(children: [
          _consentTile(
              'Privacy Policy & Terms',
              'I agree to the terms and conditions',
              _agreePolicy,
              (v) => setState(() => _agreePolicy = v ?? false),
              _sage,
              _sageLight),
          const SizedBox(height: 10),
          _consentTile(
              'Consent to Data Usage',
              'Anonymous data used to improve AI support',
              _consentAI,
              (v) => setState(() => _consentAI = v ?? false),
              _teal,
              _tealLight),
        ]),
      ),
      const SizedBox(height: 16),
      if (_errorMessage != null) ...[
        _errorBanner(),
        const SizedBox(height: 16)
      ],
      _submitButton('Create My Account', _createPatientAccount),
      const SizedBox(height: 16),
      _signInLink(),
      const SizedBox(height: 24),
      _trustFooter(),
    ]);
  }

  // ── Counsellor Flow ───────────────────────────────────────────────────────

  Widget _buildCounsellorFlow() {
    switch (_counsellorStep) {
      case 'pending':
        return _buildPendingScreen();
      case 'otp':
        return _buildOtpScreen();
      default:
        return _buildCounsellorForm();
    }
  }

  Widget _buildCounsellorForm() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      // Info banner
      Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: _goldLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _gold.withValues(alpha: 0.3))),
        child: Row(children: [
          Icon(Icons.info_outline_rounded, color: _gold, size: 20),
          const SizedBox(width: 10),
          Expanded(
              child: Text(
                  'Counsellor accounts require admin approval. Once approved you will receive a one-time 6-digit login code by email.',
                  style: TextStyle(
                      color: Color(0xFF8B6914), fontSize: 12.5, height: 1.5))),
        ]),
      ),
      const SizedBox(height: 16),

      // Personal info
      _sectionCard(
        title: 'Personal Information',
        icon: Icons.badge_outlined,
        accent: _teal,
        accentLight: _tealLight,
        child: Column(children: [
          _inputField(
              controller: _fullnameController,
              label: 'Full Name',
              hint: 'Dr. Sarah Johnson',
              icon: Icons.badge_outlined),
          const SizedBox(height: 14),
          _inputField(
              controller: _emailController,
              label: 'Professional Email',
              hint: 'doctor@hospital.com',
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress),
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
                      size: 20),
                  onPressed: () =>
                      setState(() => _showPassword = !_showPassword))),
          _passwordStrengthBar(),
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
                      size: 20),
                  onPressed: () =>
                      setState(() => _showConfirm = !_showConfirm))),
        ]),
      ),
      const SizedBox(height: 16),

      // Professional details
      _sectionCard(
        title: 'Professional Details',
        icon: Icons.psychology_rounded,
        accent: _lavender,
        accentLight: _lavLight,
        child: Column(children: [
          _inputField(
              controller: _licenseController,
              label: 'License / Registration Number',
              hint: 'e.g. PSY-123456',
              icon: Icons.numbers_rounded),
          const SizedBox(height: 14),
          _inputField(
              controller: _institutionController,
              label: 'Affiliated Institution',
              hint: 'e.g. City Mental Health Centre',
              icon: Icons.business_rounded),
        ]),
      ),
      const SizedBox(height: 16),

      // Document upload — REAL file picker
      _sectionCard(
        title: 'Verification Documents',
        icon: Icons.upload_file_rounded,
        accent: _sage,
        accentLight: _sageLight,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Notice
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 18),
            decoration: BoxDecoration(
                color: _sageLight, borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Icon(Icons.verified_user_rounded, color: _sage, size: 16),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(
                      'All documents are encrypted and reviewed only by our admin team within 1–3 business days. Accepted formats: PDF, JPG, PNG (max 10 MB each).',
                      style:
                          TextStyle(color: _sage, fontSize: 12, height: 1.4))),
            ]),
          ),

          // Credential file
          _uploadTile(
            label: 'Professional Credentials',
            sublabel: 'License, registration cert, or professional ID',
            file: _credFile,
            isPicking: _isPickingCred,
            onPick: _pickCredFile,
            onRemove: _removeCredFile,
            required: true,
          ),
          const SizedBox(height: 14),

          // Certificate file
          _uploadTile(
            label: 'Degree / Qualification Certificate',
            sublabel: 'Bachelor\'s, Master\'s, or doctoral degree certificate',
            file: _certFile,
            isPicking: _isPickingCert,
            onPick: _pickCertFile,
            onRemove: _removeCertFile,
          ),

          // Summary chips if files chosen
          if (_credFile != null || _certFile != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: _sageLight, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${(_credFile != null ? 1 : 0) + (_certFile != null ? 1 : 0)} document(s) ready to submit',
                      style: TextStyle(
                          color: _sage,
                          fontWeight: FontWeight.w700,
                          fontSize: 13)),
                  const SizedBox(height: 6),
                  if (_credFile != null) _fileChip(_credFile!),
                  if (_certFile != null) ...[
                    const SizedBox(height: 4),
                    _fileChip(_certFile!),
                  ],
                ],
              ),
            ),
          ],
        ]),
      ),
      const SizedBox(height: 16),

      // Consent
      _sectionCard(
        title: 'Your Consent',
        icon: Icons.shield_outlined,
        accent: _teal,
        accentLight: _tealLight,
        child: _consentTile(
            'Privacy Policy & Terms',
            'I agree to MindPath\'s terms for counsellors',
            _agreePolicy,
            (v) => setState(() => _agreePolicy = v ?? false),
            _sage,
            _sageLight),
      ),
      const SizedBox(height: 16),

      if (_errorMessage != null) ...[
        _errorBanner(),
        const SizedBox(height: 16)
      ],
      _submitButton('Submit for Approval', _submitCounsellorApplication),
      const SizedBox(height: 16),
      _signInLink(),
      const SizedBox(height: 24),
      _trustFooter(),
    ]);
  }

  Widget _fileChip(PlatformFile file) => Row(children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
              color: _sage, borderRadius: BorderRadius.circular(5)),
          child: Text((file.extension ?? 'FILE').toUpperCase(),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 6),
        Expanded(
            child: Text(file.name,
                style: const TextStyle(color: _textDark, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis)),
        if (file.size > 0)
          Text(_fileSize(file.size),
              style: const TextStyle(color: _textLight, fontSize: 11)),
      ]);

  // ── Pending & OTP (unchanged) ─────────────────────────────────────────────

  Widget _buildPendingScreen() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFFF4C542), Color(0xFFE8926A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: _gold.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 6))
          ],
        ),
        child: Column(children: [
          Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle),
              child: const Text('⏳', style: TextStyle(fontSize: 44))),
          const SizedBox(height: 16),
          const Text('Application Submitted!',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text(
              'Your counsellor application is currently under review by our admin team.',
              style:
                  TextStyle(color: Colors.white70, fontSize: 13.5, height: 1.5),
              textAlign: TextAlign.center),
        ]),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 4))
            ]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('What happens next?',
              style: TextStyle(
                  color: _textDark, fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          _processStep(
              '1',
              'Document Review',
              'Admin team reviews your credentials (1–3 business days).',
              _teal,
              _tealLight),
          _processStep(
              '2',
              'Admin Decision',
              'Your application is approved or feedback is sent by email.',
              _lavender,
              _lavLight),
          _processStep(
              '3',
              'One-Time Code Sent',
              'A secure 6-digit code is emailed to you for first login.',
              _sage,
              _sageLight,
              isLast: true),
        ]),
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: _tealLight, borderRadius: BorderRadius.circular(16)),
        child: Row(children: [
          Icon(Icons.email_rounded, color: _teal),
          const SizedBox(width: 12),
          Expanded(
              child: Text(
                  'Check your inbox at ${_emailController.text.isEmpty ? 'your registered email' : _emailController.text}.',
                  style: TextStyle(color: _teal, fontSize: 13, height: 1.5))),
        ]),
      ),
      const SizedBox(height: 16),
      OutlinedButton.icon(
        onPressed: () => _switchStep('otp'),
        icon: Icon(Icons.vpn_key_rounded, color: _sage),
        label: Text('I have received my one-time code',
            style: TextStyle(color: _sage, fontWeight: FontWeight.w700)),
        style: OutlinedButton.styleFrom(
            side: BorderSide(color: _sage),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14))),
      ),
      const SizedBox(height: 12),
      _signInLink(),
    ]);
  }

  Widget _buildOtpScreen() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 18,
                  offset: const Offset(0, 4))
            ]),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Center(
              child: Container(
                  width: 72,
                  height: 72,
                  decoration:
                      BoxDecoration(color: _sageLight, shape: BoxShape.circle),
                  child: Icon(Icons.mark_email_read_rounded,
                      color: _sage, size: 36))),
          const SizedBox(height: 16),
          const Text('Enter Your One-Time Code',
              style: TextStyle(
                  color: _textDark, fontSize: 20, fontWeight: FontWeight.w800),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(
              'A 6-digit verification code was sent to your registered email after admin approval. This code can only be used once.',
              style: TextStyle(color: _textMid, fontSize: 13.5, height: 1.5),
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 6,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: _textDark,
                fontSize: 30,
                fontWeight: FontWeight.w800,
                letterSpacing: 14),
            decoration: InputDecoration(
              counterText: '',
              hintText: '· · · · · ·',
              hintStyle:
                  TextStyle(color: _textLight, fontSize: 26, letterSpacing: 10),
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
                  borderSide: const BorderSide(color: _sage, width: 2)),
              contentPadding: const EdgeInsets.symmetric(vertical: 20),
            ),
          ),
          const SizedBox(height: 20),
          if (_errorMessage != null) ...[
            _errorBanner(),
            const SizedBox(height: 16)
          ],
          _submitButton('Verify & Log In', _verifyOtp),
          const SizedBox(height: 14),
          Center(
            child: GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    const Text('A new code has been requested from the admin.'),
                backgroundColor: _teal,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              )),
              child: RichText(
                text: TextSpan(
                  text: 'Didn\'t receive a code? ',
                  style: const TextStyle(color: _textMid, fontSize: 13.5),
                  children: [
                    TextSpan(
                        text: 'Request again',
                        style: TextStyle(
                            color: _teal, fontWeight: FontWeight.w700))
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
      const SizedBox(height: 16),
      _signInLink(),
    ]);
  }

  Widget _processStep(
      String number, String title, String desc, Color color, Color light,
      {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Column(children: [
          Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(color: light, shape: BoxShape.circle),
              child: Center(
                  child: Text(number,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w800,
                          fontSize: 13)))),
          if (!isLast)
            Container(
                width: 2,
                height: 24,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: _border),
        ]),
        const SizedBox(width: 14),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(top: 4),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(
                    color: _textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 13.5)),
            const SizedBox(height: 2),
            Text(desc,
                style: const TextStyle(
                    color: _textMid, fontSize: 12.5, height: 1.4)),
          ]),
        )),
      ]),
    );
  }
}
