import 'package:flutter/material.dart';

class EmergencyResourcesScreen extends StatefulWidget {
  const EmergencyResourcesScreen({super.key});

  @override
  State<EmergencyResourcesScreen> createState() =>
      _EmergencyResourcesScreenState();
}

class _EmergencyResourcesScreenState
    extends State<EmergencyResourcesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;

  // ── Palette ───────────────────────────────────────────────────────────────
  static const Color _bg         = Color(0xFFF6F4F0);
  static const Color _surface    = Color(0xFFFFFFFF);
  static const Color _sageLight  = Color(0xFFD4EAD7);
  static const Color _teal       = Color(0xFF4A9EAF);
  static const Color _tealLight  = Color(0xFFD6EEF3);
  static const Color _lavender   = Color(0xFF9B8EC4);
  static const Color _lavLight   = Color(0xFFEAE6F5);
  static const Color _red        = Color(0xFFD94F4F);
  static const Color _redLight   = Color(0xFFFAE0E0);
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7280);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  final List<Map<String, dynamic>> _emergencyContacts = [
    {
      'name': 'National Suicide Prevention Lifeline',
      'number': '1-800-273-8255',
      'available': '24/7',
      'emoji': '📞',
      'services': 'Suicide prevention & crisis counseling',
      'color': Color(0xFF7CA982),
      'light': Color(0xFFD4EAD7),
    },
    {
      'name': 'SAMHSA National Helpline',
      'number': '1-800-662-4357',
      'available': '24/7',
      'emoji': '🆘',
      'services': 'Substance abuse treatment referral',
      'color': Color(0xFF4A9EAF),
      'light': Color(0xFFD6EEF3),
    },
    {
      'name': 'Crisis Text Line',
      'number': 'Text HOME to 741741',
      'available': '24/7',
      'emoji': '💬',
      'services': 'Text-based crisis support',
      'color': Color(0xFF9B8EC4),
      'light': Color(0xFFEAE6F5),
    },
    {
      'name': 'Narcotics Anonymous Hotline',
      'number': '1-888-624-4426',
      'available': '24/7',
      'emoji': '🤝',
      'services': 'NA meeting information & support',
      'color': Color(0xFFE8926A),
      'light': Color(0xFFFAE2D5),
    },
    {
      'name': 'Alcoholics Anonymous',
      'number': '1-212-647-1680',
      'available': '24/7',
      'emoji': '🏥',
      'services': 'AA meeting listings & support',
      'color': Color(0xFFF4C542),
      'light': Color(0xFFFDF3CC),
    },
  ];

  final List<Map<String, dynamic>> _copingStrategies = [
    {
      'title': 'Immediate Coping Strategies',
      'emoji': '🧘',
      'color': Color(0xFF4A9EAF),
      'light': Color(0xFFD6EEF3),
      'items': [
        'Remove yourself from the trigger',
        'Call your sponsor or support person',
        'Go to see your counsellor immediately',
        'Visit an emergency support group meeting',
        'Practice deep breathing exercises',
        'Go for a walk or run',
        'Talk to someone you trust',
        'Journal about your feelings',
      ],
    },
    {
      'title': 'If You\'re in a Severe Crisis',
      'emoji': '🆘',
      'color': Color(0xFFD94F4F),
      'light': Color(0xFFFAE0E0),
      'items': [
        'Call 911 immediately',
        'Go to the nearest emergency room',
        'Tell someone what you\'re experiencing',
        'Stay in a safe place',
        'Call a crisis hotline',
        'Do not isolate yourself',
        'Reach out to your treatment team',
        'Focus on staying alive — recovery is possible',
      ],
    },
  ];

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

  // ── Contact Detail Sheet ──────────────────────────────────────────────────

  void _showContactDetail(Map<String, dynamic> contact) {
    final color = contact['color'] as Color;
    final light = contact['light'] as Color;

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
            _handle(),

            // Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                  color: light, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Text(contact['emoji'],
                      style: const TextStyle(fontSize: 44)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      '${contact['available']} Available',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Text(contact['name'],
                style: const TextStyle(
                    color: _textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    height: 1.3),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(contact['services'],
                style: const TextStyle(color: _textMid, fontSize: 13.5),
                textAlign: TextAlign.center),
            const SizedBox(height: 18),

            // Number chip
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: light,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_rounded, color: color, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    contact['number'],
                    style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Calling ${contact['number']}…'),
                    backgroundColor: color,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              icon: const Icon(Icons.phone_rounded),
              label: const Text('Contact Now',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 911 Confirm Sheet ─────────────────────────────────────────────────────

  void _show911Confirm() {
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
            _handle(),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: _redLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  Text('🚨', style: TextStyle(fontSize: 48)),
                  SizedBox(height: 8),
                  Text('Emergency Call',
                      style: TextStyle(
                          color: Color(0xFFD94F4F),
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This will open your phone dialer to call 911. Only use this in a genuine emergency.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _textMid, fontSize: 14, height: 1.5),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Please call 911 for emergency support'),
                        backgroundColor: _red,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  icon: const Icon(Icons.phone_rounded, size: 18),
                  label: const Text('Call 911',
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _handle() => Center(
        child: Container(
          width: 40, height: 4,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              color: _border, borderRadius: BorderRadius.circular(2)),
        ),
      );

  Widget _card({required Widget child, EdgeInsets? padding}) => Container(
        width: double.infinity,
        padding: padding ?? const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );

  Widget _sectionHeader(
      String title, IconData icon, Color accent, Color accentLight) =>
      Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: accentLight, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: accent, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                color: _textDark,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
      ]);

  // ── Contact Card ──────────────────────────────────────────────────────────

  Widget _buildContactCard(Map<String, dynamic> contact) {
    final color = contact['color'] as Color;
    final light = contact['light'] as Color;

    return GestureDetector(
      onTap: () => _showContactDetail(contact),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left strip
            Container(
              width: 5,
              height: 76,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20)),
              ),
            ),
            const SizedBox(width: 14),

            // Emoji
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                  color: light, borderRadius: BorderRadius.circular(14)),
              child: Center(
                child: Text(contact['emoji'],
                    style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),

            // Text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(contact['name'],
                        style: const TextStyle(
                            color: _textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 1.3)),
                    const SizedBox(height: 4),
                    Text(contact['number'],
                        style: TextStyle(
                            color: color,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 2),
                    Row(children: [
                      Icon(Icons.access_time_rounded,
                          size: 11, color: _textLight),
                      const SizedBox(width: 3),
                      Text(contact['available'],
                          style: const TextStyle(
                              color: _textLight, fontSize: 11)),
                    ]),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: light, borderRadius: BorderRadius.circular(10)),
                child:
                    Icon(Icons.phone_rounded, color: color, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Strategy Card ─────────────────────────────────────────────────────────

  Widget _buildStrategyCard(Map<String, dynamic> strategy) {
    final color = strategy['color'] as Color;
    final light = strategy['light'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 3),
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
                  color: light, borderRadius: BorderRadius.circular(10)),
              child:
                  Text(strategy['emoji'], style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(strategy['title'],
                  style: const TextStyle(
                      color: _textDark,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700)),
            ),
          ]),
          const SizedBox(height: 14),
          ...(strategy['items'] as List<String>).asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                            color: light, shape: BoxShape.circle),
                        child: Center(
                          child: Text('${e.key + 1}',
                              style: TextStyle(
                                  color: color,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(e.value,
                              style: const TextStyle(
                                  color: _textMid,
                                  fontSize: 13.5,
                                  height: 1.4)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
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
        title: const Text('Emergency & Crisis',
            style: TextStyle(
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

              // ── Crisis Alert Banner ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_red, Color(0xFFC23A3A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: _red.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.warning_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('In Crisis Right Now?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800)),
                          SizedBox(height: 4),
                          Text(
                            'You don\'t have to face this alone.\nHelp is available right now.',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12.5,
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── 911 Button ───────────────────────────────────────────────
              GestureDetector(
                onTap: _show911Confirm,
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: _red, shape: BoxShape.circle),
                        child: const Icon(Icons.phone_rounded,
                            color: Colors.white, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Call 911 Now',
                              style: TextStyle(
                                  color: Color(0xFFD94F4F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800)),
                          Text('For life-threatening emergencies',
                              style: TextStyle(
                                  color: _red.withValues(alpha: 0.7),
                                  fontSize: 12)),
                        ],
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right_rounded,
                          color: _red.withValues(alpha: 0.5)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Emergency Contacts ───────────────────────────────────────
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionHeader('Emergency Contacts',
                        Icons.contact_phone_rounded, _teal, _tealLight),
                    const SizedBox(height: 16),
                    ..._emergencyContacts
                        .map((c) => _buildContactCard(c)),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Coping Strategies ────────────────────────────────────────
              _sectionHeader('Coping Strategies',
                  Icons.psychology_rounded, _lavender, _lavLight),
              const SizedBox(height: 14),
              ..._copingStrategies.map((s) => _buildStrategyCard(s)),

              const SizedBox(height: 8),

              // ── Hope Message ─────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _sageLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: const [
                    Text('🌿', style: TextStyle(fontSize: 32)),
                    SizedBox(height: 10),
                    Text(
                      '"Your life has value. Recovery is possible.\nYou deserve help and support.\nPlease reach out — we\'re here."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF5A8A60),
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
