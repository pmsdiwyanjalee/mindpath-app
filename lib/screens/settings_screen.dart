import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mind_path/locale_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with SingleTickerProviderStateMixin {
  bool _notificationsEnabled = true;
  bool _soundEnabled         = true;
  bool _dataCollection       = false;
  bool _darkMode             = true;
  String _selectedLanguage   = 'English';
  String _selectedTheme      = 'Dark Blue';

  late AnimationController _entranceController;
  late Animation<double>   _fadeAnim;

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
  static const Color _gold       = Color(0xFFF4C542);
  static const Color _goldLight  = Color(0xFFFDF3CC);
  static const Color _red        = Color(0xFFD94F4F);
  static const Color _redLight   = Color(0xFFFAE0E0);
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7280);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim = CurvedAnimation(
        parent: _entranceController, curve: Curves.easeOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale        = Localizations.localeOf(context).languageCode;
    final localizations = AppLocalizations.of(context)!;
    _selectedLanguage = locale == 'si'
        ? localizations.sinhala
        : locale == 'ta'
            ? localizations.tamil
            : localizations.english;
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _changeLanguage(String language) {
    final localizations = AppLocalizations.of(context)!;
    Locale locale;
    if (language == localizations.sinhala) {
      locale = const Locale('si');
    } else if (language == localizations.tamil) {
      locale = const Locale('ta');
    } else {
      locale = const Locale('en');
    }
    LocaleManager.changeLocale(locale);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _card({required Widget child}) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );

  Widget _sectionHeader(
      String title, IconData icon, Color accent, Color accentLight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: accentLight,
              borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: accent, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                color: _textDark,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
      ]),
    );
  }

  // ── Switch Tile ───────────────────────────────────────────────────────────

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    Color accent,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            color: _textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: const TextStyle(
                            color: _textLight, fontSize: 12)),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: accent,
                inactiveThumbColor: _textLight,
                inactiveTrackColor: _border,
              ),
            ],
          ),
        ),
        Divider(height: 1, color: _border, indent: 16, endIndent: 16),
      ],
    );
  }

  // ── Dropdown Tile ─────────────────────────────────────────────────────────

  Widget _buildDropdownTile(
    String title,
    String currentValue,
    List<String> options,
    Function(String) onChanged,
    Color accent,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: _textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
              DropdownButton<String>(
                value: currentValue,
                dropdownColor: _surface,
                underline: const SizedBox(),
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: accent, size: 20),
                style: TextStyle(
                    color: accent,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
                onChanged: (val) {
                  if (val != null) onChanged(val);
                },
                items: options
                    .map((opt) => DropdownMenuItem(
                          value: opt,
                          child: Text(opt,
                              style: const TextStyle(color: _textDark)),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: _border, indent: 16, endIndent: 16),
      ],
    );
  }

  // ── Nav Tile ──────────────────────────────────────────────────────────────

  Widget _buildNavTile(
      String title, IconData icon, Color accent, Color accentLight,
      {bool isLast = false}) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Navigate to $title'),
            backgroundColor: accent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: accentLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: accent, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(title,
                      style: const TextStyle(
                          color: _textDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: _textLight, size: 20),
              ],
            ),
          ),
          if (!isLast)
            Divider(height: 1, color: _border, indent: 16, endIndent: 16),
        ],
      ),
    );
  }

  // ── Info Tile ─────────────────────────────────────────────────────────────

  Widget _buildInfoTile(String label, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: _textMid, fontSize: 14)),
              Text(value,
                  style: const TextStyle(
                      color: _textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        if (!isLast)
          Divider(height: 1, color: _border, indent: 16, endIndent: 16),
      ],
    );
  }

  // ── Logout Confirm Sheet ──────────────────────────────────────────────────

  void _showLogoutConfirm(AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        decoration: const BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: _border,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                  color: _redLight,
                  borderRadius: BorderRadius.circular(20)),
              child: const Column(
                children: [
                  Text('👋', style: TextStyle(fontSize: 44)),
                  SizedBox(height: 8),
                  Text('Log Out',
                      style: TextStyle(
                          color: Color(0xFFD94F4F),
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l.logoutConfirmation,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _textMid, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 20),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _textMid,
                    side: const BorderSide(color: _border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(l.cancel,
                      style:
                          const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  icon: const Icon(Icons.logout_rounded, size: 18),
                  label: Text(l.logout,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final languageOptions = [l.english, l.sinhala, l.tamil];

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l.appSettings,
            style: const TextStyle(
                color: _textDark,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: _border),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Profile Card ─────────────────────────────────────────────
              _card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7CA982), Color(0xFF4A9EAF)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Alex Thompson',
                                style: TextStyle(
                                    color: _textDark,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 3),
                            Text('47 Days Sober 🌱',
                                style: TextStyle(
                                    color: _sage, fontSize: 13)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _sageLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Edit',
                            style: TextStyle(
                                color: _sage,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Notifications ────────────────────────────────────────────
              _sectionHeader(l.notifications,
                  Icons.notifications_rounded, _teal, _tealLight),
              _card(
                child: Column(
                  children: [
                    _buildSwitchTile(
                      l.pushNotifications,
                      l.pushNotificationsDescription,
                      _notificationsEnabled,
                      (v) => setState(() => _notificationsEnabled = v),
                      _teal,
                    ),
                    _buildSwitchTile(
                      l.soundEffects,
                      l.soundEffectsDescription,
                      _soundEnabled,
                      (v) => setState(() => _soundEnabled = v),
                      _teal,
                    ),
                  ],
                ),
              ),

              // ── Display ──────────────────────────────────────────────────
              _sectionHeader(l.display,
                  Icons.palette_rounded, _lavender, _lavLight),
              _card(
                child: Column(
                  children: [
                    _buildSwitchTile(
                      l.darkMode,
                      l.darkModeDescription,
                      _darkMode,
                      (v) => setState(() => _darkMode = v),
                      _lavender,
                    ),
                    _buildDropdownTile(
                      l.themeColor,
                      _selectedTheme,
                      ['Dark Blue', 'Deep Purple', 'Navy'],
                      (v) => setState(() => _selectedTheme = v),
                      _lavender,
                    ),
                    _buildDropdownTile(
                      l.language,
                      _selectedLanguage,
                      languageOptions,
                      (v) {
                        setState(() => _selectedLanguage = v);
                        _changeLanguage(v);
                      },
                      _lavender,
                    ),
                  ],
                ),
              ),

              // ── Privacy & Data ────────────────────────────────────────────
              _sectionHeader(l.dataPrivacy,
                  Icons.shield_rounded, _sage, _sageLight),
              _card(
                child: Column(
                  children: [
                    _buildSwitchTile(
                      l.dataCollection,
                      l.helpImproveAnalytics,
                      _dataCollection,
                      (v) => setState(() => _dataCollection = v),
                      _sage,
                    ),
                    _buildNavTile(l.privacyPolicy, Icons.privacy_tip_rounded,
                        _sage, _sageLight),
                    _buildNavTile(l.termsOfService, Icons.description_rounded,
                        _sage, _sageLight,
                        isLast: true),
                  ],
                ),
              ),

              // ── Account ───────────────────────────────────────────────────
              _sectionHeader(l.account,
                  Icons.manage_accounts_rounded, _peach, _peachLight),
              _card(
                child: Column(
                  children: [
                    _buildNavTile(l.changePassword, Icons.lock_rounded,
                        _peach, _peachLight),
                    _buildNavTile(l.linkedDevices, Icons.devices_rounded,
                        _peach, _peachLight),
                    _buildNavTile(l.dataPrivacy, Icons.security_rounded,
                        _peach, _peachLight,
                        isLast: true),
                  ],
                ),
              ),

              // ── About ─────────────────────────────────────────────────────
              _sectionHeader(l.about,
                  Icons.info_outline_rounded, _gold, _goldLight),
              _card(
                child: Column(
                  children: [
                    _buildInfoTile(l.appVersion, '1.0.0'),
                    _buildInfoTile(l.buildNumberLabel, '1'),
                    _buildInfoTile(l.lastUpdated, 'April 4, 2026',
                        isLast: true),
                  ],
                ),
              ),

              // ── Logout ────────────────────────────────────────────────────
              GestureDetector(
                onTap: () => _showLogoutConfirm(l),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _redLight,
                    borderRadius: BorderRadius.circular(18),
                    border:
                        Border.all(color: _red.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: _red, shape: BoxShape.circle),
                        child: const Icon(Icons.logout_rounded,
                            color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Text(l.logout,
                          style: TextStyle(
                              color: _red,
                              fontSize: 15,
                              fontWeight: FontWeight.w700)),
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