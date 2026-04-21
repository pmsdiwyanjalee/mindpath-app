import 'package:flutter/material.dart';
import 'dart:math' as math;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;
  String _activeRoute = '/dashboard';
  String? _selectedMood;
  late String _currentAffirmation;
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  // ── Dynamic Stats ────────────────────────────────────────────────────────
  int _soberDays = 47;
  int _currentStreak = 47;
  int _totalSessions = 3;
  double _sobrietyProgress = 0.47; // 47 out of 100 days to next milestone
  final int _nextMilestoneDays = 100;
  
  // Track if stats have been updated today to prevent multiple increments
  bool _statsUpdatedToday = false;

  // ── Palette ──────────────────────────────────────────────────────────────
  static const Color _bg         = Color(0xFFF6F4F0);        // warm off-white
  static const Color _surface    = Color(0xFFFFFFFF);
  static const Color _sage       = Color(0xFF7CA982);        // healing green
  static const Color _sageLight  = Color(0xFFD4EAD7);
  static const Color _teal       = Color(0xFF4A9EAF);        // calm teal
  static const Color _tealLight  = Color(0xFFD6EEF3);
  static const Color _peach      = Color(0xFFE8926A);        // warm accent
  static const Color _peachLight = Color(0xFFFAE2D5);
  static const Color _lavender   = Color(0xFF9B8EC4);        // soft purple
  static const Color _lavLight   = Color(0xFFEAE6F5);
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7280);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);
  static const Color _gold       = Color(0xFFF4C542);

  final List<String> _affirmations = [
    '"Recovery is not a race. You don\'t have to feel guilty if it takes you longer than you thought it would."',
    '"Your courage to change your life is admirable. Keep going, you\'ve got this."',
    '"Every sober day is a victory. Celebrate your progress, no matter how small."',
    '"You are stronger than your urges. You have the power to choose a better path."',
    '"Recovery is about becoming the best version of yourself. You\'re on the right track."',
    '"One day at a time. That\'s all you need to focus on right now."',
    '"Your past does not define your future. You are capable of amazing things."',
    '"The support you give yourself matters. Be kind to yourself on this journey."',
  ];

  @override
  void initState() {
    super.initState();
    _currentAffirmation = _affirmations[0];
    
    // Check if we need to update stats for a new day
    _checkAndUpdateDailyStats();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // ── Daily Stats Update Logic ─────────────────────────────────────────────
  void _checkAndUpdateDailyStats() {
    // Get last update date from persistent storage (using shared_preferences is better)
    // For this demo, we'll use a simple approach - check if we have a stored date
    // In a real app, use SharedPreferences or a database
    
    // For demo purposes, we'll simulate a daily update check
    // In production, you would store the last update date and compare with today
    final lastUpdateDate = _getLastUpdateDate();
    final today = DateTime.now().toIso8601String().split('T')[0];
    
    if (lastUpdateDate != today && !_statsUpdatedToday) {
      _updateDailyStats();
      _statsUpdatedToday = true;
    }
  }
  
  String _getLastUpdateDate() {
    // This is a mock - in real app, retrieve from SharedPreferences
    // For demo, we'll return a string that can be set
    // You can implement actual persistence using shared_preferences package
    return '';
  }
  
  void _updateDailyStats() {
    setState(() {
      _soberDays++;
      _currentStreak++;
      _sobrietyProgress = _soberDays / _nextMilestoneDays;
      
      // Save the update date (in real app, save to SharedPreferences)
      // _saveLastUpdateDate(DateTime.now().toIso8601String().split('T')[0]);
    });
    
    // Show a congratulatory message for the new milestone
    if (_soberDays == 30 || _soberDays == 60 || _soberDays == 100 || 
        _soberDays == 180 || _soberDays == 365) {
      _showMilestoneCelebration(_soberDays);
    }
  }
  
  void _showMilestoneCelebration(int days) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: _surface,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _sageLight,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.celebration_rounded, color: _sage, size: 48),
            ),
            const SizedBox(height: 16),
            Text(
              '🎉 Milestone Unlocked! 🎉',
              style: TextStyle(
                color: _sage,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$_soberDays Days Sober!',
              style: TextStyle(
                color: _textDark,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Congratulations on reaching this incredible milestone. Your dedication is truly inspiring!',
              textAlign: TextAlign.center,
              style: TextStyle(color: _textMid, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Celebrate', style: TextStyle(color: _sage, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _refreshAffirmation() {
    final random = math.Random().nextInt(_affirmations.length);
    _fadeController.reset();
    setState(() {
      _currentAffirmation = _affirmations[random];
    });
    _fadeController.forward();
  }

  // ── Manual Stats Update Methods ──────────────────────────────────────────
  void _incrementSoberDays() {
    setState(() {
      _soberDays++;
      _currentStreak++;
      _sobrietyProgress = _soberDays / _nextMilestoneDays;
    });
    _showStatsUpdateSnackbar('Sober day added! You\'re at $_soberDays days.');
    
    // Check for milestone
    if (_soberDays == 30 || _soberDays == 60 || _soberDays == 100 || 
        _soberDays == 180 || _soberDays == 365) {
      _showMilestoneCelebration(_soberDays);
    }
  }
  
  void _incrementSessions() {
    setState(() {
      _totalSessions++;
    });
    _showStatsUpdateSnackbar('Session logged! Total sessions: $_totalSessions');
  }
  
  void _resetStreak() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: _surface,
        title: Text('Reset Streak?', style: TextStyle(color: _peach, fontWeight: FontWeight.bold)),
        content: Text(
          'Resetting your streak will set your current streak to 0 while keeping your total sober days. Are you sure?',
          style: TextStyle(color: _textMid),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: _textMid)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStreak = 0;
              });
              Navigator.pop(ctx);
              _showStatsUpdateSnackbar('Streak has been reset to 0. Keep going!');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _peach,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Reset Streak'),
          ),
        ],
      ),
    );
  }
  
  void _editStats() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _StatsEditBottomSheet(
        soberDays: _soberDays,
        currentStreak: _currentStreak,
        totalSessions: _totalSessions,
        onSave: (newSoberDays, newStreak, newSessions) {
          setState(() {
            _soberDays = newSoberDays;
            _currentStreak = newStreak;
            _totalSessions = newSessions;
            _sobrietyProgress = _soberDays / _nextMilestoneDays;
          });
          Navigator.pop(ctx);
          _showStatsUpdateSnackbar('Stats updated successfully!');
        },
      ),
    );
  }
  
  void _showStatsUpdateSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _sage,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Reusable Widgets ─────────────────────────────────────────────────────

  Widget _card({required Widget child, EdgeInsets? padding, Color? color}) {
    return Container(
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

  Widget _sectionLabel(String text, {Color? color}) => Text(
        text,
        style: TextStyle(
          color: color ?? _textDark,
          fontSize: 17,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      );

  // ── Action Cards ─────────────────────────────────────────────────────────

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accent,
    required Color accentLight,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: accentLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accent.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: _textDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(color: _textMid, fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ── Milestone Chip ────────────────────────────────────────────────────────

  Widget _buildMilestoneChip(String text, bool achieved) {
    return GestureDetector(
      onTap: () => _showMilestoneDetails(text, achieved),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: achieved ? _sage : _bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: achieved ? _sage : _border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (achieved) ...[
              const Icon(Icons.check_circle_rounded, color: Colors.white, size: 14),
              const SizedBox(width: 4),
            ],
            Text(
              text,
              style: TextStyle(
                color: achieved ? Colors.white : _textMid,
                fontSize: 12,
                fontWeight: achieved ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Mood Button ───────────────────────────────────────────────────────────

  Widget _buildMoodButton(String emoji, String label, Color sel) {
    final isSelected = _selectedMood == label;
    return GestureDetector(
      onTap: () => setState(() {
        _selectedMood = isSelected ? null : label;
      }),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? sel.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? sel : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? sel : _textMid,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Session Card ──────────────────────────────────────────────────────────

  Widget _buildSessionCard(String title, String time, IconData icon, Color accent) {
    return GestureDetector(
      onTap: () => _showSessionDetails(title, time),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accent, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: _textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    time,
                    style: TextStyle(color: _textMid, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: _textLight, size: 22),
          ],
        ),
      ),
    );
  }

  // ── Stat Pill with Edit Support ───────────────────────────────────────────

  Widget _statPill(String value, String label, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: _textMid, fontSize: 12)),
        ],
      ),
    );
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  void _showMilestoneDetails(String milestone, bool achieved) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BottomSheet(
        title: 'Milestone: $milestone',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  achieved ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: achieved ? _sage : _peach,
                ),
                const SizedBox(width: 8),
                Text(
                  achieved ? 'Achieved ✓' : 'In Progress',
                  style: TextStyle(
                    color: achieved ? _sage : _peach,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              achieved
                  ? 'Congratulations! You\'ve reached this important milestone in your recovery journey.'
                  : 'Keep pushing! You\'re on your way to reaching this milestone. Every day brings you closer.',
              style: TextStyle(color: _textMid, height: 1.5),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _sageLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Benefits of this milestone',
                      style: TextStyle(color: _sage, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  for (final b in [
                    'Improved physical health',
                    'Better mental clarity',
                    'Stronger relationships',
                    'Increased self-confidence',
                  ])
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.eco_rounded, color: _sage, size: 14),
                          const SizedBox(width: 6),
                          Text(b, style: TextStyle(color: _textMid, fontSize: 13)),
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

  void _showSessionDetails(String title, String time) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BottomSheet(
        title: title,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time_rounded, color: _teal, size: 18),
                const SizedBox(width: 8),
                Text(time, style: TextStyle(color: _textMid)),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _tealLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'This is a confidential session. You\'ll have the opportunity to discuss your recovery progress, challenges, and goals.',
                style: TextStyle(color: _teal, fontSize: 13, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Session cancelled.')),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _peach,
                      side: BorderSide(color: _peach),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      _incrementSessions(); // Increment sessions when confirming a session
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Session confirmed!')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _sage,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showJournalDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _BottomSheet(
          title: 'Recovery Journal',
          child: Column(
            children: [
              TextField(
                controller: controller,
                maxLines: 5,
                style: TextStyle(color: _textDark),
                decoration: InputDecoration(
                  hintText: 'How are you feeling today? What challenges did you face?',
                  hintStyle: TextStyle(color: _textLight),
                  filled: true,
                  fillColor: _bg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: _border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: _border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: _sage),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Journal entry saved!')),
                      );
                      Navigator.pop(ctx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _sage,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: const Text('Save Entry', style: TextStyle(fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSupportGroupsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BottomSheet(
        title: 'Support Groups',
        child: Column(
          children: [
            for (final g in [
              ['Weekly Recovery Meeting', 'Every Friday, 7:00 PM', _sage],
              ['Peer Support Circle', 'Every Tuesday, 6:00 PM', _teal],
              ['Family Support Group', 'Every Saturday, 2:00 PM', _lavender],
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: (g[2] as Color).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: (g[2] as Color).withOpacity(0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.group_rounded, color: g[2] as Color),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(g[0] as String,
                              style: TextStyle(
                                  color: _textDark, fontWeight: FontWeight.w600)),
                          Text(g[1] as String,
                              style: TextStyle(color: _textMid, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCrisisSupportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BottomSheet(
        title: '🆘 Crisis Support',
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _peachLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                'If you\'re in immediate danger, please call emergency services (911) or go to your nearest emergency room.',
                style: TextStyle(color: _peach, fontSize: 13, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 14),
            for (final h in [
              ['National Crisis Hotline', '1-800-950-NAMI (6264)'],
              ['Suicide Prevention Lifeline', '988'],
              ['SAMHSA Helpline', '1-800-662-HELP (4357)'],
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _peachLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.phone_rounded, color: _peach, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(h[0],
                              style: TextStyle(
                                  color: _textDark, fontWeight: FontWeight.w600, fontSize: 13)),
                          Text(h[1],
                              style: TextStyle(color: _peach, fontSize: 13, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BottomSheet(
        title: 'Settings',
        child: Column(
          children: [
            for (final s in [
              [Icons.notifications_rounded, 'Notifications', 'Manage reminder settings'],
              [Icons.privacy_tip_rounded, 'Privacy', 'Data and privacy settings'],
              [Icons.help_rounded, 'Help & Support', 'FAQs and contact support'],
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: BorderSide(color: _border),
                  ),
                  leading: Icon(s[0] as IconData, color: _teal),
                  title: Text(s[1] as String,
                      style: TextStyle(color: _textDark, fontWeight: FontWeight.w600)),
                  subtitle: Text(s[2] as String,
                      style: TextStyle(color: _textMid, fontSize: 12)),
                  trailing: Icon(Icons.chevron_right_rounded, color: _textLight),
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${s[1]} coming soon!')),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _logMood(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BottomSheet(
        title: 'Mood Logged! 🎉',
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _tealLight,
                shape: BoxShape.circle,
              ),
              child: Text(
                _selectedMood == 'Great'
                    ? '😊'
                    : _selectedMood == 'Okay'
                        ? '😐'
                        : _selectedMood == 'Struggling'
                            ? '😔'
                            : '😢',
                style: const TextStyle(fontSize: 48),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedMood ?? 'Great',
              style: TextStyle(
                color: _teal,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your mood has been recorded. Keep up the great work tracking your emotional well-being!',
              style: TextStyle(color: _textMid, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => _selectedMood = null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: const Text('Thank you!', style: TextStyle(fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Drawer ────────────────────────────────────────────────────────────────

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: _surface,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_sage, _teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      child: const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person_rounded,
                            color: Color(0xFF7CA982), size: 28),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Alex Thompson',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            )),
                        const SizedBox(height: 4),
                        Text('$_soberDays Days Sober 🌱',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              children: [
                _buildDrawerItem(context, Icons.dashboard_rounded, 'Dashboard', '/dashboard'),
                _buildDrawerItem(context, Icons.trending_up_rounded, 'Progress & Statistics', '/progress'),
                _buildDrawerItem(context, Icons.book_rounded, 'Journal Entries', '/journal'),
                _buildDrawerItem(context, Icons.warning_rounded, 'Craving Tracker', '/cravings'),
                _buildDrawerItem(context, Icons.calendar_today_rounded, 'Appointments', '/appointments'),
                _buildDrawerItem(context, Icons.chat_rounded, 'Chat with Counsellor', '/chat'),
                _buildDrawerItem(context, Icons.library_books_rounded, 'Resources', '/resources'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Divider(color: _border),
                ),
                _buildDrawerItem(context, Icons.health_and_safety_rounded, 'Wellness & Health', '/wellness'),
                _buildDrawerItem(context, Icons.people_rounded, 'Support Group Directory', '/support-groups'),
                _buildDrawerItem(context, Icons.emoji_events_rounded, 'Achievements & Badges', '/achievements'),
                _buildDrawerItem(context, Icons.psychology_rounded, 'Coping Skills Library', '/coping-skills'),
                _buildDrawerItem(context, Icons.forum_rounded, 'Community Forum', '/community'),
                _buildDrawerItem(context, Icons.star_rounded, 'Success Stories', '/success-stories'),
                _buildDrawerItem(context, Icons.medication_rounded, 'Medication Tracker', '/medications'),
                _buildDrawerItem(context, Icons.notifications_rounded, 'Notifications', '/notifications'),
                _buildDrawerItem(context, Icons.emergency_rounded, 'Emergency Resources', '/emergency'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Divider(color: _border),
                ),
                _buildDrawerItem(context, Icons.person_rounded, 'Profile Settings', '/profile'),
                _buildDrawerItem(context, Icons.settings_rounded, 'App Settings', '/settings'),
                _buildDrawerItem(context, Icons.logout_rounded, 'Logout', '/', isLogout: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, IconData icon, String title, String route,
      {bool isLogout = false}) {
    final isSelected = !isLogout && _activeRoute == route;
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        color: isLogout ? _peach : (isSelected ? _sage : _textMid),
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? _peach : (isSelected ? _sage : _textDark),
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
      selected: isSelected,
      selectedTileColor: _sageLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        Navigator.pop(context);
        if (!isLogout) setState(() => _activeRoute = route);
        if (isLogout) {
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: _bg,
      drawer: _buildDrawer(context),
      onDrawerChanged: (isOpened) => setState(() => _isDrawerOpen = isOpened),
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: _surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.menu_rounded,
                  color: _isDrawerOpen ? _sage : _textDark),
              onPressed: () {
                if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
                  Navigator.pop(context);
                } else {
                  _scaffoldKey.currentState?.openDrawer();
                }
              },
            ),
            actions: [
              IconButton(
                icon: Stack(
                  children: [
                    Icon(Icons.notifications_rounded, color: _textDark),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _peach,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                onPressed: () => Navigator.pushNamed(context, '/notifications'),
              ),
              IconButton(
                icon: Icon(Icons.edit_note_rounded, color: _textDark),
                onPressed: _editStats,
                tooltip: 'Edit Stats',
              ),
              IconButton(
                icon: Icon(Icons.logout_rounded, color: _textDark),
                onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_sage, _teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
                    child: Row(
                      children: [
                        ScaleTransition(
                          scale: _pulseAnimation,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.25),
                            ),
                            child: const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.self_improvement_rounded,
                                  color: Color(0xFF7CA982), size: 28),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Welcome Back, Alex',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                )),
                            const SizedBox(height: 4),
                            Text('$_soberDays days strong — you\'re doing amazing 🌿',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12.5)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  // ── Stats Row with Edit Actions ─────────────────────────
                  _card(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statPill(
                          '$_soberDays', 
                          'Days Sober', 
                          _sage,
                          onTap: _incrementSoberDays,
                        ),
                        Container(width: 1, height: 40, color: _border),
                        GestureDetector(
                          onLongPress: _resetStreak,
                          child: _statPill(
                            '$_currentStreak', 
                            'Day Streak', 
                            _teal,
                          ),
                        ),
                        Container(width: 1, height: 40, color: _border),
                        _statPill(
                          '$_totalSessions', 
                          'Sessions', 
                          _lavender,
                          onTap: _incrementSessions,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Hint text for stats interaction
                  Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      '💡 Tap "Days Sober" or "Sessions" to add • Long press "Day Streak" to reset',
                      style: TextStyle(color: _textLight, fontSize: 10),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // ── Sobriety Journey ───────────────────────────────────
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: _sageLight,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(Icons.calendar_today_rounded,
                                      color: _sage, size: 18),
                                ),
                                const SizedBox(width: 10),
                                _sectionLabel('Sobriety Journey'),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: _sageLight,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('${(_sobrietyProgress * 100).toInt()}%',
                                  style: TextStyle(
                                    color: _sage,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: _sobrietyProgress.clamp(0.0, 1.0),
                            color: _sage,
                            backgroundColor: _sageLight,
                            minHeight: 10,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('$_soberDays of $_nextMilestoneDays days to your next milestone',
                            style: TextStyle(color: _textMid, fontSize: 12.5)),
                        const SizedBox(height: 14),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildMilestoneChip('7 Days', _soberDays >= 7),
                            _buildMilestoneChip('30 Days', _soberDays >= 30),
                            _buildMilestoneChip('60 Days', _soberDays >= 60),
                            _buildMilestoneChip('100 Days', _soberDays >= 100),
                            _buildMilestoneChip('180 Days', _soberDays >= 180),
                            _buildMilestoneChip('365 Days', _soberDays >= 365),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Daily Affirmation ──────────────────────────────────
                  GestureDetector(
                    onTap: _refreshAffirmation,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_lavender, const Color(0xFF7B6DB0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: _lavender.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.auto_awesome_rounded,
                                      color: _gold, size: 22),
                                  const SizedBox(width: 8),
                                  const Text('Daily Affirmation',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                              GestureDetector(
                                onTap: _refreshAffirmation,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.refresh_rounded,
                                      color: Colors.white, size: 18),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          FadeTransition(
                            opacity: _fadeAnimation,
                            child: Text(
                              _currentAffirmation,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                height: 1.6,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text('Tap to refresh',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Daily Check-in / Mood ──────────────────────────────
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _tealLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.mood_rounded,
                                  color: _teal, size: 18),
                            ),
                            const SizedBox(width: 10),
                            _sectionLabel('Daily Check-in'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('How are you feeling today?',
                            style: TextStyle(color: _textMid, fontSize: 13.5)),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildMoodButton('😊', 'Great', _sage),
                            _buildMoodButton('😐', 'Okay', _teal),
                            _buildMoodButton('😔', 'Struggling', _lavender),
                            _buildMoodButton('😢', 'Need Help', _peach),
                          ],
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: () {
                            if (_selectedMood != null) {
                              _logMood(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Please select a mood first')),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 0,
                          ),
                          child: const Text('Log My Mood',
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Quick Actions ──────────────────────────────────────
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _peachLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.grid_view_rounded,
                                  color: _peach, size: 18),
                            ),
                            const SizedBox(width: 10),
                            _sectionLabel('Quick Actions'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          crossAxisCount: 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.05,
                          children: [
                            _buildActionCard(
                              icon: Icons.chat_rounded,
                              title: 'Chat\nSupport',
                              subtitle: 'Counsellor',
                              accent: _teal,
                              accentLight: _tealLight,
                              onTap: () => Navigator.pushNamed(context, '/chat'),
                            ),
                            _buildActionCard(
                              icon: Icons.book_rounded,
                              title: 'Recovery\nJournal',
                              subtitle: 'Log thoughts',
                              accent: _sage,
                              accentLight: _sageLight,
                              onTap: () => _showJournalDialog(context),
                            ),
                            _buildActionCard(
                              icon: Icons.library_books_rounded,
                              title: 'Resources',
                              subtitle: 'Articles',
                              accent: _lavender,
                              accentLight: _lavLight,
                              onTap: () =>
                                  Navigator.pushNamed(context, '/resources'),
                            ),
                            _buildActionCard(
                              icon: Icons.group_rounded,
                              title: 'Support\nGroups',
                              subtitle: 'Connect',
                              accent: _peach,
                              accentLight: _peachLight,
                              onTap: () => _showSupportGroupsDialog(context),
                            ),
                            _buildActionCard(
                              icon: Icons.sos_rounded,
                              title: 'Crisis\nSupport',
                              subtitle: 'Emergency',
                              accent: Colors.red.shade400,
                              accentLight: Colors.red.shade50,
                              onTap: () => _showCrisisSupportDialog(context),
                            ),
                            _buildActionCard(
                              icon: Icons.edit_note_rounded,
                              title: 'Edit\nStats',
                              subtitle: 'Update data',
                              accent: _textMid,
                              accentLight: _bg,
                              onTap: _editStats,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Upcoming Sessions ──────────────────────────────────
                  _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _lavLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.event_rounded,
                                  color: _lavender, size: 18),
                            ),
                            const SizedBox(width: 10),
                            _sectionLabel('Upcoming Sessions'),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _buildSessionCard(
                          'Counselling Session',
                          'Tomorrow, 2:00 PM',
                          Icons.video_call_rounded,
                          _teal,
                        ),
                        const SizedBox(height: 8),
                        _buildSessionCard(
                          'Support Group Meeting',
                          'Friday, 7:00 PM',
                          Icons.group_rounded,
                          _sage,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Footer Quote ───────────────────────────────────────
                  Text(
                    '"The only way out is through. Keep going, you\'ve got this." 🌟',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 13.5,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
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
}

// ── Reusable Bottom Sheet ─────────────────────────────────────────────────────

class _BottomSheet extends StatelessWidget {
  final String title;
  final Widget child;

  const _BottomSheet({required this.title, required this.child});

  static const Color _textDark = Color(0xFF2D3142);
  static const Color _textMid  = Color(0xFF6B7280);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E5E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: _textDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ── Stats Edit Bottom Sheet ──────────────────────────────────────────────────

class _StatsEditBottomSheet extends StatefulWidget {
  final int soberDays;
  final int currentStreak;
  final int totalSessions;
  final Function(int, int, int) onSave;

  const _StatsEditBottomSheet({
    required this.soberDays,
    required this.currentStreak,
    required this.totalSessions,
    required this.onSave,
  });

  @override
  State<_StatsEditBottomSheet> createState() => _StatsEditBottomSheetState();
}

class _StatsEditBottomSheetState extends State<_StatsEditBottomSheet> {
  late TextEditingController _soberController;
  late TextEditingController _streakController;
  late TextEditingController _sessionsController;

  @override
  void initState() {
    super.initState();
    _soberController = TextEditingController(text: widget.soberDays.toString());
    _streakController = TextEditingController(text: widget.currentStreak.toString());
    _sessionsController = TextEditingController(text: widget.totalSessions.toString());
  }

  @override
  void dispose() {
    _soberController.dispose();
    _streakController.dispose();
    _sessionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BottomSheet(
      title: 'Edit Recovery Stats',
      child: Column(
        children: [
          _buildStatField('Total Sober Days', _soberController, Icons.calendar_today),
          const SizedBox(height: 12),
          _buildStatField('Current Streak', _streakController, Icons.local_fire_department),
          const SizedBox(height: 12),
          _buildStatField('Total Sessions', _sessionsController, Icons.video_call),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF6B7280),
                    side: const BorderSide(color: Color(0xFFE8E5E0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final sober = int.tryParse(_soberController.text) ?? 0;
                    final streak = int.tryParse(_streakController.text) ?? 0;
                    final sessions = int.tryParse(_sessionsController.text) ?? 0;
                    widget.onSave(sober, streak, sessions);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CA982),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatField(String label, TextEditingController controller, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4F0),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E5E0)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        style: const TextStyle(color: Color(0xFF2D3142), fontSize: 16, fontWeight: FontWeight.w600),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF6B7280), fontSize: 13),
          prefixIcon: Icon(icon, color: const Color(0xFF4A9EAF), size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}