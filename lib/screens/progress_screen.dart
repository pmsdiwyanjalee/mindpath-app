import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({Key? key}) : super(key: key);

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _barController;
  late Animation<double> _barAnimation;

  // ── Palette (mirrors DashboardScreen) ────────────────────────────────────
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
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7280);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  @override
  void initState() {
    super.initState();
    _barController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _barAnimation = CurvedAnimation(
      parent: _barController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _barController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _card({required Widget child, EdgeInsets? padding, Color? color}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? _surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionHeader(String title, IconData icon, Color accent, Color accentLight) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: accentLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: accent, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            color: _textDark,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );
  }

  // ── Stat Cards ────────────────────────────────────────────────────────────

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color accent,
    Color accentLight,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: accent,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: _textMid, fontSize: 12.5)),
        ],
      ),
    );
  }

  // ── Activity Bar ──────────────────────────────────────────────────────────

  Widget _buildActivityDay(String day, int entries) {
    final Color barColor = entries > 5
        ? _sage
        : entries > 3
            ? _teal
            : _border;
    final double maxHeight = 60.0;
    final double barHeight = (entries / 7) * maxHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          '$entries',
          style: TextStyle(
            color: entries > 3 ? _textMid : _textLight,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        AnimatedBuilder(
          animation: _barAnimation,
          builder: (_, __) => Container(
            width: 28,
            height: barHeight * _barAnimation.value,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(day,
            style: const TextStyle(color: _textLight, fontSize: 11)),
      ],
    );
  }

  // ── Achievement Card ──────────────────────────────────────────────────────

  Widget _buildAchievementCard(
    String emoji,
    String title,
    String subtitle,
    bool achieved,
    Color accent,
    Color accentLight,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: achieved ? accentLight : _bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: achieved ? accent.withOpacity(0.25) : _border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: achieved ? accent.withOpacity(0.15) : _border.withOpacity(0.5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(color: _textMid, fontSize: 12)),
              ],
            ),
          ),
          if (achieved)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded,
                  color: Colors.white, size: 14),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _border),
              ),
              child: const Text('Locked',
                  style: TextStyle(color: _textLight, fontSize: 11)),
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Progress & Statistics',
          style: TextStyle(
            color: _textDark,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: _border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            // ── Hero Banner ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_sage, _teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: _sage.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Recovery Overview',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '47 Days Strong 🌱',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        AnimatedBuilder(
                          animation: _barAnimation,
                          builder: (_, __) => ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: 0.47 * _barAnimation.value,
                              color: Colors.white,
                              backgroundColor: Colors.white24,
                              minHeight: 8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          '47% to 100-day milestone',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('🏅', style: TextStyle(fontSize: 36)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Stat Grid ────────────────────────────────────────────────
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildStatCard(
                  'Days Sober',
                  '47',
                  Icons.calendar_today_rounded,
                  _sage,
                  _sageLight,
                ),
                _buildStatCard(
                  'Current Streak',
                  '47 days',
                  Icons.local_fire_department_rounded,
                  _peach,
                  _peachLight,
                ),
                _buildStatCard(
                  'Milestones',
                  '2 / 3',
                  Icons.emoji_events_rounded,
                  _gold,
                  const Color(0xFFFDF3CC),
                ),
                _buildStatCard(
                  'Journal Entries',
                  '23',
                  Icons.book_rounded,
                  _lavender,
                  _lavLight,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // ── Sobriety Progress ────────────────────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _sectionHeader(
                      'Sobriety Progress', Icons.trending_up_rounded, _sage, _sageLight),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('0 days',
                          style: TextStyle(color: _textLight, fontSize: 12)),
                      Text('47 days',
                          style: TextStyle(
                              color: _sage,
                              fontSize: 13,
                              fontWeight: FontWeight.w700)),
                      const Text('100 days goal',
                          style: TextStyle(color: _textLight, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  AnimatedBuilder(
                    animation: _barAnimation,
                    builder: (_, __) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: 0.47 * _barAnimation.value,
                        color: _sage,
                        backgroundColor: _sageLight,
                        minHeight: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _miniMilestone('7 Days', true),
                      const SizedBox(width: 8),
                      _miniMilestone('30 Days', true),
                      const SizedBox(width: 8),
                      _miniMilestone('60 Days', false),
                      const SizedBox(width: 8),
                      _miniMilestone('100 Days', false),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Monthly Activity ─────────────────────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionHeader(
                          'Monthly Activity',
                          Icons.bar_chart_rounded,
                          _teal,
                          _tealLight),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _tealLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'April 2026',
                          style: TextStyle(
                              color: _teal,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildActivityDay('Mon', 5),
                        _buildActivityDay('Tue', 3),
                        _buildActivityDay('Wed', 4),
                        _buildActivityDay('Thu', 6),
                        _buildActivityDay('Fri', 5),
                        _buildActivityDay('Sat', 7),
                        _buildActivityDay('Sun', 4),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _legendDot(_sage, 'High (>5)'),
                      const SizedBox(width: 16),
                      _legendDot(_teal, 'Medium (3–5)'),
                      const SizedBox(width: 16),
                      _legendDot(_border, 'Low (<3)'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Recent Achievements ──────────────────────────────────────
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _sectionHeader('Recent Achievements',
                      Icons.emoji_events_rounded, _gold, const Color(0xFFFDF3CC)),
                  const SizedBox(height: 16),
                  _buildAchievementCard(
                    '🏆',
                    '7-Day Milestone',
                    'Achieved on March 28, 2026',
                    true,
                    _sage,
                    _sageLight,
                  ),
                  _buildAchievementCard(
                    '💪',
                    '30-Day Milestone',
                    'Achieved on April 2, 2026',
                    true,
                    _teal,
                    _tealLight,
                  ),
                  _buildAchievementCard(
                    '📚',
                    '10 Journal Entries',
                    'Keep documenting your journey',
                    true,
                    _lavender,
                    _lavLight,
                  ),
                  _buildAchievementCard(
                    '🌟',
                    '60-Day Milestone',
                    'Keep going — 13 days to go!',
                    false,
                    _peach,
                    _peachLight,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Recovery Insight ─────────────────────────────────────────
            _card(
              color: const Color(0xFFFFF8EC),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFDF3CC),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.lightbulb_rounded,
                            color: _gold, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Recovery Insight',
                        style: TextStyle(
                          color: _textDark,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'You\'re most likely to log in and stay engaged on weekends. Keep that momentum for the rest of the week!',
                    style: TextStyle(
                      color: _textMid,
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _border),
                    ),
                    child: Row(
                      children: [
                        const Text('📈', style: TextStyle(fontSize: 20)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Engagement up 12% compared to last week',
                            style: TextStyle(
                              color: _sage,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniMilestone(String label, bool achieved) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: achieved ? _sage : _bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: achieved ? _sage : _border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (achieved)
              const Padding(
                padding: EdgeInsets.only(right: 3),
                child: Icon(Icons.check_rounded, color: Colors.white, size: 12),
              ),
            Text(
              label,
              style: TextStyle(
                color: achieved ? Colors.white : _textLight,
                fontSize: 10.5,
                fontWeight: achieved ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(color: _textLight, fontSize: 11)),
      ],
    );
  }
}