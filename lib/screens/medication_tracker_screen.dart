import 'package:flutter/material.dart';

class MedicationTrackerScreen extends StatefulWidget {
  const MedicationTrackerScreen({super.key});

  @override
  State<MedicationTrackerScreen> createState() =>
      _MedicationTrackerScreenState();
}

class _MedicationTrackerScreenState extends State<MedicationTrackerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;
  late Animation<double> _barAnim;

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

  // Each medication gets its own accent
  static const List<List<Color>> _medAccents = [
    [Color(0xFF4A9EAF), Color(0xFFD6EEF3)], // teal
    [Color(0xFF9B8EC4), Color(0xFFEAE6F5)], // lavender
    [Color(0xFFE8926A), Color(0xFFFAE2D5)], // peach
  ];

  final List<Map<String, dynamic>> _medications = [
    {
      'name': 'Naltrexone',
      'dosage': '50 mg',
      'frequency': 'Daily',
      'time': '8:00 AM',
      'purpose': 'Reduces cravings',
      'startDate': 'March 18, 2026',
      'adherence': 98,
      'today': true,
      'emoji': '💊',
    },
    {
      'name': 'Sertraline',
      'dosage': '100 mg',
      'frequency': 'Daily',
      'time': '8:00 AM',
      'purpose': 'Depression & Anxiety',
      'startDate': 'March 15, 2026',
      'adherence': 95,
      'today': true,
      'emoji': '🔵',
    },
    {
      'name': 'Bupropion',
      'dosage': '300 mg',
      'frequency': 'Daily',
      'time': '6:00 AM',
      'purpose': 'Energy & Motivation',
      'startDate': 'March 20, 2026',
      'adherence': 92,
      'today': false,
      'emoji': '🟡',
    },
  ];

  final List<Map<String, dynamic>> _history = [
    {
      'date': 'April 4 (Today)',
      'medication': 'Naltrexone',
      'taken': true,
      'time': '8:15 AM'
    },
    {
      'date': 'April 4 (Today)',
      'medication': 'Sertraline',
      'taken': true,
      'time': '8:10 AM'
    },
    {
      'date': 'April 3',
      'medication': 'Naltrexone',
      'taken': true,
      'time': '8:00 AM'
    },
    {
      'date': 'April 3',
      'medication': 'Sertraline',
      'taken': true,
      'time': '8:05 AM'
    },
    {
      'date': 'April 3',
      'medication': 'Bupropion',
      'taken': true,
      'time': '6:10 AM'
    },
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
    _fadeAnim =
        CurvedAnimation(parent: _entranceController, curve: Curves.easeOut);
    _barAnim = CurvedAnimation(
        parent: _entranceController, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  int get _takenToday => _medications.where((m) => m['today'] as bool).length;

  double get _avgAdherence =>
      _medications.fold<int>(0, (s, m) => s + (m['adherence'] as int)) /
      _medications.length;

  // ── Medication Detail Sheet ───────────────────────────────────────────────

  void _showMedDetail(Map<String, dynamic> med, int index) {
    final accent = _medAccents[index % _medAccents.length][0];
    final light = _medAccents[index % _medAccents.length][1];
    final taken = med['today'] as bool;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
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
                    Text(med['emoji'], style: const TextStyle(fontSize: 48)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                          color: taken ? _sage : _peach,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            taken
                                ? Icons.check_circle_rounded
                                : Icons.pending_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            taken ? 'Taken Today' : 'Pending Today',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Name & purpose
              Text(med['name'],
                  style: const TextStyle(
                      color: _textDark,
                      fontSize: 22,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(med['purpose'],
                  style: const TextStyle(color: _textMid, fontSize: 14)),
              const SizedBox(height: 18),

              // Detail grid
              Row(children: [
                _detailChip(
                    Icons.medication_rounded, med['dosage'], accent, light),
                const SizedBox(width: 10),
                _detailChip(
                    Icons.repeat_rounded, med['frequency'], accent, light),
                const SizedBox(width: 10),
                _detailChip(
                    Icons.access_time_rounded, med['time'], accent, light),
              ]),
              const SizedBox(height: 16),

              // Adherence
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: light,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: accent.withValues(alpha: 0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Adherence',
                            style: TextStyle(
                                color: _textDark,
                                fontWeight: FontWeight.w700,
                                fontSize: 13)),
                        Text('${med['adherence']}%',
                            style: TextStyle(
                                color: accent,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: (med['adherence'] as int) / 100,
                        color: accent,
                        backgroundColor: accent.withValues(alpha: 0.15),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.calendar_today_rounded,
                          color: _textLight, size: 12),
                      const SizedBox(width: 5),
                      Text('Started ${med['startDate']}',
                          style: const TextStyle(
                              color: _textLight, fontSize: 11.5)),
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Side effects note
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: _goldLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _gold.withValues(alpha: 0.25))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, color: _gold, size: 18),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Minimal side effects. Report any unusual symptoms to your doctor.',
                        style: TextStyle(
                            color: Color(0xFF8B6914),
                            fontSize: 13,
                            height: 1.5),
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

  Widget _detailChip(IconData icon, String label, Color color, Color light) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
            color: light, borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color, fontSize: 11.5, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }

  // ── Medication Card ───────────────────────────────────────────────────────

  Widget _buildMedicationCard(Map<String, dynamic> med, int index) {
    final accent = _medAccents[index % _medAccents.length][0];
    final taken = med['today'] as bool;

    return GestureDetector(
      onTap: () => _showMedDetail(med, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Row(
          children: [
            // Left strip
            Container(
              width: 5,
              height: 86,
              decoration: BoxDecoration(
                color: taken ? accent : _peach,
                borderRadius:
                    const BorderRadius.horizontal(left: Radius.circular(20)),
              ),
            ),
            const SizedBox(width: 14),

            // Status bubble
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: taken ? accent : _peachLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                taken ? Icons.check_rounded : Icons.access_time_rounded,
                color: taken ? Colors.white : _peach,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(med['name'],
                        style: const TextStyle(
                            color: _textDark,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700)),
                    const SizedBox(height: 3),
                    Text('${med['dosage']} · ${med['frequency']}',
                        style:
                            const TextStyle(color: _textMid, fontSize: 12.5)),
                    const SizedBox(height: 4),
                    Row(children: [
                      Icon(Icons.access_time_rounded, color: accent, size: 12),
                      const SizedBox(width: 4),
                      Text(med['time'],
                          style: TextStyle(
                              color: accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ],
                ),
              ),
            ),

            // Adherence badge
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Column(
                children: [
                  Text('${med['adherence']}%',
                      style: TextStyle(
                          color: accent,
                          fontSize: 14,
                          fontWeight: FontWeight.w800)),
                  Text('adherence',
                      style: const TextStyle(color: _textLight, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── History Item ──────────────────────────────────────────────────────────

  Widget _buildHistoryItem(Map<String, dynamic> item, {bool isLast = false}) {
    final taken = item['taken'] as bool;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: taken ? _sageLight : _peachLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  taken ? Icons.check_circle_rounded : Icons.cancel_rounded,
                  color: taken ? _sage : _peach,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['medication'],
                        style: const TextStyle(
                            color: _textDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5)),
                    const SizedBox(height: 2),
                    Text(item['date'],
                        style:
                            const TextStyle(color: _textLight, fontSize: 11.5)),
                  ],
                ),
              ),
              Text(item['time'],
                  style: const TextStyle(
                      color: _textMid,
                      fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1, color: _border, indent: 48),
      ],
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _handle() => Center(
        child: Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              color: _border, borderRadius: BorderRadius.circular(2)),
        ),
      );

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
                color: accentLight, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  color: _textDark, fontSize: 17, fontWeight: FontWeight.w700)),
        ]),
      );

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
        title: const Text('Medication Tracker',
            style: TextStyle(
                color: _textDark, fontSize: 17, fontWeight: FontWeight.w700)),
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
              // ── Hero Adherence Banner ────────────────────────────────────
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
                        _heroPill('${_medications.length}', 'Medications',
                            Icons.medication_rounded),
                        Container(width: 1, height: 44, color: Colors.white24),
                        _heroPill('$_takenToday', 'Taken Today',
                            Icons.check_circle_outline_rounded),
                        Container(width: 1, height: 44, color: Colors.white24),
                        _heroPill('${_avgAdherence.round()}%', 'Avg Adherence',
                            Icons.trending_up_rounded),
                      ],
                    ),
                    const SizedBox(height: 16),
                    AnimatedBuilder(
                      animation: _barAnim,
                      builder: (_, __) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (_avgAdherence / 100) * _barAnim.value,
                          color: Colors.white,
                          backgroundColor: Colors.white24,
                          minHeight: 8,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '47 of 50 doses taken this month — Excellent work!',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Today's Medications ──────────────────────────────────────
              _sectionHeader("Today's Medications", Icons.today_rounded, _teal,
                  _tealLight),
              ..._medications
                  .asMap()
                  .entries
                  .map((e) => _buildMedicationCard(e.value, e.key)),
              const SizedBox(height: 4),

              // ── Adherence Summary Card ───────────────────────────────────
              _sectionHeader('Adherence Summary', Icons.bar_chart_rounded,
                  _sage, _sageLight),
              _card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ..._medications.asMap().entries.map((e) {
                        final med = e.value;
                        final accent =
                            _medAccents[e.key % _medAccents.length][0];
                        final light =
                            _medAccents[e.key % _medAccents.length][1];
                        final pct = (med['adherence'] as int) / 100;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    Text(med['emoji'],
                                        style: const TextStyle(fontSize: 16)),
                                    const SizedBox(width: 6),
                                    Text(med['name'],
                                        style: const TextStyle(
                                            color: _textDark,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13)),
                                  ]),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: light,
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Text('${med['adherence']}%',
                                        style: TextStyle(
                                            color: accent,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              AnimatedBuilder(
                                animation: _barAnim,
                                builder: (_, __) => ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: pct * _barAnim.value,
                                    color: accent,
                                    backgroundColor:
                                        accent.withValues(alpha: 0.12),
                                    minHeight: 7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // ── Medication History ───────────────────────────────────────
              _sectionHeader('Recent History', Icons.history_rounded, _lavender,
                  _lavLight),
              _card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: _history.asMap().entries.map((e) {
                      return _buildHistoryItem(e.value,
                          isLast: e.key == _history.length - 1);
                    }).toList(),
                  ),
                ),
              ),

              // ── Set Reminder ─────────────────────────────────────────────
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Medication reminder set! 💊'),
                      backgroundColor: _teal,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications_active_rounded),
                label: const Text('Set Medication Reminder',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
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

  Widget _heroPill(String value, String label, IconData icon) => Column(
        children: [
          Icon(icon, color: Colors.white70, size: 18),
          const SizedBox(height: 4),
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  height: 1)),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 10.5)),
        ],
      );
}
