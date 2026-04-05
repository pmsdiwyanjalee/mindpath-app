import 'package:flutter/material.dart';

class CopingSkillsScreen extends StatefulWidget {
  const CopingSkillsScreen({Key? key}) : super(key: key);

  @override
  State<CopingSkillsScreen> createState() => _CopingSkillsScreenState();
}

class _CopingSkillsScreenState extends State<CopingSkillsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;
  String _selectedCategory = 'All';

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
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7280);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  // ── Category config ───────────────────────────────────────────────────────
  static const Map<String, Map<String, dynamic>> _catConfig = {
    'Mindfulness':    {'icon': Icons.self_improvement_rounded,   'color': Color(0xFF7CA982), 'light': Color(0xFFD4EAD7)},
    'Relaxation':     {'icon': Icons.spa_rounded,                'color': Color(0xFF4A9EAF), 'light': Color(0xFFD6EEF3)},
    'Coping':         {'icon': Icons.psychology_rounded,         'color': Color(0xFF9B8EC4), 'light': Color(0xFFEAE6F5)},
    'Expression':     {'icon': Icons.brush_rounded,              'color': Color(0xFFE8926A), 'light': Color(0xFFFAE2D5)},
    'Movement':       {'icon': Icons.directions_run_rounded,     'color': Color(0xFFF4C542), 'light': Color(0xFFFDF3CC)},
    'Social Support': {'icon': Icons.people_rounded,             'color': Color(0xFF4A9EAF), 'light': Color(0xFFD6EEF3)},
  };

  // ── Difficulty config ─────────────────────────────────────────────────────
  static const Map<String, Map<String, dynamic>> _diffConfig = {
    'Easy':   {'color': Color(0xFF7CA982), 'light': Color(0xFFD4EAD7)},
    'Medium': {'color': Color(0xFFF4C542), 'light': Color(0xFFFDF3CC)},
    'Hard':   {'color': Color(0xFFE8926A), 'light': Color(0xFFFAE2D5)},
  };

  final List<String> _categories = [
    'All', 'Mindfulness', 'Relaxation', 'Coping',
    'Expression', 'Movement', 'Social Support',
  ];

  final List<Map<String, dynamic>> _copingSkills = [
    {
      'title': 'Deep Breathing Exercise',
      'category': 'Mindfulness',
      'duration': '5 min',
      'difficulty': 'Easy',
      'emoji': '🌬️',
      'description': 'Slow, deep breathing to calm your nervous system. Breathe in for 4 counts, hold for 4, exhale for 4.',
      'steps': [
        'Find a comfortable position',
        'Breathe in slowly through your nose',
        'Hold for 4 seconds',
        'Exhale gently through your mouth',
        'Repeat 10 times',
      ],
    },
    {
      'title': 'Progressive Muscle Relaxation',
      'category': 'Relaxation',
      'duration': '10 min',
      'difficulty': 'Medium',
      'emoji': '💆',
      'description': 'Tense and release each muscle group to release physical tension and promote calm.',
      'steps': [
        'Start with your toes',
        'Tense muscles for 5 seconds',
        'Release and relax completely',
        'Move upward through the body',
        'Notice the difference in tension',
      ],
    },
    {
      'title': 'Grounding (5-4-3-2-1)',
      'category': 'Coping',
      'duration': '5 min',
      'difficulty': 'Easy',
      'emoji': '🌿',
      'description': 'Use your senses to anchor yourself in the present moment and ease anxiety.',
      'steps': [
        'Name 5 things you can see',
        'Name 4 things you can feel',
        'Name 3 things you can hear',
        'Name 2 things you can smell',
        'Name 1 thing you can taste',
      ],
    },
    {
      'title': 'Journaling',
      'category': 'Expression',
      'duration': '15 min',
      'difficulty': 'Easy',
      'emoji': '📔',
      'description': 'Express your feelings and process emotions through free, unjudged writing.',
      'steps': [
        'Find a quiet, comfortable space',
        'Write freely without judgment',
        'Express what you\'re truly feeling',
        'Reflect on what you wrote',
        'End with one thing you\'re grateful for',
      ],
    },
    {
      'title': 'Physical Activity',
      'category': 'Movement',
      'duration': '30 min',
      'difficulty': 'Medium',
      'emoji': '🏃',
      'description': 'Exercise to release endorphins, reduce stress and boost your mood naturally.',
      'steps': [
        'Choose an activity you enjoy',
        'Warm up at low intensity',
        'Gradually increase your pace',
        'Cool down slowly',
        'Hydrate and rest',
      ],
    },
    {
      'title': 'Meditation',
      'category': 'Mindfulness',
      'duration': '20 min',
      'difficulty': 'Hard',
      'emoji': '🧘',
      'description': 'Calm your mind and reduce anxiety through focused, present-moment awareness.',
      'steps': [
        'Find a quiet, undisturbed space',
        'Sit comfortably with back straight',
        'Focus gently on your breath',
        'Allow thoughts to pass without judgment',
        'Return focus to your breath each time',
      ],
    },
    {
      'title': 'Call a Friend',
      'category': 'Social Support',
      'duration': '~30 min',
      'difficulty': 'Easy',
      'emoji': '📞',
      'description': 'Reach out to someone you trust for genuine support, connection, and warmth.',
      'steps': [
        'Identify a person you trust',
        'Reach out and call them',
        'Share honestly how you\'re feeling',
        'Listen when they speak',
        'Feel the warmth of connection',
      ],
    },
    {
      'title': 'Art Therapy',
      'category': 'Expression',
      'duration': '20 min',
      'difficulty': 'Easy',
      'emoji': '🎨',
      'description': 'Express your emotions creatively through drawing, painting, or craft.',
      'steps': [
        'Gather simple art supplies',
        'Create freely without judgment',
        'Let emotions guide your hand',
        'Reflect on what emerged',
        'Feel proud of what you made',
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

  List<Map<String, dynamic>> get _filtered => _selectedCategory == 'All'
      ? _copingSkills
      : _copingSkills
          .where((s) => s['category'] == _selectedCategory)
          .toList();

  Color _catColor(String cat) =>
      (_catConfig[cat]?['color'] as Color?) ?? _lavender;
  Color _catLight(String cat) =>
      (_catConfig[cat]?['light'] as Color?) ?? _lavLight;
  IconData _catIcon(String cat) =>
      (_catConfig[cat]?['icon'] as IconData?) ?? Icons.star_rounded;

  Color _diffColor(String diff) =>
      (_diffConfig[diff]?['color'] as Color?) ?? _textLight;
  Color _diffLight(String diff) =>
      (_diffConfig[diff]?['light'] as Color?) ?? _bg;

  // ── Skill Detail Sheet ────────────────────────────────────────────────────

  void _showSkillDetail(Map<String, dynamic> skill) {
    final cat   = skill['category'] as String;
    final diff  = skill['difficulty'] as String;
    final color = _catColor(cat);
    final light = _catLight(cat);

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
            color: _surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: _border,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),

              // Hero
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: light,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(skill['emoji'],
                        style: const TextStyle(fontSize: 52)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _pill('⏱ ${skill['duration']}', color, light,
                            solid: true),
                        const SizedBox(width: 8),
                        _pill(diff, _diffColor(diff), _diffLight(diff),
                            solid: true),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title & category
              Text(skill['title'],
                  style: const TextStyle(
                      color: _textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3)),
              const SizedBox(height: 6),
              Row(children: [
                Icon(_catIcon(cat), color: color, size: 15),
                const SizedBox(width: 5),
                Text(cat,
                    style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 16),

              // Description
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _border)),
                child: Text(skill['description'],
                    style: const TextStyle(
                        color: _textMid, fontSize: 14.5, height: 1.65)),
              ),
              const SizedBox(height: 20),

              // Steps
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: light, borderRadius: BorderRadius.circular(10)),
                  child: Icon(_catIcon(cat), color: color, size: 16),
                ),
                const SizedBox(width: 10),
                const Text('How to Practice',
                    style: TextStyle(
                        color: _textDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 14),
              ...(skill['steps'] as List<String>).asMap().entries.map(
                (entry) => _stepTile(entry.key + 1, entry.value, color, light),
              ),
              const SizedBox(height: 20),

              // Start button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Starting ${skill['title']}… 🌿'),
                      backgroundColor: color,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow_rounded),
                label: const Text('Start Practice',
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
      ),
    );
  }

  Widget _stepTile(int number, String text, Color color, Color light) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(color: light, shape: BoxShape.circle),
            child: Center(
              child: Text('$number',
                  style: TextStyle(
                      color: color,
                      fontSize: 12,
                      fontWeight: FontWeight.w800)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text,
                  style: const TextStyle(
                      color: _textMid, fontSize: 14, height: 1.4)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Skill Card ────────────────────────────────────────────────────────────

  Widget _buildSkillCard(Map<String, dynamic> skill) {
    final cat   = skill['category'] as String;
    final diff  = skill['difficulty'] as String;
    final color = _catColor(cat);
    final light = _catLight(cat);

    return GestureDetector(
      onTap: () => _showSkillDetail(skill),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top strip
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: color,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(22)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emoji bubble
                  Container(
                    width: 54, height: 54,
                    decoration: BoxDecoration(
                        color: light,
                        borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: Text(skill['emoji'],
                          style: const TextStyle(fontSize: 26)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(skill['title'],
                            style: const TextStyle(
                                color: _textDark,
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                height: 1.3)),
                        const SizedBox(height: 6),
                        Row(children: [
                          Icon(_catIcon(cat), color: color, size: 13),
                          const SizedBox(width: 4),
                          Text(cat,
                              style: TextStyle(
                                  color: color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                        ]),
                        const SizedBox(height: 8),
                        Text(
                          skill['description'],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: _textMid,
                              fontSize: 12.5,
                              height: 1.45),
                        ),
                        const SizedBox(height: 10),
                        Row(children: [
                          _pill('⏱ ${skill['duration']}', _textMid, _bg),
                          const SizedBox(width: 6),
                          _pill(diff, _diffColor(diff), _diffLight(diff)),
                          const Spacer(),
                          Icon(Icons.arrow_forward_rounded,
                              color: color, size: 16),
                        ]),
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

  Widget _pill(String label, Color color, Color bg, {bool solid = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: solid ? color : bg,
        borderRadius: BorderRadius.circular(20),
        border: solid ? null : Border.all(color: _border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: solid ? Colors.white : color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Coping Skills Library',
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
        child: Column(
          children: [

            // ── Stats Banner ─────────────────────────────────────────────
            Container(
              color: _surface,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  _statPill('${_copingSkills.length}', 'Total Skills', _sage),
                  _dividerV(),
                  _statPill(
                      '${_copingSkills.where((s) => s['difficulty'] == 'Easy').length}',
                      'Easy',
                      _sage),
                  _dividerV(),
                  _statPill(
                      '${_copingSkills.where((s) => s['difficulty'] == 'Medium').length}',
                      'Medium',
                      _gold),
                  _dividerV(),
                  _statPill(
                      '${_copingSkills.where((s) => s['difficulty'] == 'Hard').length}',
                      'Hard',
                      _peach),
                ],
              ),
            ),
            Divider(height: 1, color: _border),

            // ── Category Filter ───────────────────────────────────────────
            Container(
              color: _surface,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (_, i) {
                    final cat      = _categories[i];
                    final selected = _selectedCategory == cat;
                    final color    = cat == 'All' ? _sage : _catColor(cat);
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? color : _surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: selected ? color : _border),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                      color: color.withOpacity(0.25),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3))
                                ]
                              : [],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (cat != 'All') ...[
                              Icon(_catIcon(cat),
                                  color: selected
                                      ? Colors.white
                                      : color,
                                  size: 13),
                              const SizedBox(width: 4),
                            ],
                            Text(cat,
                                style: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : _textMid,
                                  fontSize: 12.5,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // ── Skill List ────────────────────────────────────────────────
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                                color: _sageLight,
                                shape: BoxShape.circle),
                            child: Icon(Icons.psychology_rounded,
                                color: _sage, size: 40),
                          ),
                          const SizedBox(height: 20),
                          const Text('No skills found',
                              style: TextStyle(
                                  color: _textDark,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          const Text('Try selecting a different category',
                              style: TextStyle(
                                  color: _textMid, fontSize: 13.5)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(16, 16, 16, 40),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) =>
                          _buildSkillCard(filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statPill(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(color: _textLight, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _dividerV() =>
      Container(width: 1, height: 32, color: _border);
}