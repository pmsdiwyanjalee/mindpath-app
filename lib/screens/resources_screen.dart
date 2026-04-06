import 'package:flutter/material.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({Key? key}) : super(key: key);

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen>
    with SingleTickerProviderStateMixin {
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
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7280);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  // ── Resource data ─────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _articles = [
    {
      'title': 'Understanding Cravings',
      'description': 'Learn what triggers cravings and how to manage them effectively.',
      'emoji': '🧠',
      'icon': Icons.psychology_rounded,
      'color': Color(0xFF4A9EAF),
      'light': Color(0xFFD6EEF3),
      'readTime': '4 min read',
      'content':
          'Cravings are a normal part of recovery. They typically last 5–15 minutes and can be triggered by stress, people, places, or things associated with substance use.\n\nStrategies to manage cravings:\n\n1. Recognise the craving and accept it\n2. Use distraction techniques\n3. Practice deep breathing\n4. Call a support person\n5. Use positive self-talk\n6. Engage in physical activity\n\nRemember: A craving is not a command. You have the power to choose how to respond.',
    },
    {
      'title': 'Building Healthy Habits',
      'description': 'Practical tips for creating routines that support long-term recovery.',
      'emoji': '🌱',
      'icon': Icons.fitness_center_rounded,
      'color': Color(0xFF7CA982),
      'light': Color(0xFFD4EAD7),
      'readTime': '5 min read',
      'content':
          'Recovery is about more than stopping substance use — it\'s about building a new, healthier life.\n\nKey areas to focus on:\n\n• Sleep: Aim for 7–9 hours per night\n• Nutrition: Eat balanced meals regularly\n• Exercise: Find activities you enjoy\n• Social connections: Build supportive relationships\n• Purpose: Set meaningful goals\n• Stress management: Learn healthy coping skills\n\nStart small and be patient with yourself. Change takes time.',
    },
    {
      'title': 'Relapse Prevention',
      'description': 'Identify warning signs and develop strategies to prevent relapse.',
      'emoji': '🛡️',
      'icon': Icons.shield_rounded,
      'color': Color(0xFF9B8EC4),
      'light': Color(0xFFEAE6F5),
      'readTime': '6 min read',
      'content':
          'Relapse is not failure — it\'s a learning opportunity. Most people in recovery experience setbacks.\n\nWarning signs of potential relapse:\n\n• Skipping meetings or therapy\n• Isolating from support network\n• Not managing stress effectively\n• Romanticising past substance use\n• Poor self-care\n• Spending time with old using friends\n\nPrevention strategies:\n\n• Follow your recovery plan\n• Stay connected to your support system\n• Practice self-care\n• Avoid high-risk situations\n• Have an emergency plan\n• Be honest about struggles',
    },
    {
      'title': 'Mindfulness & Meditation',
      'description': 'Learn techniques to stay present and manage difficult emotions.',
      'emoji': '🧘',
      'icon': Icons.self_improvement_rounded,
      'color': Color(0xFFE8926A),
      'light': Color(0xFFFAE2D5),
      'readTime': '5 min read',
      'content':
          'Mindfulness helps you stay present and respond to challenges with awareness rather than reacting impulsively.\n\nGetting started:\n\n1. Find a quiet space\n2. Set a timer for 5–10 minutes\n3. Focus on your breath\n4. Notice thoughts without judgement\n5. Gently return focus when your mind wanders\n\nBenefits for recovery:\n\n• Reduced cravings\n• Better emotional regulation\n• Improved sleep\n• Increased self-awareness\n• Enhanced coping skills\n\nStart with guided meditations using free apps like Insight Timer or Calm.',
    },
  ];

  static const List<Map<String, dynamic>> _tools = [
    {
      'title': 'Serenity Prayer',
      'description': 'A powerful reminder of what we can and cannot control.',
      'emoji': '🙏',
      'icon': Icons.favorite_rounded,
      'color': Color(0xFF7CA982),
      'light': Color(0xFFD4EAD7),
      'readTime': '1 min read',
      'content':
          'God, grant me the serenity to accept the things I cannot change,\n\nThe courage to change the things I can,\n\nAnd the wisdom to know the difference.\n\n— Reinhold Niebuhr\n\nThis prayer reminds us that we are powerless over addiction, but we have the power to change our attitudes, behaviours, and responses to life\'s challenges.',
    },
    {
      'title': 'HALT Check',
      'description': 'Check yourself before making decisions when feeling vulnerable.',
      'emoji': '⚠️',
      'icon': Icons.warning_amber_rounded,
      'color': Color(0xFFF4C542),
      'light': Color(0xFFFDF3CC),
      'readTime': '2 min read',
      'content':
          'HALT stands for:\n\n• Hungry\n• Angry\n• Lonely\n• Tired\n\nBefore making any important decisions or when experiencing cravings, ask yourself:\n\nAm I Hungry? → Eat something healthy\nAm I Angry? → Express feelings appropriately\nAm I Lonely? → Call a support person\nAm I Tired? → Rest or take a break\n\nAddressing these basic needs can prevent impulsive decisions and reduce vulnerability to relapse.',
    },
    {
      'title': 'Emergency Action Plan',
      'description': 'Create a plan for when you need immediate support.',
      'emoji': '🆘',
      'icon': Icons.emergency_rounded,
      'color': Color(0xFFE8926A),
      'light': Color(0xFFFAE2D5),
      'readTime': '3 min read',
      'content':
          'Having a plan ready can help you respond effectively during a crisis.\n\nYour Emergency Action Plan should include:\n\n1. Warning signs that you need help\n2. Immediate actions to take\n3. People to contact (sponsor, therapist, etc.)\n4. Places to go (meetings, emergency room)\n5. Coping skills to use\n6. Self-care activities\n\nReview and update your plan regularly. Keep it accessible on your phone or in your wallet.',
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

  // ── Article Detail Sheet ──────────────────────────────────────────────────

  void _showArticleSheet(Map<String, dynamic> resource) {
    final color = resource['color'] as Color;
    final light = resource['light'] as Color;

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
                    color: light, borderRadius: BorderRadius.circular(24)),
                child: Column(
                  children: [
                    Text(resource['emoji'],
                        style: const TextStyle(fontSize: 52)),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time_rounded,
                              color: Colors.white, size: 12),
                          const SizedBox(width: 5),
                          Text(resource['readTime'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(resource['title'],
                  style: const TextStyle(
                      color: _textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3)),
              const SizedBox(height: 6),
              Text(resource['description'],
                  style: const TextStyle(
                      color: _textMid, fontSize: 14)),
              const SizedBox(height: 20),

              // Content
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _border)),
                child: Text(resource['content'],
                    style: const TextStyle(
                        color: _textMid, fontSize: 14.5, height: 1.75)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Resource Card ─────────────────────────────────────────────────────────

  Widget _buildResourceCard(Map<String, dynamic> resource) {
    final color = resource['color'] as Color;
    final light = resource['light'] as Color;

    return GestureDetector(
      onTap: () => _showArticleSheet(resource),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
                color: color,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20)),
              ),
            ),
            const SizedBox(width: 14),

            // Emoji bubble
            Container(
              width: 50, height: 50,
              decoration: BoxDecoration(
                  color: light, borderRadius: BorderRadius.circular(14)),
              child: Center(
                child: Text(resource['emoji'],
                    style: const TextStyle(fontSize: 24)),
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
                    Text(resource['title'],
                        style: const TextStyle(
                            color: _textDark,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.3)),
                    const SizedBox(height: 4),
                    Text(resource['description'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: _textMid, fontSize: 12.5, height: 1.4)),
                    const SizedBox(height: 6),
                    Row(children: [
                      Icon(Icons.access_time_rounded,
                          color: color, size: 12),
                      const SizedBox(width: 4),
                      Text(resource['readTime'],
                          style: TextStyle(
                              color: color,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600)),
                    ]),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Icon(Icons.arrow_forward_rounded,
                  color: color, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section Header ────────────────────────────────────────────────────────

  Widget _sectionHeader(
      String title, IconData icon, Color accent, Color accentLight) {
    return Padding(
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
        title: const Text('Resources & Guides',
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

              // ── Banner ───────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A9EAF), Color(0xFF9B8EC4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _teal.withOpacity(0.3),
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
                        children: const [
                          Text('Helpful Resources',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2)),
                          SizedBox(height: 8),
                          Text(
                            'Articles, guides, and tools to support your recovery journey.',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                height: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Text('📚', style: TextStyle(fontSize: 48)),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Stats strip ──────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statPill(
                        '${_articles.length}', 'Articles', _teal),
                    Container(width: 1, height: 32, color: _border),
                    _statPill(
                        '${_tools.length}', 'Tools', _lavender),
                    Container(width: 1, height: 32, color: _border),
                    _statPill(
                        '${_articles.length + _tools.length}',
                        'Total',
                        _sage),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Articles ─────────────────────────────────────────────────
              _sectionHeader('Articles & Guides',
                  Icons.library_books_rounded, _teal, _tealLight),
              ..._articles.map(_buildResourceCard),
              const SizedBox(height: 8),

              // ── Tools ────────────────────────────────────────────────────
              _sectionHeader('Recovery Tools',
                  Icons.build_rounded, _lavender, _lavLight),
              ..._tools.map(_buildResourceCard),
              const SizedBox(height: 8),

              // ── Footer ───────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _sageLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: [
                    Text('🌿', style: TextStyle(fontSize: 28)),
                    SizedBox(height: 8),
                    Text(
                      '"Knowledge is power. Every article you read is a step closer to lasting recovery."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF5A8A60),
                        fontSize: 13.5,
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

  Widget _statPill(String value, String label, Color color) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                height: 1)),
        const SizedBox(height: 3),
        Text(label,
            style: const TextStyle(color: _textLight, fontSize: 11)),
      ],
    );
  }
}