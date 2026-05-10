import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _notificationsEnabled = true;
  bool _soundEnabled         = true;
  bool _shareData            = false;

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
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _card({required Widget child, EdgeInsets? padding}) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: padding != null
            ? Padding(padding: padding, child: child)
            : child,
      );

  Widget _sectionHeader(
      String title, IconData icon, Color accent, Color accentLight) =>
      Padding(
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
                  fontSize: 17,
                  fontWeight: FontWeight.w700)),
        ]),
      );

  Widget _tileRow(
      IconData icon, String label, String value, Color accent, Color light,
      {bool isLast = false}) =>
      Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: light,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: accent, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              color: _textLight, fontSize: 11.5)),
                      const SizedBox(height: 2),
                      Text(value,
                          style: const TextStyle(
                              color: _textDark,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(height: 1, color: _border, indent: 16, endIndent: 16),
        ],
      );

  Widget _navTile(String title, IconData icon, Color accent, Color light,
      VoidCallback onTap,
      {bool isLast = false}) =>
      GestureDetector(
        onTap: onTap,
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
                        color: light,
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

  Widget _switchTile(String title, String subtitle, bool value,
      Function(bool) onChanged, Color accent,
      {bool isLast = false}) =>
      Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      Text(subtitle,
                          style: const TextStyle(
                              color: _textLight, fontSize: 11.5)),
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
          if (!isLast)
            Divider(height: 1, color: _border, indent: 16, endIndent: 16),
        ],
      );

  // ── Edit Profile Sheet ────────────────────────────────────────────────────

  void _showEditProfileSheet() {
    final nameController  = TextEditingController(text: 'Alex Thompson');
    final emailController = TextEditingController(text: 'alex.thompson@email.com');
    final phoneController = TextEditingController(text: '+1 (555) 123-4567');

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
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
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: _tealLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.edit_rounded, color: _teal, size: 18),
                ),
                const SizedBox(width: 10),
                const Text('Edit Profile',
                    style: TextStyle(
                        color: _textDark,
                        fontSize: 18,
                        fontWeight: FontWeight.w800)),
              ]),
              const SizedBox(height: 20),
              _sheetInput(nameController, 'Full Name', Icons.badge_outlined),
              const SizedBox(height: 12),
              _sheetInput(emailController, 'Email Address',
                  Icons.mail_outline_rounded,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _sheetInput(phoneController, 'Phone Number',
                  Icons.phone_outlined,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Profile updated! 🌿'),
                      backgroundColor: _sage,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Save Changes',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sheetInput(
    TextEditingController c,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) =>
      TextField(
        controller: c,
        keyboardType: keyboardType,
        style: const TextStyle(color: _textDark, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _textLight),
          prefixIcon: Icon(icon, color: _textLight, size: 20),
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
              borderSide: const BorderSide(color: _teal, width: 1.5)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      );

  // ── Logout Sheet ──────────────────────────────────────────────────────────

  void _showLogoutSheet() {
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
              child: const Column(children: [
                Text('👋', style: TextStyle(fontSize: 44)),
                SizedBox(height: 8),
                Text('Log Out',
                    style: TextStyle(
                        color: Color(0xFFD94F4F),
                        fontSize: 20,
                        fontWeight: FontWeight.w800)),
              ]),
            ),
            const SizedBox(height: 16),
            const Text(
              'Are you sure you want to logout?\nYou can log back in anytime.',
              textAlign: TextAlign.center,
              style: TextStyle(
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
                  child: const Text('Cancel',
                      style: TextStyle(fontWeight: FontWeight.w700)),
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
                  label: const Text('Logout',
                      style: TextStyle(fontWeight: FontWeight.w700)),
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
        title: const Text('Profile Settings',
            style: TextStyle(
                color: _textDark,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: _showEditProfileSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                    color: _tealLight,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  Icon(Icons.edit_rounded, color: _teal, size: 15),
                  const SizedBox(width: 4),
                  Text('Edit',
                      style: TextStyle(
                          color: _teal,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
          ),
        ],
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

              // ── Profile Hero Card ────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(24),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7CA982), Color(0xFF4A9EAF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _sage.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_rounded,
                            color: Color(0xFF7CA982), size: 38),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text('Alex Thompson',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('Member since March 2026',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.check_circle_rounded,
                              color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text('47 Days Sober',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Mini stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _miniStat('47', 'Days'),
                        Container(
                            width: 1, height: 30,
                            color: Colors.white24),
                        _miniStat('23', 'Journal'),
                        Container(
                            width: 1, height: 30,
                            color: Colors.white24),
                        _miniStat('12', 'Meetings'),
                        Container(
                            width: 1, height: 30,
                            color: Colors.white24),
                        _miniStat('95%', 'Meds'),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Personal Information ─────────────────────────────────────
              _sectionHeader('Personal Information',
                  Icons.person_rounded, _teal, _tealLight),
              _card(
                child: Column(children: [
                  _tileRow(Icons.mail_outline_rounded, 'Email',
                      'alex.thompson@email.com', _teal, _tealLight),
                  _tileRow(Icons.phone_outlined, 'Phone',
                      '+1 (555) 123-4567', _teal, _tealLight),
                  _tileRow(Icons.cake_rounded, 'Date of Birth',
                      'January 15, 1990', _teal, _tealLight),
                  _tileRow(Icons.location_on_rounded, 'Location',
                      'San Francisco, CA', _teal, _tealLight,
                      isLast: true),
                ]),
              ),

              // ── Recovery Information ─────────────────────────────────────
              _sectionHeader('Recovery Information',
                  Icons.favorite_rounded, _sage, _sageLight),
              _card(
                child: Column(children: [
                  _tileRow(Icons.person_outline_rounded,
                      'Primary Counsellor', 'Sarah Johnson', _sage, _sageLight),
                  _tileRow(Icons.psychology_rounded, 'Recovery Type',
                      'Addiction Recovery', _sage, _sageLight),
                  _tileRow(Icons.group_rounded, 'Support Group',
                      'Weekly Recovery Meeting', _sage, _sageLight,
                      isLast: true),
                ]),
              ),

              // ── Emergency Contacts ───────────────────────────────────────
              _sectionHeader('Emergency Contacts',
                  Icons.contact_phone_rounded, _peach, _peachLight),
              _card(
                child: Column(children: [
                  _emergencyTile('John Thompson (Brother)',
                      'Primary Contact', '+1 (555) 987-6543', _peach, _peachLight),
                  _emergencyTile('Michael Davis', 'Sponsor',
                      '+1 (555) 555-5555', _peach, _peachLight),
                  _emergencyTile('Dr. Sarah Johnson', 'Therapist',
                      '+1 (555) 123-4567', _peach, _peachLight,
                      isLast: true),
                ]),
              ),

              // ── Recovery Goals ───────────────────────────────────────────
              _sectionHeader('Recovery Goals',
                  Icons.emoji_events_rounded, _gold, _goldLight),
              _card(
                child: Column(children: [
                  _goalTile('Achieve 90-day sobriety', 'Primary Goal',
                      '47 / 90 days', 47 / 90, _sage, _sageLight),
                  _goalTile('Attend 20 support group meetings',
                      'Secondary Goal', '12 / 20', 12 / 20, _teal, _tealLight),
                  _goalTile('Repair family relationships',
                      'Personal Goal', 'In Progress', 0.5, _lavender, _lavLight,
                      isLast: true),
                ]),
              ),

              // ── Current Medications ──────────────────────────────────────
              _sectionHeader('Current Medications',
                  Icons.medication_rounded, _lavender, _lavLight),
              _card(
                child: Column(children: [
                  _medTile('Naltrexone', '50 mg', 'Daily', _teal, _tealLight),
                  _medTile('Sertraline', '100 mg', 'Daily', _lavender, _lavLight,
                      isLast: true),
                ]),
              ),

              // ── Preferences ──────────────────────────────────────────────
              _sectionHeader('Preferences',
                  Icons.tune_rounded, _teal, _tealLight),
              _card(
                child: Column(children: [
                  _switchTile('Push Notifications',
                      'Receive reminders and updates', _notificationsEnabled,
                      (v) => setState(() => _notificationsEnabled = v), _teal),
                  _switchTile('Sound Effects',
                      'Play sounds for alerts', _soundEnabled,
                      (v) => setState(() => _soundEnabled = v), _teal),
                  _switchTile('Share Progress Data',
                      'Help improve the app anonymously', _shareData,
                      (v) => setState(() => _shareData = v), _teal,
                      isLast: true),
                ]),
              ),

              // ── Account Settings ─────────────────────────────────────────
              _sectionHeader('Account Settings',
                  Icons.manage_accounts_rounded, _peach, _peachLight),
              _card(
                child: Column(children: [
                  _navTile('Change Password', Icons.lock_rounded,
                      _peach, _peachLight, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Password change coming soon'),
                        backgroundColor: _peach,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }),
                  _navTile('Privacy Settings', Icons.privacy_tip_rounded,
                      _peach, _peachLight, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Privacy settings coming soon'),
                        backgroundColor: _peach,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }),
                  _navTile('App Version', Icons.info_outline_rounded,
                      _peach, _peachLight, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Version 1.0.0'),
                        backgroundColor: _peach,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  }, isLast: true),
                ]),
              ),

              // ── Logout Button ────────────────────────────────────────────
              GestureDetector(
                onTap: _showLogoutSheet,
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: _redLight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration:
                            BoxDecoration(color: _red, shape: BoxShape.circle),
                        child: const Icon(Icons.logout_rounded,
                            color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Text('Logout',
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

  // ── Specialty tiles ───────────────────────────────────────────────────────

  Widget _emergencyTile(String name, String role, String phone,
      Color accent, Color light,
      {bool isLast = false}) =>
      Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                      color: light, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.person_rounded, color: accent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              color: _textDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 13.5)),
                      const SizedBox(height: 2),
                      Text(role,
                          style: const TextStyle(
                              color: _textLight, fontSize: 11.5)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: light,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.phone_rounded, color: accent, size: 13),
                      const SizedBox(width: 4),
                      Text(phone.replaceAll('+1 ', ''),
                          style: TextStyle(
                              color: accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(height: 1, color: _border, indent: 16, endIndent: 16),
        ],
      );

  Widget _goalTile(String desc, String label, String progress, double value,
      Color accent, Color light,
      {bool isLast = false}) =>
      Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(desc,
                        style: const TextStyle(
                            color: _textDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5)),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: light,
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(progress,
                          style: TextStyle(
                              color: accent,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(label,
                    style: const TextStyle(
                        color: _textLight, fontSize: 11.5)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: value,
                    color: accent,
                    backgroundColor: light,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(height: 1, color: _border, indent: 16, endIndent: 16),
        ],
      );

  Widget _medTile(String name, String dosage, String frequency,
      Color accent, Color light,
      {bool isLast = false}) =>
      Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                      color: light, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.medication_rounded,
                      color: accent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              color: _textDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                      Text('$dosage · $frequency',
                          style: const TextStyle(
                              color: _textMid, fontSize: 12.5)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                      color: _sageLight,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('Active',
                      style: TextStyle(
                          color: _sage,
                          fontSize: 11,
                          fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(height: 1, color: _border, indent: 16, endIndent: 16),
        ],
      );

  Widget _miniStat(String value, String label) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 10.5)),
        ],
      );
}