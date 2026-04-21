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
  late AnimationController _badgeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _badgeScale;

  // ── Sobriety tracking ─────────────────────────────────────────────────────
  DateTime _sobrietyStart = DateTime.now().subtract(const Duration(days: 47));

  int get _daysSober =>
      DateTime.now().difference(_sobrietyStart).inDays.clamp(0, 99999);
  int get _streak => _daysSober;
  double get _progress => (_daysSober / 100).clamp(0.0, 1.0);

  // ── Daily check-in / mood history ─────────────────────────────────────────
  bool _todayCheckedIn = false;
  final List<Map<String, String>> _moodHistory = [];
  // e.g. {'date': 'Apr 21', 'mood': 'Great', 'emoji': '😊', 'time': '09:30 AM'}

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
  static const Color _gold       = Color(0xFFF4C542);
  static const Color _goldLight  = Color(0xFFFDF3CC);

  // ── Rank System ───────────────────────────────────────────────────────────
  // Each rank has: minDays, name, emoji, gradient colors, description
  static const List<Map<String, dynamic>> _ranks = [
    {
      'minDays': 0,
      'name': 'Seedling',
      'emoji': '🌱',
      'colors': [Color(0xFF9B8EC4), Color(0xFF7CA982)],
      'description': 'Every journey begins with a single step. You\'ve started yours.',
      'next': 7,
    },
    {
      'minDays': 7,
      'name': 'Sprout',
      'emoji': '🌿',
      'colors': [Color(0xFF7CA982), Color(0xFF5A9E6F)],
      'description': 'One week strong! New roots are forming beneath the surface.',
      'next': 30,
    },
    {
      'minDays': 30,
      'name': 'Rising Star',
      'emoji': '⭐',
      'colors': [Color(0xFFF4C542), Color(0xFFE8926A)],
      'description': 'A full month of courage and commitment. You\'re shining!',
      'next': 60,
    },
    {
      'minDays': 60,
      'name': 'Warrior',
      'emoji': '🛡️',
      'colors': [Color(0xFF4A9EAF), Color(0xFF2D7A9C)],
      'description': 'Two months of resilience. You\'ve earned your shield.',
      'next': 100,
    },
    {
      'minDays': 100,
      'name': 'Champion',
      'emoji': '🏆',
      'colors': [Color(0xFFF4C542), Color(0xFFD4A017)],
      'description': '100 days! You are an absolute champion of recovery.',
      'next': 180,
    },
    {
      'minDays': 180,
      'name': 'Phoenix',
      'emoji': '🔥',
      'colors': [Color(0xFFE8926A), Color(0xFFD94F4F)],
      'description': 'Six months — risen from the ashes, stronger than ever.',
      'next': 365,
    },
    {
      'minDays': 365,
      'name': 'Legend',
      'emoji': '🌟',
      'colors': [Color(0xFF9B8EC4), Color(0xFFF4C542)],
      'description': 'One full year. You are an inspiration to everyone around you.',
      'next': null,
    },
  ];

  Map<String, dynamic> get _currentRank {
    Map<String, dynamic> rank = _ranks.first;
    for (final r in _ranks) {
      if (_daysSober >= (r['minDays'] as int)) rank = r;
    }
    return rank;
  }

  Map<String, dynamic>? get _nextRank {
    final next = _currentRank['next'] as int?;
    if (next == null) return null;
    try {
      return _ranks.firstWhere((r) => (r['minDays'] as int) == next);
    } catch (_) {
      return null;
    }
  }

  double get _rankProgress {
    final current = _currentRank['minDays'] as int;
    final next    = _currentRank['next'] as int?;
    if (next == null) return 1.0;
    return ((_daysSober - current) / (next - current)).clamp(0.0, 1.0);
  }

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

    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))
      ..forward();
    _fadeAnimation = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _badgeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _badgeScale = CurvedAnimation(parent: _badgeController, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  void _refreshAffirmation() {
    final random = math.Random().nextInt(_affirmations.length);
    _fadeController.reset();
    setState(() => _currentAffirmation = _affirmations[random]);
    _fadeController.forward();
  }

  String _monthName(int m) =>
      ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][m - 1];

  String _timestamp() {
    final now = DateTime.now();
    final h   = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final min = now.minute.toString().padLeft(2, '0');
    final ap  = now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$min $ap';
  }

  String _todayLabel() {
    final now = DateTime.now();
    return '${_monthName(now.month)} ${now.day}';
  }

  Color _moodColor(String mood) {
    switch (mood) {
      case 'Great':      return _sage;
      case 'Okay':       return _teal;
      case 'Struggling': return _lavender;
      case 'Need Help':  return _peach;
      default:           return _sage;
    }
  }

  // ── Save Mood ─────────────────────────────────────────────────────────────

  void _saveMood() {
    if (_selectedMood == null) return;

    final moodEmojis = {'Great': '😊', 'Okay': '😐', 'Struggling': '😔', 'Need Help': '😢'};

    setState(() {
      // Remove today's entry if already exists (update instead)
      _moodHistory.removeWhere((m) => m['date'] == _todayLabel());
      _moodHistory.insert(0, {
        'date': _todayLabel(),
        'mood': _selectedMood!,
        'emoji': moodEmojis[_selectedMood!] ?? '😊',
        'time': _timestamp(),
      });
      _todayCheckedIn = true;
    });

    _showMoodSavedSheet();
  }

  void _showMoodSavedSheet() {
    final mood  = _selectedMood!;
    final color = _moodColor(mood);
    final light = color.withOpacity(0.12);
    final moodEmojis = {'Great': '😊', 'Okay': '😐', 'Struggling': '😔', 'Need Help': '😢'};
    final emoji = moodEmojis[mood] ?? '😊';

    final messages = {
      'Great':      'Wonderful! Riding this positive energy will carry you far today. 🌿',
      'Okay':       'That\'s completely valid. Steady days are still sober days. Keep going!',
      'Struggling': 'Thank you for being honest. Reach out to someone you trust today. 💙',
      'Need Help':  'You were brave to say so. Please reach out to your counsellor or a crisis line right now. We\'re here.',
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        decoration: const BoxDecoration(
            color: _surface, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(child: Container(width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2)))),

            Center(
              child: Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                child: Text(emoji, style: const TextStyle(fontSize: 52)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Mood Saved! 🎉',
                style: const TextStyle(color: _textDark, fontSize: 20, fontWeight: FontWeight.w800),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text(mood,
                style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withOpacity(0.2))),
              child: Text(messages[mood] ?? '',
                  style: TextStyle(color: _textMid, fontSize: 13.5, height: 1.55),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 16),
            // Check-in streak
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: _sageLight, borderRadius: BorderRadius.circular(14)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.check_circle_rounded, color: _sage, size: 18),
                const SizedBox(width: 8),
                Text('Daily check-in complete · ${_moodHistory.length} day${_moodHistory.length == 1 ? '' : 's'} tracked',
                    style: TextStyle(color: _sage, fontWeight: FontWeight.w700, fontSize: 13)),
              ]),
            ),
            const SizedBox(height: 16),

            if (mood == 'Need Help') ...[
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  _showCrisisSupportDialog(context);
                },
                icon: const Icon(Icons.phone_rounded),
                label: const Text('Get Help Now', style: TextStyle(fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _peach, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0,
                ),
              ),
            ] else ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() => _selectedMood = null);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color, foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0,
                ),
                child: const Text('Done', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ── Rank Badge Sheet ──────────────────────────────────────────────────────

  void _showRankSheet() {
    final rank = _currentRank;
    final next = _nextRank;
    final colors = rank['colors'] as List<Color>;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
              color: _surface, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
            children: [
              Center(child: Container(width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2)))),

              // Badge hero
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(children: [
                  Text(rank['emoji'] as String, style: const TextStyle(fontSize: 64)),
                  const SizedBox(height: 12),
                  Text(rank['name'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text('$_daysSober Days Sober',
                      style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ]),
              ),
              const SizedBox(height: 20),

              Text(rank['description'] as String,
                  style: TextStyle(color: _textMid, fontSize: 15, height: 1.6),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),

              // Progress to next rank
              if (next != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: _bg, borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _border)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('Next Rank: ${next['name']}', style: const TextStyle(color: _textDark, fontWeight: FontWeight.w700)),
                      Text('${next['emoji']}  ${next['minDays']}d', style: TextStyle(color: _textMid, fontSize: 13)),
                    ]),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _rankProgress,
                        color: colors[0],
                        backgroundColor: colors[0].withOpacity(0.15),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${_daysSober - (_currentRank['minDays'] as int)} / ${(next['minDays'] as int) - (_currentRank['minDays'] as int)} days',
                      style: TextStyle(color: _textLight, fontSize: 12),
                    ),
                  ]),
                ),
                const SizedBox(height: 16),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: _goldLight, borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _gold.withOpacity(0.3))),
                  child: Row(children: [
                    Text('🌟', style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(child: Text('You\'ve reached the highest rank! You are a true Legend.',
                        style: TextStyle(color: _textDark, fontWeight: FontWeight.w600, height: 1.4))),
                  ]),
                ),
                const SizedBox(height: 16),
              ],

              // All ranks ladder
              const Text('Rank Ladder', style: TextStyle(color: _textDark, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              ..._ranks.asMap().entries.map((e) {
                final r        = e.value;
                final achieved = _daysSober >= (r['minDays'] as int);
                final isCurrent= r['name'] == _currentRank['name'];
                final rc       = (r['colors'] as List<Color>)[0];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isCurrent ? rc.withOpacity(0.1) : _bg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: isCurrent ? rc.withOpacity(0.4) : _border, width: isCurrent ? 1.5 : 1),
                    ),
                    child: Row(children: [
                      Text(r['emoji'] as String, style: TextStyle(fontSize: 24, color: achieved ? null : Colors.black26)),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Text(r['name'] as String,
                              style: TextStyle(color: achieved ? _textDark : _textLight,
                                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600, fontSize: 13.5)),
                          if (isCurrent) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: rc, borderRadius: BorderRadius.circular(20)),
                              child: const Text('Current', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ]),
                        Text('${r['minDays']}+ days',
                            style: TextStyle(color: _textLight, fontSize: 11.5)),
                      ])),
                      if (achieved)
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: rc, shape: BoxShape.circle),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 12),
                        )
                      else
                        Icon(Icons.lock_rounded, color: _textLight, size: 16),
                    ]),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ── Mood History Sheet ────────────────────────────────────────────────────

  void _showMoodHistorySheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
              color: _surface, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              child: Column(children: [
                Center(child: Container(width: 40, height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2)))),
                Row(children: [
                  Container(padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: _tealLight, borderRadius: BorderRadius.circular(10)),
                      child: Icon(Icons.history_rounded, color: _teal, size: 18)),
                  const SizedBox(width: 10),
                  const Text('Mood History', style: TextStyle(color: _textDark, fontSize: 18, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: _tealLight, borderRadius: BorderRadius.circular(20)),
                    child: Text('${_moodHistory.length} entries', style: TextStyle(color: _teal, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ]),
            ),
            Divider(height: 1, color: _border),
            Expanded(
              child: _moodHistory.isEmpty
                  ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text('🌙', style: const TextStyle(fontSize: 40)),
                      const SizedBox(height: 12),
                      Text('No check-ins yet', style: TextStyle(color: _textDark, fontSize: 17, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Text('Complete your first daily check-in below!', style: TextStyle(color: _textMid)),
                    ]))
                  : ListView.separated(
                      controller: controller,
                      padding: const EdgeInsets.all(20),
                      itemCount: _moodHistory.length,
                      separatorBuilder: (_, __) => Divider(height: 1, color: _border),
                      itemBuilder: (_, i) {
                        final entry = _moodHistory[i];
                        final color = _moodColor(entry['mood']!);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                              child: Center(child: Text(entry['emoji']!, style: const TextStyle(fontSize: 22))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(entry['mood']!,
                                  style: TextStyle(color: _textDark, fontWeight: FontWeight.w700, fontSize: 14)),
                              Text('${entry['date']} · ${entry['time']}',
                                  style: TextStyle(color: _textLight, fontSize: 12)),
                            ])),
                            Container(
                              width: 6, height: 6,
                              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                            ),
                          ]),
                        );
                      },
                    ),
            ),
          ]),
        ),
      ),
    );
  }

  // ── Edit Sobriety Date ────────────────────────────────────────────────────

  void _showEditSobrietySheet() {
    DateTime tempDate = _sobrietyStart;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Container(
          padding: EdgeInsets.only(
              left: 20, right: 20, top: 12,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 32),
          decoration: const BoxDecoration(
              color: _surface, borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Center(child: Container(width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2)))),
            Row(children: [
              Container(padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: _sageLight, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.edit_calendar_rounded, color: _sage, size: 18)),
              const SizedBox(width: 10),
              const Text('Update Sobriety Date',
                  style: TextStyle(color: _textDark, fontSize: 18, fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 8),
            Text('Set your sobriety start date to auto-calculate Days Sober & Streak.',
                style: TextStyle(color: _textMid, fontSize: 13, height: 1.4)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: _sageLight, borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _sage.withOpacity(0.3))),
              child: Row(children: [
                Icon(Icons.calendar_today_rounded, color: _sage, size: 20),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Start Date', style: TextStyle(color: _textMid, fontSize: 12)),
                  Text('${_monthName(tempDate.month)} ${tempDate.day}, ${tempDate.year}',
                      style: TextStyle(color: _sage, fontSize: 16, fontWeight: FontWeight.w800)),
                ])),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: _sage, borderRadius: BorderRadius.circular(20)),
                  child: Text('${DateTime.now().difference(tempDate).inDays.clamp(0, 99999)} days',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              ]),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: ctx,
                  initialDate: tempDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  builder: (context, child) => Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(primary: _sage, onPrimary: Colors.white, surface: _surface, onSurface: _textDark),
                    ),
                    child: child!,
                  ),
                );
                if (picked != null) setSheet(() => tempDate = picked);
              },
              icon: Icon(Icons.date_range_rounded, color: _teal),
              label: Text('Pick a Date', style: TextStyle(color: _teal, fontWeight: FontWeight.w700)),
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _teal),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => setSheet(() => tempDate = DateTime.now()),
              icon: Icon(Icons.restart_alt_rounded, color: _peach),
              label: Text('Reset to Today (Relapse)', style: TextStyle(color: _peach, fontWeight: FontWeight.w700)),
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _peach),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _sobrietyStart = tempDate;
                  _todayCheckedIn = false;
                  _badgeController.reset();
                  _badgeController.forward();
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    tempDate.isAfter(DateTime.now().subtract(const Duration(hours: 1)))
                        ? 'Sobriety clock reset. You\'ve got this! 💪'
                        : '${DateTime.now().difference(tempDate).inDays} days strong 🌿',
                  ),
                  backgroundColor: _sage,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _sage, foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0,
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
      ),
    );
  }

  // ── Other dialogs ─────────────────────────────────────────────────────────

  void _showMilestoneDetails(String milestone, bool achieved) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (ctx) => _BottomSheet(
        title: 'Milestone: $milestone',
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(achieved ? Icons.check_circle : Icons.radio_button_unchecked, color: achieved ? _sage : _peach),
            const SizedBox(width: 8),
            Text(achieved ? 'Achieved ✓' : 'In Progress',
                style: TextStyle(color: achieved ? _sage : _peach, fontSize: 16, fontWeight: FontWeight.w700)),
          ]),
          const SizedBox(height: 12),
          Text(
            achieved ? 'Congratulations! You\'ve reached this important milestone in your recovery journey.'
                : 'Keep pushing! Every day brings you closer.',
            style: TextStyle(color: _textMid, height: 1.5),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _sageLight, borderRadius: BorderRadius.circular(14)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Benefits of this milestone', style: TextStyle(color: _sage, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              for (final b in ['Improved physical health', 'Better mental clarity', 'Stronger relationships', 'Increased self-confidence'])
                Padding(padding: const EdgeInsets.only(top: 4), child: Row(children: [
                  Icon(Icons.eco_rounded, color: _sage, size: 14),
                  const SizedBox(width: 6),
                  Text(b, style: TextStyle(color: _textMid, fontSize: 13)),
                ])),
            ]),
          ),
        ]),
      ),
    );
  }

  void _showSessionDetails(String title, String time) {
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent,
      builder: (ctx) => _BottomSheet(
        title: title,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.access_time_rounded, color: _teal, size: 18),
            const SizedBox(width: 8),
            Text(time, style: TextStyle(color: _textMid)),
          ]),
          const SizedBox(height: 16),
          Container(padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: _tealLight, borderRadius: BorderRadius.circular(14)),
              child: Text('This is a confidential session. You\'ll discuss your recovery progress, challenges, and goals.',
                  style: TextStyle(color: _teal, fontSize: 13, height: 1.5))),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: OutlinedButton(
              onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session cancelled.'))); },
              style: OutlinedButton.styleFrom(foregroundColor: _peach, side: BorderSide(color: _peach),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 14)),
              child: const Text('Cancel'),
            )),
            const SizedBox(width: 12),
            Expanded(child: ElevatedButton(
              onPressed: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Session confirmed!'))); },
              style: ElevatedButton.styleFrom(backgroundColor: _sage, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 14), elevation: 0),
              child: const Text('Confirm'),
            )),
          ]),
        ]),
      ),
    );
  }

  void _showJournalDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showModalBottomSheet(
      context: context, backgroundColor: Colors.transparent, isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: _BottomSheet(title: 'Recovery Journal', child: Column(children: [
          TextField(controller: ctrl, maxLines: 5, style: TextStyle(color: _textDark),
              decoration: InputDecoration(
                hintText: 'How are you feeling today? What challenges did you face?',
                hintStyle: TextStyle(color: _textLight), filled: true, fillColor: _bg,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: _border)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: _border)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: _sage)),
              )),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () { if (ctrl.text.isNotEmpty) { ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Journal entry saved!'))); Navigator.pop(ctx); } },
            style: ElevatedButton.styleFrom(backgroundColor: _sage, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), padding: const EdgeInsets.symmetric(vertical: 16), elevation: 0),
            child: const Text('Save Entry', style: TextStyle(fontSize: 15)),
          )),
        ])),
      ),
    );
  }

  void _showSupportGroupsDialog(BuildContext context) {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent,
      builder: (ctx) => _BottomSheet(title: 'Support Groups', child: Column(children: [
        for (final g in [
          ['Weekly Recovery Meeting', 'Every Friday, 7:00 PM', _sage],
          ['Peer Support Circle', 'Every Tuesday, 6:00 PM', _teal],
          ['Family Support Group', 'Every Saturday, 2:00 PM', _lavender],
        ])
          Padding(padding: const EdgeInsets.only(bottom: 10), child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: (g[2] as Color).withOpacity(0.08), borderRadius: BorderRadius.circular(14), border: Border.all(color: (g[2] as Color).withOpacity(0.2))),
            child: Row(children: [
              Icon(Icons.group_rounded, color: g[2] as Color),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(g[0] as String, style: TextStyle(color: _textDark, fontWeight: FontWeight.w600)),
                Text(g[1] as String, style: TextStyle(color: _textMid, fontSize: 12)),
              ]),
            ]),
          )),
      ])),
    );
  }

  void _showCrisisSupportDialog(BuildContext context) {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent,
      builder: (ctx) => _BottomSheet(title: '🆘 Crisis Support', child: Column(children: [
        Container(padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _peachLight, borderRadius: BorderRadius.circular(14)),
            child: Text('If you\'re in immediate danger, call emergency services (911) or go to your nearest emergency room.',
                style: TextStyle(color: _peach, fontSize: 13, height: 1.5), textAlign: TextAlign.center)),
        const SizedBox(height: 14),
        for (final h in [
          ['National Crisis Hotline', '1-800-950-NAMI (6264)'],
          ['Suicide Prevention Lifeline', '988'],
          ['SAMHSA Helpline', '1-800-662-HELP (4357)'],
        ])
          Padding(padding: const EdgeInsets.only(bottom: 10), child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(14), border: Border.all(color: _border)),
            child: Row(children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: _peachLight, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.phone_rounded, color: _peach, size: 20)),
              const SizedBox(width: 12),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(h[0], style: TextStyle(color: _textDark, fontWeight: FontWeight.w600, fontSize: 13)),
                Text(h[1], style: TextStyle(color: _peach, fontSize: 13, fontWeight: FontWeight.w700)),
              ]),
            ]),
          )),
      ])),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showModalBottomSheet(context: context, backgroundColor: Colors.transparent,
      builder: (ctx) => _BottomSheet(title: 'Settings', child: Column(children: [
        for (final s in [
          [Icons.notifications_rounded, 'Notifications', 'Manage reminder settings'],
          [Icons.privacy_tip_rounded, 'Privacy', 'Data and privacy settings'],
          [Icons.help_rounded, 'Help & Support', 'FAQs and contact support'],
        ])
          Padding(padding: const EdgeInsets.only(bottom: 8), child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: _border)),
            leading: Icon(s[0] as IconData, color: _teal),
            title: Text(s[1] as String, style: TextStyle(color: _textDark, fontWeight: FontWeight.w600)),
            subtitle: Text(s[2] as String, style: TextStyle(color: _textMid, fontSize: 12)),
            trailing: Icon(Icons.chevron_right_rounded, color: _textLight),
            onTap: () { Navigator.pop(ctx); ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${s[1]} coming soon!'))); },
          )),
      ])),
    );
  }

  // ── Helper Widgets ────────────────────────────────────────────────────────

  Widget _card({required Widget child, EdgeInsets? padding, Color? color}) => Container(
    padding: padding ?? const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: color ?? _surface, borderRadius: BorderRadius.circular(24),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))],
    ),
    child: child,
  );

  Widget _sectionLabel(String text, {Color? color}) => Text(text,
      style: TextStyle(color: color ?? _textDark, fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: -0.3));

  Widget _statPill(String value, String label, Color color) => Column(children: [
    Text(value, style: TextStyle(color: color, fontSize: 26, fontWeight: FontWeight.w800, height: 1)),
    const SizedBox(height: 4),
    Text(label, style: TextStyle(color: _textMid, fontSize: 12)),
  ]);

  Widget _buildActionCard({required IconData icon, required String title, required String subtitle, required Color accent, required Color accentLight, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(color: accentLight, borderRadius: BorderRadius.circular(16), border: Border.all(color: accent.withOpacity(0.2))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Container(width: 36, height: 36, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: Colors.white, size: 19)),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(color: _textDark, fontSize: 11.5, fontWeight: FontWeight.w700, height: 1.2)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: _textMid, fontSize: 10), overflow: TextOverflow.ellipsis, maxLines: 1),
          ]),
        ),
      ),
    );
  }

  Widget _buildMilestoneChip(String text, bool achieved) {
    return GestureDetector(
      onTap: () => _showMilestoneDetails(text, achieved),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: achieved ? _sage : _bg, borderRadius: BorderRadius.circular(20),
          border: Border.all(color: achieved ? _sage : _border),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (achieved) ...[const Icon(Icons.check_circle_rounded, color: Colors.white, size: 14), const SizedBox(width: 4)],
          Text(text, style: TextStyle(color: achieved ? Colors.white : _textMid, fontSize: 12, fontWeight: achieved ? FontWeight.w700 : FontWeight.w500)),
        ]),
      ),
    );
  }

  Widget _buildMoodButton(String emoji, String label, Color sel) {
    final isSelected = _selectedMood == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedMood = isSelected ? null : label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? sel.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? sel : Colors.transparent, width: 2),
        ),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: isSelected ? sel : _textMid, fontSize: 11, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500)),
        ]),
      ),
    );
  }

  Widget _buildSessionCard(String title, String time, IconData icon, Color accent) {
    return GestureDetector(
      onTap: () => _showSessionDetails(title, time),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _bg, borderRadius: BorderRadius.circular(16), border: Border.all(color: _border)),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: accent.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: accent, size: 22)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(color: _textDark, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(time, style: TextStyle(color: _textMid, fontSize: 12)),
          ])),
          Icon(Icons.chevron_right_rounded, color: _textLight, size: 22),
        ]),
      ),
    );
  }

  // ── Drawer ────────────────────────────────────────────────────────────────

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: _surface,
      child: Column(children: [
        Container(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          decoration: BoxDecoration(gradient: LinearGradient(colors: [_sage, _teal], begin: Alignment.topLeft, end: Alignment.bottomRight)),
          child: Row(children: [
            Container(padding: const EdgeInsets.all(3), decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.3)),
                child: const CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Icon(Icons.person_rounded, color: Color(0xFF7CA982), size: 28))),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Alex Thompson', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text('47 Days Sober 🌱', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ]),
          ]),
        ),
        Expanded(child: ListView(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8), children: [
          _buildDrawerItem(context, Icons.dashboard_rounded, 'Dashboard', '/dashboard'),
          _buildDrawerItem(context, Icons.trending_up_rounded, 'Progress & Statistics', '/progress'),
          _buildDrawerItem(context, Icons.book_rounded, 'Journal Entries', '/journal'),
          _buildDrawerItem(context, Icons.warning_rounded, 'Craving Tracker', '/cravings'),
          _buildDrawerItem(context, Icons.calendar_today_rounded, 'Appointments', '/appointments'),
          _buildDrawerItem(context, Icons.chat_rounded, 'Chat with Counsellor', '/chat'),
          _buildDrawerItem(context, Icons.library_books_rounded, 'Resources', '/resources'),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: Divider(color: _border)),
          _buildDrawerItem(context, Icons.health_and_safety_rounded, 'Wellness & Health', '/wellness'),
          _buildDrawerItem(context, Icons.people_rounded, 'Support Group Directory', '/support-groups'),
          _buildDrawerItem(context, Icons.emoji_events_rounded, 'Achievements & Badges', '/achievements'),
          _buildDrawerItem(context, Icons.psychology_rounded, 'Coping Skills Library', '/coping-skills'),
          _buildDrawerItem(context, Icons.forum_rounded, 'Community Forum', '/community'),
          _buildDrawerItem(context, Icons.star_rounded, 'Success Stories', '/success-stories'),
          _buildDrawerItem(context, Icons.medication_rounded, 'Medication Tracker', '/medications'),
          _buildDrawerItem(context, Icons.notifications_rounded, 'Notifications', '/notifications'),
          _buildDrawerItem(context, Icons.emergency_rounded, 'Emergency Resources', '/emergency'),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), child: Divider(color: _border)),
          _buildDrawerItem(context, Icons.person_rounded, 'Profile Settings', '/profile'),
          _buildDrawerItem(context, Icons.settings_rounded, 'App Settings', '/settings'),
          _buildDrawerItem(context, Icons.logout_rounded, 'Logout', '/', isLogout: true),
        ])),
      ]),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String route, {bool isLogout = false}) {
    final isSelected = !isLogout && _activeRoute == route;
    return ListTile(
      dense: true,
      leading: Icon(icon, color: isLogout ? _peach : (isSelected ? _sage : _textMid), size: 22),
      title: Text(title, style: TextStyle(color: isLogout ? _peach : (isSelected ? _sage : _textDark), fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500, fontSize: 14)),
      selected: isSelected, selectedTileColor: _sageLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onTap: () {
        Navigator.pop(context);
        if (!isLogout) setState(() => _activeRoute = route);
        if (isLogout) { Navigator.pushReplacementNamed(context, route); } else { Navigator.pushNamed(context, route); }
      },
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final rank     = _currentRank;
    final rankColors = rank['colors'] as List<Color>;
    final milestones = [
      ['7 Days',   _daysSober >= 7],
      ['30 Days',  _daysSober >= 30],
      ['60 Days',  _daysSober >= 60],
      ['100 Days', _daysSober >= 100],
    ];

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
              icon: Icon(Icons.menu_rounded, color: _isDrawerOpen ? _sage : _textDark),
              onPressed: () {
                if (_scaffoldKey.currentState?.isDrawerOpen ?? false) { Navigator.pop(context); }
                else { _scaffoldKey.currentState?.openDrawer(); }
              },
            ),
            actions: [
              IconButton(
                icon: Stack(children: [
                  Icon(Icons.notifications_rounded, color: _textDark),
                  Positioned(top: 0, right: 0, child: Container(width: 8, height: 8, decoration: BoxDecoration(color: _peach, shape: BoxShape.circle))),
                ]),
                onPressed: () => Navigator.pushNamed(context, '/notifications'),
              ),
              IconButton(icon: Icon(Icons.logout_rounded, color: _textDark), onPressed: () => Navigator.pushReplacementNamed(context, '/')),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: LinearGradient(colors: [_sage, _teal], begin: Alignment.topLeft, end: Alignment.bottomRight)),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
                    child: Row(children: [
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.25)),
                          child: const CircleAvatar(radius: 30, backgroundColor: Colors.white,
                              child: Icon(Icons.self_improvement_rounded, color: Color(0xFF7CA982), size: 28)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: const [
                        Text('Welcome Back, Alex', style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.w800)),
                        SizedBox(height: 4),
                        Text('One day at a time — you\'re doing amazing 🌿', style: TextStyle(color: Colors.white70, fontSize: 12.5)),
                      ]),
                    ]),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                // ── Stats Row ────────────────────────────────────────────
                GestureDetector(
                  onTap: _showEditSobrietySheet,
                  child: _card(child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                      _statPill('$_daysSober', 'Days Sober', _sage),
                      Container(width: 1, height: 40, color: _border),
                      _statPill('$_streak', 'Day Streak', _teal),
                      Container(width: 1, height: 40, color: _border),
                      _statPill('3', 'Sessions', _lavender),
                    ]),
                    const SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.edit_calendar_rounded, color: _textLight, size: 13),
                      const SizedBox(width: 5),
                      Text('Tap to update sobriety date', style: TextStyle(color: _textLight, fontSize: 11.5)),
                    ]),
                  ])),
                ),
                const SizedBox(height: 16),

                // ── RANK BADGE ────────────────────────────────────────────
                GestureDetector(
                  onTap: _showRankSheet,
                  child: ScaleTransition(
                    scale: _badgeScale,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: rankColors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [BoxShadow(color: rankColors[0].withOpacity(0.35), blurRadius: 20, offset: const Offset(0, 6))],
                      ),
                      child: Row(children: [
                        // Badge icon
                        Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                          child: Center(child: Text(rank['emoji'] as String, style: const TextStyle(fontSize: 34))),
                        ),
                        const SizedBox(width: 16),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Your Rank', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text(rank['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 8),
                          // Progress to next rank
                          if (_nextRank != null) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: _rankProgress,
                                color: Colors.white,
                                backgroundColor: Colors.white24,
                                minHeight: 6,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '${((_currentRank['next'] as int) - _daysSober).clamp(0, 999)} days to ${_nextRank!['name']} ${_nextRank!['emoji']}',
                              style: const TextStyle(color: Colors.white70, fontSize: 11),
                            ),
                          ] else
                            const Text('Maximum rank achieved! 🌟', style: TextStyle(color: Colors.white70, fontSize: 11)),
                        ])),
                        const SizedBox(width: 8),
                        Icon(Icons.chevron_right_rounded, color: Colors.white54, size: 20),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Sobriety Journey ──────────────────────────────────────
                _card(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: _sageLight, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.calendar_today_rounded, color: _sage, size: 18)),
                      const SizedBox(width: 10),
                      _sectionLabel('Sobriety Journey'),
                    ]),
                    GestureDetector(
                      onTap: _showEditSobrietySheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: _sageLight, borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          Icon(Icons.edit_rounded, color: _sage, size: 13),
                          const SizedBox(width: 4),
                          Text('${(_progress * 100).round()}%', style: TextStyle(color: _sage, fontSize: 12, fontWeight: FontWeight.w700)),
                        ]),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  ClipRRect(borderRadius: BorderRadius.circular(8), child: LinearProgressIndicator(value: _progress, color: _sage, backgroundColor: _sageLight, minHeight: 10)),
                  const SizedBox(height: 8),
                  Text(_daysSober >= 100 ? '🎉 You\'ve reached 100 days! Amazing!' : '$_daysSober of 100 days to your next milestone', style: TextStyle(color: _textMid, fontSize: 12.5)),
                  const SizedBox(height: 6),
                  Row(children: [
                    Icon(Icons.flag_rounded, color: _sage, size: 13),
                    const SizedBox(width: 4),
                    Text('Started ${_monthName(_sobrietyStart.month)} ${_sobrietyStart.day}, ${_sobrietyStart.year}', style: TextStyle(color: _textLight, fontSize: 11.5)),
                  ]),
                  const SizedBox(height: 14),
                  Wrap(spacing: 8, runSpacing: 8, children: milestones.map((m) => _buildMilestoneChip(m[0] as String, m[1] as bool)).toList()),
                ])),
                const SizedBox(height: 16),

                // ── Daily Affirmation ─────────────────────────────────────
                GestureDetector(
                  onTap: _refreshAffirmation,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [_lavender, const Color(0xFF7B6DB0)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [BoxShadow(color: _lavender.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 6))],
                    ),
                    child: Column(children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Row(children: [Icon(Icons.auto_awesome_rounded, color: _gold, size: 22), const SizedBox(width: 8), const Text('Daily Affirmation', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700))]),
                        GestureDetector(onTap: _refreshAffirmation, child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 18))),
                      ]),
                      const SizedBox(height: 14),
                      FadeTransition(opacity: _fadeAnimation, child: Text(_currentAffirmation, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14, fontStyle: FontStyle.italic, height: 1.6))),
                      const SizedBox(height: 10),
                      Text('Tap to refresh', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 11)),
                    ]),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Daily Check-in ────────────────────────────────────────
                _card(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Row(children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: _tealLight, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.mood_rounded, color: _teal, size: 18)),
                      const SizedBox(width: 10),
                      _sectionLabel('Daily Check-in'),
                    ]),
                    // History button
                    GestureDetector(
                      onTap: _showMoodHistorySheet,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: _tealLight, borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          Icon(Icons.history_rounded, color: _teal, size: 13),
                          const SizedBox(width: 4),
                          Text('History', style: TextStyle(color: _teal, fontSize: 12, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    ),
                  ]),

                  if (_todayCheckedIn) ...[
                    // Already checked in today
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: _sageLight, borderRadius: BorderRadius.circular(14)),
                      child: Row(children: [
                        Icon(Icons.check_circle_rounded, color: _sage, size: 22),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Check-in complete for today!', style: TextStyle(color: _sage, fontWeight: FontWeight.w700, fontSize: 14)),
                          if (_moodHistory.isNotEmpty)
                            Text('Mood: ${_moodHistory.first['emoji']} ${_moodHistory.first['mood']} · ${_moodHistory.first['time']}',
                                style: TextStyle(color: _sage.withOpacity(0.75), fontSize: 12)),
                        ])),
                        GestureDetector(
                          onTap: () => setState(() { _todayCheckedIn = false; _selectedMood = _moodHistory.isNotEmpty ? _moodHistory.first['mood'] : null; }),
                          child: Text('Edit', style: TextStyle(color: _teal, fontSize: 13, fontWeight: FontWeight.w700)),
                        ),
                      ]),
                    ),
                  ] else ...[
                    // Not yet checked in
                    const SizedBox(height: 12),
                    Text('How are you feeling today?', style: TextStyle(color: _textMid, fontSize: 13.5)),
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
                    AnimatedOpacity(
                      opacity: _selectedMood != null ? 1.0 : 0.45,
                      duration: const Duration(milliseconds: 200),
                      child: ElevatedButton(
                        onPressed: _selectedMood != null ? _saveMood : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedMood != null ? _moodColor(_selectedMood!) : _teal,
                          disabledBackgroundColor: _teal.withOpacity(0.4),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0,
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.save_rounded, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            _selectedMood != null ? 'Save My Mood · $_selectedMood' : 'Select a mood above',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ])),
                const SizedBox(height: 16),

                // ── Quick Actions ─────────────────────────────────────────
                _card(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: _peachLight, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.grid_view_rounded, color: _peach, size: 18)),
                    const SizedBox(width: 10),
                    _sectionLabel('Quick Actions'),
                  ]),
                  const SizedBox(height: 14),
                  Row(children: [
                    _buildActionCard(icon: Icons.chat_rounded, title: 'Chat\nSupport', subtitle: 'Counsellor', accent: _teal, accentLight: _tealLight, onTap: () => Navigator.pushNamed(context, '/chat')),
                    const SizedBox(width: 10),
                    _buildActionCard(icon: Icons.book_rounded, title: 'Journal', subtitle: 'Log thoughts', accent: _sage, accentLight: _sageLight, onTap: () => _showJournalDialog(context)),
                    const SizedBox(width: 10),
                    _buildActionCard(icon: Icons.library_books_rounded, title: 'Resources', subtitle: 'Articles', accent: _lavender, accentLight: _lavLight, onTap: () => Navigator.pushNamed(context, '/resources')),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    _buildActionCard(icon: Icons.group_rounded, title: 'Support\nGroups', subtitle: 'Connect', accent: _peach, accentLight: _peachLight, onTap: () => _showSupportGroupsDialog(context)),
                    const SizedBox(width: 10),
                    _buildActionCard(icon: Icons.sos_rounded, title: 'Crisis\nSupport', subtitle: 'Emergency', accent: const Color(0xFFD94F4F), accentLight: const Color(0xFFFAE0E0), onTap: () => _showCrisisSupportDialog(context)),
                    const SizedBox(width: 10),
                    _buildActionCard(icon: Icons.settings_rounded, title: 'Settings', subtitle: 'Preferences', accent: _textMid, accentLight: _bg, onTap: () => _showSettingsDialog(context)),
                  ]),
                ])),
                const SizedBox(height: 16),

                // ── Upcoming Sessions ─────────────────────────────────────
                _card(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  Row(children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: _lavLight, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.event_rounded, color: _lavender, size: 18)),
                    const SizedBox(width: 10),
                    _sectionLabel('Upcoming Sessions'),
                  ]),
                  const SizedBox(height: 14),
                  _buildSessionCard('Counselling Session', 'Tomorrow, 2:00 PM', Icons.video_call_rounded, _teal),
                  const SizedBox(height: 8),
                  _buildSessionCard('Support Group Meeting', 'Friday, 7:00 PM', Icons.group_rounded, _sage),
                ])),
                const SizedBox(height: 24),

                Text('"The only way out is through. Keep going, you\'ve got this." 🌟',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: _textLight, fontSize: 13.5, fontStyle: FontStyle.italic, height: 1.6)),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Bottom Sheet helper ────────────────────────────────────────────────────────

class _BottomSheet extends StatelessWidget {
  final String title;
  final Widget child;
  const _BottomSheet({required this.title, required this.child});

  static const Color _textDark = Color(0xFF2D3142);
  static const Color _border   = Color(0xFFE8E5E0);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(color: Color(0xFFFFFFFF), borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: _border, borderRadius: BorderRadius.circular(2)))),
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(color: _textDark, fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 16),
        child,
      ]),
    );
  }
}