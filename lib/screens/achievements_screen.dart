import 'package:flutter/material.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;
  late Animation<double> _barAnim;

  // ── Palette ───────────────────────────────────────────────────────────────
  static const Color _bg         = Color(0xFFF6F4F0);
  static const Color _surface    = Color(0xFFFFFFFF);
  static const Color _gold       = Color(0xFFF4C542);
  static const Color _goldLight  = Color(0xFFFDF3CC);
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7280);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  // Cycling accent colors for unlocked cards
  static const List<List<Color>> _accentCycle = [
    [Color(0xFF7CA982), Color(0xFFD4EAD7)],
    [Color(0xFF4A9EAF), Color(0xFFD6EEF3)],
    [Color(0xFFF4C542), Color(0xFFFDF3CC)],
    [Color(0xFF9B8EC4), Color(0xFFEAE6F5)],
  ];

  final List<Map<String, dynamic>> _achievements = [
    {
      'title': 'First Steps',
      'description': 'Completed your first day sober',
      'icon': '🎯',
      'unlockedDate': 'March 18, 2026',
      'unlocked': true,
    },
    {
      'title': 'Week Warrior',
      'description': 'Stayed sober for 7 days',
      'icon': '⭐',
      'unlockedDate': 'March 25, 2026',
      'unlocked': true,
    },
    {
      'title': 'Month Master',
      'description': 'Completed 30 days sober',
      'icon': '🏆',
      'unlockedDate': 'April 4, 2026',
      'unlocked': true,
    },
    {
      'title': 'Journal Junkie',
      'description': 'Written 10 journal entries',
      'icon': '📔',
      'unlockedDate': 'April 1, 2026',
      'unlocked': true,
    },
    {
      'title': 'Support Seeker',
      'description': 'Attend 5 support group meetings',
      'icon': '🤝',
      'unlockedDate': null,
      'unlocked': false,
    },
    {
      'title': 'Meditation Master',
      'description': 'Meditate for 100 hours total',
      'icon': '🧘',
      'unlockedDate': null,
      'unlocked': false,
    },
    {
      'title': 'Fitness Champion',
      'description': 'Exercise 50 times this month',
      'icon': '💪',
      'unlockedDate': null,
      'unlocked': false,
    },
    {
      'title': 'Counselling Commitment',
      'description': 'Attend 10 counselling sessions',
      'icon': '💬',
      'unlockedDate': null,
      'unlocked': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeAnim = CurvedAnimation(
        parent: _entranceController, curve: Curves.easeOut);
    _barAnim = CurvedAnimation(
        parent: _entranceController, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  int get _unlockedCount =>
      _achievements.where((a) => a['unlocked'] as bool).length;
  int get _total => _achievements.length;
  double get _progress => _unlockedCount / _total;

  // ── Achievement Detail Sheet ──────────────────────────────────────────────

  void _showDetail(Map<String, dynamic> a, int unlockedIndex) {
    final unlocked = a['unlocked'] as bool;
    final accent   = unlocked
        ? _accentCycle[unlockedIndex % _accentCycle.length][0]
        : _textLight;
    final light    = unlocked
        ? _accentCycle[unlockedIndex % _accentCycle.length][1]
        : _border;

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
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: _border, borderRadius: BorderRadius.circular(2)),
              ),
            ),

            // Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                  color: light, borderRadius: BorderRadius.circular(24)),
              child: Column(
                children: [
                  Text(a['icon'], style: const TextStyle(fontSize: 56)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: unlocked ? accent : _textLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      unlocked ? '✓ Unlocked' : '🔒 Locked',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Text(a['title'],
                style: const TextStyle(
                    color: _textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3),
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(a['description'],
                style: const TextStyle(
                    color: _textMid, fontSize: 14.5, height: 1.5),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),

            if (unlocked) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: light, borderRadius: BorderRadius.circular(16)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today_rounded,
                        color: accent, size: 16),
                    const SizedBox(width: 8),
                    Text('Unlocked on ${a['unlockedDate']}',
                        style: TextStyle(
                            color: accent,
                            fontSize: 13,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _border)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline_rounded,
                        color: _textLight, size: 16),
                    const SizedBox(width: 8),
                    const Text('Complete the challenge to unlock',
                        style: TextStyle(
                            color: _textLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Achievement Card ──────────────────────────────────────────────────────

  Widget _buildAchievementCard(
      Map<String, dynamic> a, bool unlocked, int accentIdx) {
    final accent = unlocked
        ? _accentCycle[accentIdx % _accentCycle.length][0]
        : _textLight;
    final light  = unlocked
        ? _accentCycle[accentIdx % _accentCycle.length][1]
        : _bg;

    return GestureDetector(
      onTap: () => _showDetail(a, accentIdx),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: unlocked ? accent.withValues(alpha: 0.3) : _border,
          ),
          boxShadow: unlocked
              ? [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.1),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Left accent strip
            Container(
              width: 5,
              height: 80,
              decoration: BoxDecoration(
                color: unlocked ? accent : _border,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20)),
              ),
            ),
            const SizedBox(width: 14),

            // Emoji bubble
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                  color: light,
                  borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: Text(a['icon'],
                    style: TextStyle(
                        fontSize: 26,
                        color: unlocked ? null : Colors.black26)),
              ),
            ),
            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a['title'],
                        style: TextStyle(
                          color: unlocked ? _textDark : _textLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(height: 3),
                    Text(a['description'],
                        style: TextStyle(
                          color: unlocked ? _textMid : _textLight,
                          fontSize: 12,
                        )),
                    if (unlocked && a['unlockedDate'] != null) ...[
                      const SizedBox(height: 5),
                      Row(children: [
                        Icon(Icons.calendar_today_rounded,
                            color: accent, size: 11),
                        const SizedBox(width: 4),
                        Text(a['unlockedDate'],
                            style: TextStyle(
                                color: accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ]),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Status icon
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: unlocked
                  ? Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: accent, shape: BoxShape.circle),
                      child: const Icon(Icons.check_rounded,
                          color: Colors.white, size: 14),
                    )
                  : Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: _border, shape: BoxShape.circle),
                      child: const Icon(Icons.lock_rounded,
                          color: _textLight, size: 14),
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
    final unlocked = _achievements
        .where((a) => a['unlocked'] as bool)
        .toList();
    final locked = _achievements
        .where((a) => !(a['unlocked'] as bool))
        .toList();

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Achievements & Badges',
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

            // ── Hero Progress Banner ─────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF4C542), Color(0xFFE8926A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _gold.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _heroPill('$_unlockedCount', 'Unlocked',
                          Icons.lock_open_rounded),
                      Container(width: 1, height: 44, color: Colors.white24),
                      _heroPill('${_total - _unlockedCount}', 'Remaining',
                          Icons.lock_rounded),
                      Container(width: 1, height: 44, color: Colors.white24),
                      _heroPill(
                          '${(_progress * 100).round()}%',
                          'Complete',
                          Icons.emoji_events_rounded),
                    ],
                  ),
                  const SizedBox(height: 18),
                  AnimatedBuilder(
                    animation: _barAnim,
                    builder: (_, __) => ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _progress * _barAnim.value,
                        color: Colors.white,
                        backgroundColor: Colors.white24,
                        minHeight: 10,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_unlockedCount of $_total achievements unlocked',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Unlocked Showcase (horizontal scroll) ────────────────────
            _sectionHeader('Unlocked Achievements',
                Icons.emoji_events_rounded, _gold, _goldLight),
            const SizedBox(height: 14),

            // Horizontal badge row
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: unlocked.length,
                itemBuilder: (_, i) {
                  final a      = unlocked[i];
                  final accent = _accentCycle[i % _accentCycle.length][0];
                  final light  = _accentCycle[i % _accentCycle.length][1];
                  return GestureDetector(
                    onTap: () => _showDetail(a, i),
                    child: Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: light,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: accent.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(a['icon'],
                              style: const TextStyle(fontSize: 30)),
                          const SizedBox(height: 6),
                          Text(
                            a['title'],
                            style: TextStyle(
                                color: accent,
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // ── Unlocked List ────────────────────────────────────────────
            ...unlocked.asMap().entries.map((e) =>
                _buildAchievementCard(e.value, true, e.key)),

            const SizedBox(height: 8),

            // ── Locked Section ────────────────────────────────────────────
            _sectionHeader('Locked Achievements',
                Icons.lock_rounded, _textLight, _bg),
            const SizedBox(height: 14),
            ...locked.asMap().entries.map((e) =>
                _buildAchievementCard(e.value, false, e.key)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _heroPill(String value, String label, IconData icon) => Column(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1)),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      );

  Widget _sectionHeader(
      String title, IconData icon, Color accent, Color accentLight) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: accentLight, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: accent, size: 18),
      ),
      const SizedBox(width: 10),
      Text(title,
          style: const TextStyle(
              color: _textDark, fontSize: 17, fontWeight: FontWeight.w700)),
    ]);
  }
}
