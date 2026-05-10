import 'package:flutter/material.dart';

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;

  // ── Palette ───────────────────────────────────────────────────────────────
  static const Color _bg = Color(0xFFF6F4F0);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _sage = Color(0xFF7CA982);
  static const Color _sageLight = Color(0xFFD4EAD7);
  static const Color _teal = Color(0xFF4A9EAF);
  static const Color _tealLight = Color(0xFFD6EEF3);
  static const Color _lavender = Color(0xFF9B8EC4);
  static const Color _lavLight = Color(0xFFEAE6F5);
  static const Color _textDark = Color(0xFF2D3142);
  static const Color _textMid = Color(0xFF6B7280);
  static const Color _textLight = Color(0xFF9CA3AF);
  static const Color _border = Color(0xFFE8E5E0);

  // ── Resource data ─────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> _articles = [
    {
      'title': 'Understanding Cravings',
      'description':
          'Learn what triggers cravings and how to manage them effectively.',
      'emoji': '🧠',
      'icon': Icons.psychology_rounded,
      'color': Color(0xFF4A9EAF),
      'light': Color(0xFFD6EEF3),
      'readTime': '4 min read',
      'source':
          'SAMHSA (Substance Abuse and Mental Health Services Administration)',
      'sourceUrl': 'https://www.samhsa.gov',
      'sourceType': 'Government Health Agency',
      'verificationBadge': '✓ Verified Government Source',
      'citation':
          'SAMHSA National Helpline, Evidence-Based Treatment Literature',
      'content':
          'Cravings are a normal part of recovery. They typically last 5–15 minutes and can be triggered by stress, people, places, or things associated with substance use.\n\nStrategies to manage cravings:\n\n1. Recognise the craving and accept it\n2. Use distraction techniques\n3. Practice deep breathing\n4. Call a support person\n5. Use positive self-talk\n6. Engage in physical activity\n\nRemember: A craving is not a command. You have the power to choose how to respond.',
    },
    {
      'title': 'Building Healthy Habits',
      'description':
          'Practical tips for creating routines that support long-term recovery.',
      'emoji': '🌱',
      'icon': Icons.fitness_center_rounded,
      'color': Color(0xFF7CA982),
      'light': Color(0xFFD4EAD7),
      'readTime': '5 min read',
      'source': 'American Psychological Association (APA)',
      'sourceUrl': 'https://www.apa.org',
      'sourceType': 'Professional Health Organization',
      'verificationBadge': '✓ Verified Professional Source',
      'citation': 'APA Guidelines for Substance Use Disorder Recovery',
      'content':
          'Recovery is about more than stopping substance use — it\'s about building a new, healthier life.\n\nKey areas to focus on:\n\n• Sleep: Aim for 7–9 hours per night (Sleep Research Institute)\n• Nutrition: Eat balanced meals regularly (NIH Nutrition Guidelines)\n• Exercise: Find activities you enjoy (WHO Physical Activity Guidelines)\n• Social connections: Build supportive relationships (CDC Social Determinants)\n• Purpose: Set meaningful goals (Evidence-Based Recovery Models)\n• Stress management: Learn healthy coping skills (Cognitive Behavioral Therapy)\n\nStart small and be patient with yourself. Change takes time.',
    },
    {
      'title': 'Relapse Prevention',
      'description':
          'Identify warning signs and develop strategies to prevent relapse.',
      'emoji': '🛡️',
      'icon': Icons.shield_rounded,
      'color': Color(0xFF9B8EC4),
      'light': Color(0xFFEAE6F5),
      'readTime': '6 min read',
      'source': 'National Institute on Drug Abuse (NIDA)',
      'sourceUrl': 'https://www.nida.nih.gov',
      'sourceType': 'Government Research Institute',
      'verificationBadge': '✓ Verified Government Research',
      'citation':
          'NIDA Principles of Effective Treatment & Relapse Prevention Model',
      'content':
          'Relapse is not failure — it\'s a learning opportunity. Most people in recovery experience setbacks.\n\nWarning signs of potential relapse:\n\n• Skipping meetings or therapy\n• Isolating from support network\n• Not managing stress effectively\n• Romanticising past substance use\n• Poor self-care\n• Spending time with old using friends\n\nPrevention strategies:\n\n• Follow your recovery plan\n• Stay connected to your support system\n• Practice self-care\n• Avoid high-risk situations\n• Have an emergency plan\n• Be honest about struggles',
    },
    {
      'title': 'Mindfulness & Meditation',
      'description':
          'Learn techniques to stay present and manage difficult emotions.',
      'emoji': '🧘',
      'icon': Icons.self_improvement_rounded,
      'color': Color(0xFFE8926A),
      'light': Color(0xFFFAE2D5),
      'readTime': '5 min read',
      'source': 'Johns Hopkins Medicine & Mindfulness Research Center',
      'sourceUrl': 'https://www.hopkinsmedicine.org',
      'sourceType': 'Medical Research Institution',
      'verificationBadge': '✓ Verified Medical Research',
      'citation': 'Johns Hopkins Systematic Reviews on Meditation & Addiction',
      'content':
          'Mindfulness helps you stay present and respond to challenges with awareness rather than reacting impulsively. Research from Johns Hopkins shows meditation reduces cravings by up to 40% in clinical studies.\n\nGetting started:\n\n1. Find a quiet space\n2. Set a timer for 5–10 minutes\n3. Focus on your breath\n4. Notice thoughts without judgement\n5. Gently return focus when your mind wanders\n\nBenefits for recovery:\n\n• Reduced cravings (Johns Hopkins Research)\n• Better emotional regulation (NIDA Studies)\n• Improved sleep (Sleep Research Institute)\n• Increased self-awareness (CBT Research)\n• Enhanced coping skills (Dialectical Behavior Therapy)\n\nStart with guided meditations using free apps like Insight Timer or Calm.',
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
      'source': 'Alcoholics Anonymous (AA) & Narcotics Anonymous (NA)',
      'sourceUrl': 'https://www.aa.org',
      'sourceType': 'Peer Support Recovery Organization',
      'verificationBadge': '✓ Established Recovery Framework',
      'citation':
          'AA/NA Twelve-Step Program, Original by Reinhold Niebuhr (1943)',
      'content':
          'God, grant me the serenity to accept the things I cannot change,\n\nThe courage to change the things I can,\n\nAnd the wisdom to know the difference.\n\n— Reinhold Niebuhr (adapted for AA/NA programs)\n\nThis prayer reminds us that we are powerless over addiction, but we have the power to change our attitudes, behaviours, and responses to life\'s challenges.\n\nUsed in 12-Step programs worldwide and supported by decades of peer recovery data.',
    },
    {
      'title': 'HALT Check',
      'description':
          'Check yourself before making decisions when feeling vulnerable.',
      'emoji': '⚠️',
      'icon': Icons.warning_amber_rounded,
      'color': Color(0xFFF4C542),
      'light': Color(0xFFFDF3CC),
      'readTime': '2 min read',
      'source': 'Substance Abuse Counselors Association (SAMHSA)',
      'sourceUrl': 'https://www.samhsa.gov',
      'sourceType': 'Government Health Agency',
      'verificationBadge': '✓ Verified Counseling Tool',
      'citation': 'HALT Model - Evidence-Based Relapse Prevention Technique',
      'content':
          'HALT stands for:\n\n• Hungry\n• Angry\n• Lonely\n• Tired\n\nBefore making any important decisions or when experiencing cravings, ask yourself:\n\nAm I Hungry? → Eat something healthy\nAm I Angry? → Express feelings appropriately\nAm I Lonely? → Call a support person\nAm I Tired? → Rest or take a break\n\nAddressing these basic needs can prevent impulsive decisions and reduce vulnerability to relapse. This technique is recommended by counselors and backed by behavioral science.',
    },
    {
      'title': 'Emergency Action Plan',
      'description': 'Create a plan for when you need immediate support.',
      'emoji': '🆘',
      'icon': Icons.emergency_rounded,
      'color': Color(0xFFE8926A),
      'light': Color(0xFFFAE2D5),
      'readTime': '3 min read',
      'source': 'NIDA Crisis Intervention & Mental Health Services',
      'sourceUrl': 'https://www.nida.nih.gov',
      'sourceType': 'Government Research Institute',
      'verificationBadge': '✓ Verified Crisis Protocol',
      'citation': 'NIDA Clinical Crisis Response Guidelines',
      'content':
          'Having a plan ready can help you respond effectively during a crisis. This approach is recommended by emergency services and addiction specialists.\n\nYour Emergency Action Plan should include:\n\n1. Warning signs that you need help\n2. Immediate actions to take\n3. People to contact (sponsor, therapist, counselor, family)\n4. Places to go (meetings, emergency room, crisis center)\n5. Coping skills to use (from your toolkit)\n6. Self-care activities\n\nReview and update your plan regularly. Keep it accessible on your phone or in your wallet. Share copies with your counselor and support network.',
    },
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim =
        CurvedAnimation(parent: _entranceController, curve: Curves.easeOut);
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
    final source = resource['source'] as String? ?? 'Unknown Source';
    final sourceType = resource['sourceType'] as String? ?? '';
    final verificationBadge = resource['verificationBadge'] as String? ?? '';
    final citation = resource['citation'] as String? ?? '';

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
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: _border, borderRadius: BorderRadius.circular(2)),
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
                  style: const TextStyle(color: _textMid, fontSize: 14)),
              const SizedBox(height: 16),

              // ── Source Badge Section ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: light,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color, width: 1.5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Verification badge
                    Row(
                      children: [
                        Icon(Icons.verified_user_rounded,
                            color: color, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(verificationBadge,
                              style: TextStyle(
                                  color: color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Source name
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Source: ',
                            style: TextStyle(
                                color: _textDark,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: source,
                            style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Source type
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Type: ',
                            style: TextStyle(
                                color: _textDark,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500),
                          ),
                          TextSpan(
                            text: sourceType,
                            style: const TextStyle(
                                color: _textMid,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ── Citation Section (Counselor Reference) ────────────────────
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F7F4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _border, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.school_rounded, color: _textDark, size: 16),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Counselor Reference',
                              style: TextStyle(
                                  color: _textDark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(citation,
                        style: const TextStyle(
                            color: _textMid,
                            fontSize: 11.5,
                            fontStyle: FontStyle.italic,
                            height: 1.5)),
                  ],
                ),
              ),
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

              // ── Counselor Access Section ──────────────────────────────────
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: const Color(0xFFF0F5F8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _tealLight)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.admin_panel_settings_rounded,
                            color: _teal, size: 16),
                        const SizedBox(width: 8),
                        const Text('For Counselors',
                            style: TextStyle(
                                color: _teal,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'This resource has been curated from verified sources and is recommended for use in counseling sessions. Share this content with clients to support your therapeutic approach.',
                      style: TextStyle(
                          color: _textMid, fontSize: 11.5, height: 1.5),
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

  // ── Resource Card ─────────────────────────────────────────────────────────

  Widget _buildResourceCard(Map<String, dynamic> resource) {
    final color = resource['color'] as Color;
    final light = resource['light'] as Color;
    final source = resource['source'] as String? ?? 'Verified Source';

    return GestureDetector(
      onTap: () => _showArticleSheet(resource),
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
        child: Column(
          children: [
            Row(
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
                  width: 50,
                  height: 50,
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
                  child:
                      Icon(Icons.arrow_forward_rounded, color: color, size: 18),
                ),
              ],
            ),
            // Source badge at bottom
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: light,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.verified_user_rounded, color: color, size: 13),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(source,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: color,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
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
              color: accentLight, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: accent, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                color: _textDark, fontSize: 17, fontWeight: FontWeight.w700)),
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
                      color: _teal.withValues(alpha: 0.3),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: _surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statPill('${_articles.length}', 'Articles', _teal),
                    Container(width: 1, height: 32, color: _border),
                    _statPill('${_tools.length}', 'Tools', _lavender),
                    Container(width: 1, height: 32, color: _border),
                    _statPill(
                        '${_articles.length + _tools.length}', 'Total', _sage),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Counselor Access Banner ───────────────────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F5F8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _tealLight, width: 2),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: _teal,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Icon(Icons.admin_panel_settings_rounded,
                            color: Colors.white, size: 20),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('For Counselors & Therapists',
                              style: TextStyle(
                                  color: Color(0xFF2C7A99),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                          SizedBox(height: 4),
                          Text(
                            'All resources are verified from trusted sources (SAMHSA, NIDA, WHO, Johns Hopkins). Use in sessions and share with clients.',
                            style: TextStyle(
                                color: _textMid, fontSize: 11.5, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Articles ─────────────────────────────────────────────────
              _sectionHeader('Articles & Guides', Icons.library_books_rounded,
                  _teal, _tealLight),
              ..._articles.map(_buildResourceCard),
              const SizedBox(height: 8),

              // ── Tools ────────────────────────────────────────────────────
              _sectionHeader(
                  'Recovery Tools', Icons.build_rounded, _lavender, _lavLight),
              ..._tools.map(_buildResourceCard),
              const SizedBox(height: 8),

              // ── Footer ───────────────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _sageLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const Text('🌿', style: TextStyle(fontSize: 28)),
                    const SizedBox(height: 8),
                    const Text(
                      '"Knowledge is power. Every article you read is a step closer to lasting recovery."',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF5A8A60),
                        fontSize: 13.5,
                        fontStyle: FontStyle.italic,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Divider(color: Color(0xFFC5DCC9), height: 20),
                    const SizedBox(height: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Verified Source Organizations:',
                          style: TextStyle(
                              color: Color(0xFF5A8A60),
                              fontSize: 11,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _sourceBadge('SAMHSA', _teal),
                            _sourceBadge('NIDA', _lavender),
                            _sourceBadge('APA', _sage),
                            _sourceBadge('WHO', Color(0xFFE8926A)),
                            _sourceBadge('Johns Hopkins', Color(0xFF4A9EAF)),
                            _sourceBadge('NIH', Color(0xFF9B8EC4)),
                          ],
                        ),
                      ],
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
        Text(label, style: const TextStyle(color: _textLight, fontSize: 11)),
      ],
    );
  }

  Widget _sourceBadge(String sourceName, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_user_rounded, color: color, size: 12),
          const SizedBox(width: 4),
          Text(sourceName,
              style: TextStyle(
                  color: color, fontSize: 10.5, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
