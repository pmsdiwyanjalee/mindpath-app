import 'package:flutter/material.dart';

class WellnessScreen extends StatefulWidget {
  const WellnessScreen({super.key});

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double>   _fadeAnim;
  late Animation<double>   _barAnim;

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
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  // ── Goal config ───────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _goals = [
    {
      'label': 'Water Intake',
      'current': 8, 'target': 8, 'unit': 'cups',
      'emoji': '💧',
      'icon': Icons.water_drop_rounded,
      'color': Color(0xFF4A9EAF),
      'light': Color(0xFFD6EEF3),
    },
    {
      'label': 'Exercise',
      'current': 45, 'target': 60, 'unit': 'min',
      'emoji': '🏃',
      'icon': Icons.directions_run_rounded,
      'color': Color(0xFF7CA982),
      'light': Color(0xFFD4EAD7),
    },
    {
      'label': 'Sleep',
      'current': 8, 'target': 8, 'unit': 'hrs',
      'emoji': '😴',
      'icon': Icons.bedtime_rounded,
      'color': Color(0xFF9B8EC4),
      'light': Color(0xFFEAE6F5),
    },
    {
      'label': 'Meditation',
      'current': 20, 'target': 30, 'unit': 'min',
      'emoji': '🧘',
      'icon': Icons.self_improvement_rounded,
      'color': Color(0xFFE8926A),
      'light': Color(0xFFFAE2D5),
    },
  ];

  // ── Metric config ─────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _metrics = [
    {
      'label': 'Heart Rate', 'value': '72', 'unit': 'bpm',
      'emoji': '❤️',
      'icon': Icons.favorite_rounded,
      'color': Color(0xFFD94F4F),
      'light': Color(0xFFFAE0E0),
    },
    {
      'label': 'Blood Pressure', 'value': '120/80', 'unit': 'mmHg',
      'emoji': '🩺',
      'icon': Icons.monitor_heart_rounded,
      'color': Color(0xFFE8926A),
      'light': Color(0xFFFAE2D5),
    },
    {
      'label': 'Weight', 'value': '155', 'unit': 'lbs',
      'emoji': '⚖️',
      'icon': Icons.scale_rounded,
      'color': Color(0xFF4A9EAF),
      'light': Color(0xFFD6EEF3),
    },
    {
      'label': 'Steps', 'value': '8,542', 'unit': 'today',
      'emoji': '👟',
      'icon': Icons.directions_walk_rounded,
      'color': Color(0xFF7CA982),
      'light': Color(0xFFD4EAD7),
    },
  ];

  final List<Map<String, dynamic>> _wellnessData = [
    {
      'date': 'Today',
      'water': 8, 'exercise': 45, 'sleep': 8, 'meditation': 20,
      'mood': '😊',
    },
    {
      'date': 'Yesterday',
      'water': 7, 'exercise': 30, 'sleep': 7, 'meditation': 15,
      'mood': '😊',
    },
    {
      'date': 'Apr 2',
      'water': 6, 'exercise': 60, 'sleep': 8, 'meditation': 25,
      'mood': '😊',
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
    _barAnim  = CurvedAnimation(
        parent: _entranceController, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  // ── Log Sheet ─────────────────────────────────────────────────────────────

  void _showLogSheet() {
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
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: _border, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: _sageLight,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.add_chart_rounded, color: _sage, size: 18),
              ),
              const SizedBox(width: 10),
              const Text('Log Health Data',
                  style: TextStyle(
                      color: _textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800)),
            ]),
            const SizedBox(height: 20),
            for (final g in _goals)
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(g['emoji'] as String,
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(g['label'] as String,
                          style: const TextStyle(
                              color: _textDark,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5)),
                    ]),
                    const SizedBox(height: 6),
                    TextField(
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: _textDark, fontSize: 14),
                      decoration: InputDecoration(
                        hintText:
                            'Enter ${g['unit']} (goal: ${g['target']})',
                        hintStyle:
                            const TextStyle(color: _textLight, fontSize: 13),
                        filled: true,
                        fillColor: _bg,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: _border)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(color: _border)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                                color: g['color'] as Color,
                                width: 1.5)),
                      ),
                    ),
                  ],
                ),
              ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Health data logged! 🌿'),
                    backgroundColor: _sage,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              icon: const Icon(Icons.check_rounded),
              label: const Text('Save Health Data',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: _sage,
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

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _card({required Widget child}) => Container(
        margin: const EdgeInsets.only(bottom: 16),
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

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Count goals fully met
    final goalsMetCount =
        _goals.where((g) => (g['current'] as int) >= (g['target'] as int)).length;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Wellness & Health',
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

              // ── Hero Banner ──────────────────────────────────────────────
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
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Today\'s Wellness',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 4),
                          Text(
                            '$goalsMetCount / ${_goals.length} Goals Met 🌿',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 12),
                          AnimatedBuilder(
                            animation: _barAnim,
                            builder: (_, __) => ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: (goalsMetCount / _goals.length) *
                                    _barAnim.value,
                                color: Colors.white,
                                backgroundColor: Colors.white24,
                                minHeight: 8,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '$goalsMetCount of ${_goals.length} daily goals completed',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text('🏃', style: TextStyle(fontSize: 52)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Today's Goals ────────────────────────────────────────────
              _sectionHeader("Today's Goals",
                  Icons.flag_rounded, _sage, _sageLight),
              _card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: _goals.asMap().entries.map((e) {
                      final g       = e.value;
                      final color   = g['color'] as Color;
                      final light   = g['light'] as Color;
                      final current = g['current'] as int;
                      final target  = g['target'] as int;
                      final pct     = (current / target).clamp(0.0, 1.0);
                      final done    = current >= target;

                      return Padding(
                        padding: EdgeInsets.only(
                            bottom:
                                e.key < _goals.length - 1 ? 16 : 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(
                                      color: light,
                                      borderRadius:
                                          BorderRadius.circular(12)),
                                  child: Center(
                                    child: Text(g['emoji'] as String,
                                        style: const TextStyle(
                                            fontSize: 20)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(g['label'] as String,
                                              style: const TextStyle(
                                                  color: _textDark,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                  fontSize: 13.5)),
                                          Row(children: [
                                            Text(
                                              '$current / $target ${g['unit']}',
                                              style: TextStyle(
                                                  color: color,
                                                  fontSize: 12.5,
                                                  fontWeight:
                                                      FontWeight.w700),
                                            ),
                                            if (done) ...[
                                              const SizedBox(width: 5),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                    color: color,
                                                    shape: BoxShape.circle),
                                                child: const Icon(
                                                    Icons.check_rounded,
                                                    color: Colors.white,
                                                    size: 10),
                                              ),
                                            ],
                                          ]),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      AnimatedBuilder(
                                        animation: _barAnim,
                                        builder: (_, __) => ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: LinearProgressIndicator(
                                            value: pct * _barAnim.value,
                                            color: color,
                                            backgroundColor:
                                                color.withValues(alpha: 0.12),
                                            minHeight: 7,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (e.key < _goals.length - 1) ...[
                              const SizedBox(height: 14),
                              Divider(height: 1, color: _border),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // ── Health Metrics ───────────────────────────────────────────
              _sectionHeader('Health Metrics',
                  Icons.monitor_heart_rounded, _teal, _tealLight),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: _metrics.map((m) {
                  final color = m['color'] as Color;
                  final light = m['light'] as Color;
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(m['label'] as String,
                                style: const TextStyle(
                                    color: _textLight, fontSize: 11.5)),
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: light,
                                  borderRadius:
                                      BorderRadius.circular(8)),
                              child: Icon(m['icon'] as IconData,
                                  color: color, size: 16),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(m['value'] as String,
                            style: TextStyle(
                                color: color,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                height: 1)),
                        Text(m['unit'] as String,
                            style: const TextStyle(
                                color: _textLight, fontSize: 11)),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // ── Weekly History ───────────────────────────────────────────
              _sectionHeader('Weekly History',
                  Icons.history_rounded, _lavender, _lavLight),
              _card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: _wellnessData.asMap().entries.map((e) {
                      final data  = e.value;
                      final isLast =
                          e.key == _wellnessData.length - 1;
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Icon(Icons.calendar_today_rounded,
                                          color: _textLight, size: 13),
                                      const SizedBox(width: 5),
                                      Text(data['date'] as String,
                                          style: const TextStyle(
                                              color: _textDark,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13.5)),
                                    ]),
                                    Text(data['mood'] as String,
                                        style: const TextStyle(
                                            fontSize: 20)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _historyPill('💧',
                                        '${data['water']}',
                                        'cups', _teal, _tealLight),
                                    _historyPill('🏃',
                                        '${data['exercise']}',
                                        'min', _sage, _sageLight),
                                    _historyPill('😴',
                                        '${data['sleep']}',
                                        'hrs', _lavender, _lavLight),
                                    _historyPill('🧘',
                                        '${data['meditation']}',
                                        'min', _peach, _peachLight),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (!isLast)
                            Divider(height: 1, color: _border),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

              // ── Log Button ───────────────────────────────────────────────
              ElevatedButton.icon(
                onPressed: _showLogSheet,
                icon: const Icon(Icons.add_chart_rounded),
                label: const Text('Log Health Data',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _sage,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  minimumSize: const Size.fromHeight(54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _historyPill(String emoji, String value, String label,
      Color color, Color light) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
          color: light, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 3),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w800)),
          Text(label,
              style: const TextStyle(color: _textLight, fontSize: 10)),
        ],
      ),
    );
  }
}
