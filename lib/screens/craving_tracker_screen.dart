import 'package:flutter/material.dart';

class CravingTrackerScreen extends StatefulWidget {
  const CravingTrackerScreen({super.key});

  @override
  State<CravingTrackerScreen> createState() => _CravingTrackerScreenState();
}

class _CravingTrackerScreenState extends State<CravingTrackerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;
  late Animation<double> _barAnim;

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
  static const Color _gold       = Color(0xFFF4C542);
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7280);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  final List<Map<String, dynamic>> _cravings = [
    {
      'time': 'April 4, 2:30 PM',
      'intensity': 3,
      'trigger': 'Work stress',
      'whatHelped': 'Called support person',
      'duration': '10 minutes',
      'managed': true,
    },
    {
      'time': 'April 3, 10:45 AM',
      'intensity': 5,
      'trigger': 'Social gathering',
      'whatHelped': 'Breathing exercises',
      'duration': '15 minutes',
      'managed': true,
    },
    {
      'time': 'April 2, 7:15 PM',
      'intensity': 2,
      'trigger': 'Boredom',
      'whatHelped': 'Physical exercise',
      'duration': '5 minutes',
      'managed': true,
    },
    {
      'time': 'April 1, 4:00 PM',
      'intensity': 4,
      'trigger': 'Difficult conversation',
      'whatHelped': 'Meditation',
      'duration': '12 minutes',
      'managed': true,
    },
  ];

  // Triggers
  static const List<Map<String, dynamic>> _triggers = [
    {'label': 'Work Stress',        'emoji': '💼', 'count': 3},
    {'label': 'Social Situations',  'emoji': '👥', 'count': 2},
    {'label': 'Boredom',            'emoji': '😴', 'count': 1},
    {'label': 'Emotional Pain',     'emoji': '💔', 'count': 2},
  ];

  // Strategies
  static const List<Map<String, dynamic>> _strategies = [
    {'label': 'Call Support Person',  'emoji': '📞', 'count': 3, 'color': Color(0xFF4A9EAF)},
    {'label': 'Breathing Exercises',  'emoji': '🌬️', 'count': 2, 'color': Color(0xFF7CA982)},
    {'label': 'Physical Exercise',    'emoji': '💪', 'count': 1, 'color': Color(0xFF9B8EC4)},
  ];

  // Intensity color
  Color _intensityColor(int i) {
    if (i <= 3) return _sage;
    if (i <= 6) return _gold;
    return _peach;
  }

  int get _total   => _cravings.length;
  int get _managed => _cravings.where((c) => c['managed'] as bool).length;
  int get _successPct => _total == 0 ? 0 : ((_managed / _total) * 100).round();

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _entranceController, curve: Curves.easeOut);
    _barAnim  = CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  // ── Intensity Bar ─────────────────────────────────────────────────────────

  Widget _intensityBar(int intensity, {double height = 8}) {
    return AnimatedBuilder(
      animation: _barAnim,
      builder: (_, __) => Row(
        children: List.generate(10, (i) {
          final filled = i < intensity;
          return Expanded(
            child: Container(
              height: height,
              margin: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                color: filled
                    ? _intensityColor(intensity).withValues(alpha: _barAnim.value)
                    : _border,
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Craving Detail Sheet ──────────────────────────────────────────────────

  void _showCravingDetails(Map<String, dynamic> craving) {
    final intensity = craving['intensity'] as int;
    final iColor    = _intensityColor(intensity);
    final managed   = craving['managed'] as bool;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: managed ? _sageLight : _peachLight,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  managed ? Icons.check_circle_rounded : Icons.warning_rounded,
                  color: managed ? _sage : _peach,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              const Text('Craving Details',
                  style: TextStyle(
                      color: _textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: managed ? _sageLight : _peachLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  managed ? 'Managed ✓' : 'Struggling',
                  style: TextStyle(
                    color: managed ? _sage : _peach,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 20),

            _detailRow(Icons.access_time_rounded, 'Time', craving['time'], _teal),
            const SizedBox(height: 12),
            _detailRow(Icons.bolt_rounded, 'Trigger', craving['trigger'], _peach),
            const SizedBox(height: 12),
            _detailRow(Icons.timer_rounded, 'Duration', craving['duration'], _lavender),
            const SizedBox(height: 12),
            _detailRow(Icons.favorite_rounded, 'What Helped', craving['whatHelped'], _sage),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: iColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: iColor.withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Intensity', style: TextStyle(
                          color: _textDark, fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('$intensity / 10',
                          style: TextStyle(
                              color: iColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 15)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _intensityBar(intensity, height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: _bg, borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border)),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: _textLight, fontSize: 11)),
              Text(value,
                  style: const TextStyle(
                      color: _textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Log Craving Sheet ─────────────────────────────────────────────────────

  void _showLogCravingDialog(BuildContext context) {
    final triggerController = TextEditingController();
    final helpController    = TextEditingController();
    int selectedIntensity   = 0;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: StatefulBuilder(
          builder: (ctx, setSheet) => Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            decoration: const BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _handle(),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: _peachLight,
                        borderRadius: BorderRadius.circular(10)),
                    child:
                        Icon(Icons.add_circle_rounded, color: _peach, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text('Log a Craving',
                      style: TextStyle(
                          color: _textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 20),

                // Intensity picker
                const Text('Intensity',
                    style: TextStyle(
                        color: _textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(10, (i) {
                    final val      = i + 1;
                    final selected = selectedIntensity == val;
                    final color    = _intensityColor(val);
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setSheet(() => selectedIntensity = val),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.only(right: 4),
                          height: 36,
                          decoration: BoxDecoration(
                            color: selected ? color : _bg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: selected ? color : _border),
                          ),
                          child: Center(
                            child: Text('$val',
                                style: TextStyle(
                                  color:
                                      selected ? Colors.white : _textMid,
                                  fontSize: 12,
                                  fontWeight: selected
                                      ? FontWeight.w800
                                      : FontWeight.w500,
                                )),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                _sheetInput(triggerController, 'What triggered this?',
                    Icons.bolt_rounded),
                const SizedBox(height: 12),
                _sheetInput(helpController, 'What will help you right now?',
                    Icons.favorite_rounded),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _cravings.insert(0, {
                        'time': 'Just now',
                        'intensity': selectedIntensity == 0 ? 5 : selectedIntensity,
                        'trigger': triggerController.text.isEmpty
                            ? 'Not specified'
                            : triggerController.text,
                        'whatHelped': helpController.text.isEmpty
                            ? 'Not specified'
                            : helpController.text,
                        'duration': 'Ongoing',
                        'managed': false,
                      });
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            'Craving logged. You can overcome this! 💪'),
                        backgroundColor: _sage,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _peach,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Log Craving',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── SOS Sheet ─────────────────────────────────────────────────────────────

  void _showSOSDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
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
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_peach, Color(0xFFD4634A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: const [
                  Text('🆘', style: TextStyle(fontSize: 40)),
                  SizedBox(height: 10),
                  Text('You\'ve Got This!',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 6),
                  Text('Try one of these right now:',
                      style:
                          TextStyle(color: Colors.white70, fontSize: 13.5)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            for (final tip in [
              ['🫁', 'Take 5 deep breaths', 'Activate your calm response'],
              ['💪', 'Do 10 jumping jacks', 'Move the urge through your body'],
              ['📞', 'Call your support person', 'You don\'t have to face this alone'],
              ['🚶', 'Go for a walk', 'Change your environment, change your state'],
              ['💧', 'Drink water and pause', 'Buy yourself 2 minutes of clarity'],
            ])
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _peachLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _peach.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Text(tip[0], style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tip[1],
                                style: const TextStyle(
                                    color: _textDark,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5)),
                            Text(tip[2],
                                style: const TextStyle(
                                    color: _textMid, fontSize: 11.5)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _sage,
                    side: BorderSide(color: _sage),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('I\'m OK Now',
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
                        content: const Text('Crisis hotline: 988'),
                        backgroundColor: _peach,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  },
                  icon: const Icon(Icons.phone_rounded, size: 18),
                  label: const Text('Call Hotline',
                      style: TextStyle(fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _peach,
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

  // ── Shared helpers ────────────────────────────────────────────────────────

  Widget _handle() => Center(
        child: Container(
          width: 40, height: 4,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              color: _border, borderRadius: BorderRadius.circular(2)),
        ),
      );

  Widget _sheetInput(TextEditingController c, String hint, IconData icon) =>
      TextField(
        controller: c,
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
              borderSide: const BorderSide(color: _peach, width: 1.5)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  Widget _sectionHeader(String title, IconData icon, Color accent, Color accentLight) =>
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
                color: _textDark, fontSize: 17, fontWeight: FontWeight.w700)),
      ]);

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
        title: const Text('Craving Tracker',
            style: TextStyle(
                color: _textDark, fontSize: 17, fontWeight: FontWeight.w700)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _showLogCravingDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                    color: _peach,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(children: const [
                  Icon(Icons.add_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text('Log',
                      style: TextStyle(
                          color: Colors.white,
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

              // ── Hero Stats ───────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _heroPill('$_total', 'Total', Icons.bar_chart_rounded),
                        _vDividerWhite(),
                        _heroPill('$_managed', 'Managed', Icons.check_circle_outline_rounded),
                        _vDividerWhite(),
                        _heroPill('$_successPct%', 'Success', Icons.emoji_events_rounded),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AnimatedBuilder(
                      animation: _barAnim,
                      builder: (_, __) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (_successPct / 100) * _barAnim.value,
                          color: Colors.white,
                          backgroundColor: Colors.white24,
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '$_successPct% of cravings successfully managed',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Common Triggers ──────────────────────────────────────────
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionHeader('Common Triggers',
                        Icons.bolt_rounded, _peach, _peachLight),
                    const SizedBox(height: 16),
                    for (final t in _triggers) ...[
                      _triggerRow(t),
                      if (t != _triggers.last) const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── Craving Log ──────────────────────────────────────────────
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionHeader('Recent Cravings Log',
                        Icons.history_rounded, _teal, _tealLight),
                    const SizedBox(height: 16),
                    for (final c in _cravings) ...[
                      _buildCravingLogCard(c),
                      if (c != _cravings.last) const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── What Works ───────────────────────────────────────────────
              _card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionHeader('What Works for Me',
                        Icons.favorite_rounded, _sage, _sageLight),
                    const SizedBox(height: 16),
                    for (final s in _strategies) ...[
                      _strategyRow(s),
                      if (s != _strategies.last) const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── SOS Button ───────────────────────────────────────────────
              GestureDetector(
                onTap: () => _showSOSDialog(context),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE8926A), Color(0xFFD4634A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _peach.withValues(alpha: 0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Having a Craving NOW?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800)),
                            SizedBox(height: 4),
                            Text(
                              'Tap for immediate coping strategies',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12.5),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white70, size: 20),
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

  // ── Trigger Row ───────────────────────────────────────────────────────────

  Widget _triggerRow(Map<String, dynamic> t) {
    final count  = t['count'] as int;
    final maxBar = 3;
    return Row(
      children: [
        Text(t['emoji'], style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(t['label'],
                  style: const TextStyle(
                      color: _textDark,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: AnimatedBuilder(
                  animation: _barAnim,
                  builder: (_, __) => LinearProgressIndicator(
                    value: (count / maxBar) * _barAnim.value,
                    color: _peach,
                    backgroundColor: _peachLight,
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _peachLight,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('$count×',
              style: TextStyle(
                  color: _peach,
                  fontSize: 12,
                  fontWeight: FontWeight.w700)),
        ),
      ],
    );
  }

  // ── Craving Log Card ──────────────────────────────────────────────────────

  Widget _buildCravingLogCard(Map<String, dynamic> craving) {
    final intensity = craving['intensity'] as int;
    final managed   = craving['managed'] as bool;
    final iColor    = _intensityColor(intensity);

    return GestureDetector(
      onTap: () => _showCravingDetails(craving),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time_rounded, color: _textLight, size: 13),
                const SizedBox(width: 4),
                Text(craving['time'],
                    style: const TextStyle(color: _textLight, fontSize: 12)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: managed ? _sageLight : _peachLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    managed ? 'Managed ✓' : 'Struggling',
                    style: TextStyle(
                      color: managed ? _sage : _peach,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Trigger: ${craving['trigger']}',
                    style: const TextStyle(
                        color: _textDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
                Text('$intensity/10',
                    style: TextStyle(
                        color: iColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 8),
            _intensityBar(intensity, height: 6),
            const SizedBox(height: 10),
            Row(children: [
              Icon(Icons.favorite_rounded, color: _sage, size: 13),
              const SizedBox(width: 5),
              Text(craving['whatHelped'],
                  style: TextStyle(
                      color: _sage,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600)),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: _textLight, size: 16),
            ]),
          ],
        ),
      ),
    );
  }

  // ── Strategy Row ──────────────────────────────────────────────────────────

  Widget _strategyRow(Map<String, dynamic> s) {
    final color = s['color'] as Color;
    final light = Color.alphaBlend(
        color.withValues(alpha: 0.12), Colors.white);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: light,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(s['emoji'], style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(s['label'],
                style: const TextStyle(
                    color: _textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${s['count']}×',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700)),
          ),
        ],
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

  Widget _vDividerWhite() =>
      Container(width: 1, height: 40, color: Colors.white24);
}
