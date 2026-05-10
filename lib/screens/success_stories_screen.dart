import 'package:flutter/material.dart';

class SuccessStoriesScreen extends StatefulWidget {
  const SuccessStoriesScreen({super.key});

  @override
  State<SuccessStoriesScreen> createState() => _SuccessStoriesScreenState();
}

class _SuccessStoriesScreenState extends State<SuccessStoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;

  // ── Palette ───────────────────────────────────────────────────────────────
  static const Color _bg         = Color(0xFFF6F4F0);
  static const Color _surface    = Color(0xFFFFFFFF);
  static const Color _sage       = Color(0xFF7CA982);
  static const Color _sageLight  = Color(0xFFD4EAD7);
  static const Color _teal       = Color(0xFF4A9EAF);
  static const Color _peach      = Color(0xFFE8926A);
  static const Color _peachLight = Color(0xFFFAE2D5);
  static const Color _gold       = Color(0xFFF4C542);
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7280);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  // Each story gets its own accent pair
  static const List<List<Color>> _accentPairs = [
    [Color(0xFF7CA982), Color(0xFFD4EAD7)],   // sage
    [Color(0xFF4A9EAF), Color(0xFFD6EEF3)],   // teal
    [Color(0xFFE8926A), Color(0xFFFAE2D5)],   // peach
    [Color(0xFF9B8EC4), Color(0xFFEAE6F5)],   // lavender
  ];

  final List<Map<String, dynamic>> _stories = [
    {
      'title': 'From Rock Bottom to Recovery',
      'author': 'Marcus L.',
      'daysSober': 1247,
      'emoji': '🙏',
      'tag': '3+ Years',
      'excerpt': 'I lost everything — my job, my family, my home. Today I\'ve been sober for 3+ years and life has never felt more meaningful.',
      'fullStory': 'I hit rock bottom when I was arrested and my family stopped speaking to me. That was the wake-up call I needed. I started attending NA meetings daily, found a sponsor who believed in me, and worked hard to rebuild my life. Today I have a job, I\'ve reconciled with my family, and I mentor other people in recovery. Recovery is possible.',
    },
    {
      'title': 'Finding Purpose in Recovery',
      'author': 'Jessica H.',
      'daysSober': 892,
      'emoji': '⭐',
      'tag': '2+ Years',
      'excerpt': 'Addiction robbed me of my dreams. Now I\'m back in school and helping others find their path forward.',
      'fullStory': 'When I got sober, I realized I had lost so much time and opportunity. But instead of dwelling on that, I decided to use my experience to help others. I went back to school, became a certified addiction counselor, and now I work with people struggling with addiction. My pain has become my purpose.',
    },
    {
      'title': 'Second Chance at Life',
      'author': 'David T.',
      'daysSober': 634,
      'emoji': '❤️',
      'tag': '1.5+ Years',
      'excerpt': 'My kids didn\'t recognize me. Now we\'re rebuilding our relationship every day, one moment at a time.',
      'fullStory': 'The hardest part of my recovery wasn\'t quitting the drugs — it was facing the people I\'d hurt. My kids wanted nothing to do with me at first. But I stayed committed to my recovery, showed up to visitations consistently, and gradually earned their trust back. Today we\'re rebuilding our relationship one day at a time.',
    },
    {
      'title': 'Overcoming Relapse & Resilience',
      'author': 'Amy K.',
      'daysSober': 456,
      'emoji': '💪',
      'tag': '1+ Year',
      'excerpt': 'I relapsed after 2 years sober. But I got back up and I\'m stronger now than I\'ve ever been.',
      'fullStory': 'Having a relapse after 2 years was devastating. But I learned that recovery isn\'t about perfection — it\'s about perseverance. I went back to my support network, worked with my counselor to understand my triggers, and came out of it stronger. I\'ve now been sober for over a year since my relapse, and I\'m more committed than ever.',
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

  // ── Story Detail Sheet ────────────────────────────────────────────────────

  void _showStoryDetail(Map<String, dynamic> story, int index) {
    final accent      = _accentPairs[index % _accentPairs.length][0];
    final accentLight = _accentPairs[index % _accentPairs.length][1];

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

              // Hero emoji
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  color: accentLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Text(story['emoji'],
                        style: const TextStyle(fontSize: 56)),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${story['daysSober']} days sober',
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

              // Title & author
              Text(story['title'],
                  style: const TextStyle(
                      color: _textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3)),
              const SizedBox(height: 6),
              Row(children: [
                Icon(Icons.person_rounded, color: accent, size: 16),
                const SizedBox(width: 5),
                Text(story['author'],
                    style: TextStyle(
                        color: accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 20),

              // Full story
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _bg,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _border),
                ),
                child: Text(
                  story['fullStory'],
                  style: const TextStyle(
                      color: _textMid, fontSize: 15, height: 1.75),
                ),
              ),
              const SizedBox(height: 24),

              // Share button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Story shared! 🌟'),
                      backgroundColor: accent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                icon: const Icon(Icons.share_rounded),
                label: const Text('Share This Story',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent,
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

  // ── Story Card ────────────────────────────────────────────────────────────

  Widget _buildStoryCard(Map<String, dynamic> story, int index) {
    final accent      = _accentPairs[index % _accentPairs.length][0];
    final accentLight = _accentPairs[index % _accentPairs.length][1];

    return GestureDetector(
      onTap: () => _showStoryDetail(story, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Colored top strip
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: accent,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(22)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Emoji bubble
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: accentLight,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Text(story['emoji'],
                              style: const TextStyle(fontSize: 28)),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              story['title'],
                              style: const TextStyle(
                                color: _textDark,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(children: [
                              Icon(Icons.person_rounded,
                                  color: accent, size: 13),
                              const SizedBox(width: 4),
                              Text(story['author'],
                                  style: TextStyle(
                                      color: accent,
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600)),
                            ]),
                          ],
                        ),
                      ),
                      // Days sober badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: accentLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${story['daysSober']}',
                              style: TextStyle(
                                color: accent,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                height: 1,
                              ),
                            ),
                            Text(
                              'days',
                              style: TextStyle(
                                  color: accent.withValues(alpha: 0.7),
                                  fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Excerpt
                  Text(
                    story['excerpt'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: _textMid, fontSize: 13.5, height: 1.55),
                  ),
                  const SizedBox(height: 14),

                  // Footer row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: accentLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.emoji_events_rounded,
                                color: accent, size: 13),
                            const SizedBox(width: 4),
                            Text(story['tag'],
                                style: TextStyle(
                                    color: accent,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      Row(children: [
                        Text('Read story',
                            style: TextStyle(
                                color: accent,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded,
                            color: accent, size: 15),
                      ]),
                    ],
                  ),
                ],
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
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Success Stories',
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
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          children: [

            // ── Inspiration Banner ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Real Stories,',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500)),
                        Text('Real Hope 🌟',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                height: 1.2)),
                        SizedBox(height: 8),
                        Text(
                          'Every story here is proof that recovery is possible. You are not alone.',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Text('✨', style: TextStyle(fontSize: 48)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Summary strip ─────────────────────────────────────────────
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 14,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _summaryPill(
                    '${_stories.length}',
                    'Stories',
                    Icons.auto_stories_rounded,
                    _sage,
                  ),
                  Container(width: 1, height: 36, color: _border),
                  _summaryPill(
                    '${_stories.map((s) => s['daysSober'] as int).reduce((a, b) => a + b)}',
                    'Days Combined',
                    Icons.calendar_today_rounded,
                    _teal,
                  ),
                  Container(width: 1, height: 36, color: _border),
                  _summaryPill(
                    '4+',
                    'Years Sober',
                    Icons.emoji_events_rounded,
                    _gold,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Section label ─────────────────────────────────────────────
            Row(children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: _peachLight,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.favorite_rounded, color: _peach, size: 16),
              ),
              const SizedBox(width: 10),
              const Text('Community Stories',
                  style: TextStyle(
                      color: _textDark,
                      fontSize: 17,
                      fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 14),

            // ── Story Cards ───────────────────────────────────────────────
            for (int i = 0; i < _stories.length; i++)
              _buildStoryCard(_stories[i], i),

            // ── Footer ────────────────────────────────────────────────────
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _sageLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: const [
                  Text('Share Your Story',
                      style: TextStyle(
                          color: Color(0xFF7CA982),
                          fontSize: 16,
                          fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text(
                    'Your journey could inspire someone else to take their first step toward recovery.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF5A8A60),
                        fontSize: 13,
                        height: 1.5),
                  ),
                  SizedBox(height: 14),
                  _ShareButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryPill(
      String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                height: 1)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: _textLight, fontSize: 11)),
      ],
    );
  }
}

// ── Share Button (extracted to avoid const issues) ────────────────────────────
class _ShareButton extends StatelessWidget {
  const _ShareButton();

  static const Color _sage = Color(0xFF7CA982);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Story submission coming soon! 🌱'),
              backgroundColor: _sage,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
        icon: const Icon(Icons.edit_rounded, size: 18),
        label: const Text('Submit My Story',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _sage,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }
}
