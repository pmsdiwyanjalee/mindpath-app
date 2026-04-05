import 'package:flutter/material.dart';

class CommunityForumScreen extends StatefulWidget {
  const CommunityForumScreen({Key? key}) : super(key: key);

  @override
  State<CommunityForumScreen> createState() => _CommunityForumScreenState();
}

class _CommunityForumScreenState extends State<CommunityForumScreen>
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
    'Milestone': {'emoji': '✅', 'color': Color(0xFF7CA982), 'light': Color(0xFFD4EAD7)},
    'Support':   {'emoji': '🆘', 'color': Color(0xFFE8926A), 'light': Color(0xFFFAE2D5)},
    'Gratitude': {'emoji': '❤️', 'color': Color(0xFF9B8EC4), 'light': Color(0xFFEAE6F5)},
    'Tips':      {'emoji': '💡', 'color': Color(0xFFF4C542), 'light': Color(0xFFFDF3CC)},
  };

  static const List<String> _filterLabels = ['All', 'Milestone', 'Support', 'Gratitude', 'Tips'];

  final List<Map<String, dynamic>> _posts = [
    {
      'author': 'Sarah M.',
      'avatar': '👩',
      'timeAgo': '2 hours ago',
      'title': 'Day 30 — Feeling amazing!',
      'content': 'Just hit the 30-day mark! Hardest month of my life but so proud of myself. To anyone just starting out — it gets better, I promise.',
      'likes': 45,
      'replies': 12,
      'category': 'Milestone',
      'liked': false,
    },
    {
      'author': 'James K.',
      'avatar': '👨',
      'timeAgo': '4 hours ago',
      'title': 'Struggling with cravings at night',
      'content': 'Every night around 9 PM I get really strong urges. Anyone else experience this? What helps you get through it?',
      'likes': 23,
      'replies': 18,
      'category': 'Support',
      'liked': false,
    },
    {
      'author': 'Emma T.',
      'avatar': '👩‍🦰',
      'timeAgo': '6 hours ago',
      'title': 'My counsellor is amazing',
      'content': 'Shout-out to Dr. Lisa for being so understanding and helping me work through my triggers. Grateful to have such a great support system.',
      'likes': 67,
      'replies': 8,
      'category': 'Gratitude',
      'liked': false,
    },
    {
      'author': 'Michael R.',
      'avatar': '👨‍💼',
      'timeAgo': '8 hours ago',
      'title': 'Staying motivated during recovery',
      'content': 'Anyone want to share tips for staying motivated and financially stable during recovery? I\'d love to hear what works for you.',
      'likes': 15,
      'replies': 22,
      'category': 'Tips',
      'liked': false,
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
      ? _posts
      : _posts.where((p) => p['category'] == _selectedCategory).toList();

  Color _catColor(String cat) =>
      (_catConfig[cat]?['color'] as Color?) ?? _lavender;
  Color _catLight(String cat) =>
      (_catConfig[cat]?['light'] as Color?) ?? _lavLight;
  String _catEmoji(String cat) =>
      (_catConfig[cat]?['emoji'] as String?) ?? '💬';

  // ── New Post Sheet ────────────────────────────────────────────────────────

  void _showNewPostSheet() {
    final titleController   = TextEditingController();
    final contentController = TextEditingController();
    String tempCat = 'Milestone';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          decoration: const BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: StatefulBuilder(
            builder: (ctx, setSheet) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: _tealLight,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.edit_rounded, color: _teal, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Text('New Post',
                      style: TextStyle(
                          color: _textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 20),

                // Title
                _sheetInput(titleController, 'Post title', Icons.title_rounded),
                const SizedBox(height: 12),
                _sheetInput(contentController, 'Share your thoughts…',
                    Icons.notes_rounded,
                    maxLines: 4),
                const SizedBox(height: 16),

                // Category picker
                const Text('Category',
                    style: TextStyle(
                        color: _textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _catConfig.entries.map((e) {
                    final selected = tempCat == e.key;
                    final color = e.value['color'] as Color;
                    final light = e.value['light'] as Color;
                    return GestureDetector(
                      onTap: () => setSheet(() => tempCat = e.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected ? color : light,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${e.value['emoji']} ${e.key}',
                          style: TextStyle(
                            color: selected ? Colors.white : color,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      setState(() {
                        _posts.insert(0, {
                          'author': 'You',
                          'avatar': '🧑',
                          'timeAgo': 'Just now',
                          'title': titleController.text,
                          'content': contentController.text,
                          'likes': 0,
                          'replies': 0,
                          'category': tempCat,
                          'liked': false,
                        });
                      });
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Post shared with the community! 🌿'),
                          backgroundColor: _sage,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: const Text('Post to Community',
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

  // ── Post Detail Sheet ─────────────────────────────────────────────────────

  void _showPostDetail(Map<String, dynamic> post) {
    final replyController = TextEditingController();
    final color = _catColor(post['category'] as String);
    final light = _catLight(post['category'] as String);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: _border,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),

              // Author row
              Row(children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                      color: light, borderRadius: BorderRadius.circular(14)),
                  child: Center(
                    child: Text(post['avatar'],
                        style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(post['author'],
                          style: const TextStyle(
                              color: _textDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                      Text(post['timeAgo'],
                          style: const TextStyle(
                              color: _textLight, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: light, borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    '${_catEmoji(post['category'])} ${post['category']}',
                    style: TextStyle(
                        color: color,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
              const SizedBox(height: 16),

              // Title
              Text(post['title'],
                  style: const TextStyle(
                      color: _textDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      height: 1.3)),
              const SizedBox(height: 12),

              // Content
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: _bg, borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _border)),
                child: Text(post['content'],
                    style: const TextStyle(
                        color: _textMid, fontSize: 14.5, height: 1.65)),
              ),
              const SizedBox(height: 16),

              // Stats
              Row(children: [
                _statChip(Icons.favorite_rounded, '${post['likes']}', _peach,
                    _peachLight),
                const SizedBox(width: 10),
                _statChip(Icons.chat_bubble_rounded, '${post['replies']}',
                    _teal, _tealLight),
              ]),
              const SizedBox(height: 20),

              Divider(color: _border),
              const SizedBox(height: 16),

              const Text('Write a Reply',
                  style: TextStyle(
                      color: _textDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              _sheetInput(replyController, 'Share your thoughts or support…',
                  Icons.chat_rounded,
                  maxLines: 3),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Reply posted!'),
                      backgroundColor: _teal,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Post Reply',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Post Card ─────────────────────────────────────────────────────────────

  Widget _buildPostCard(Map<String, dynamic> post, int index) {
    final cat   = post['category'] as String;
    final color = _catColor(cat);
    final light = _catLight(cat);
    final liked = post['liked'] as bool;

    return GestureDetector(
      onTap: () => _showPostDetail(post),
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
            // Colored top strip
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Author + category
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                            color: light,
                            borderRadius: BorderRadius.circular(14)),
                        child: Center(
                          child: Text(post['avatar'],
                              style: const TextStyle(fontSize: 22)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post['author'],
                                style: const TextStyle(
                                    color: _textDark,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13.5)),
                            Text(post['timeAgo'],
                                style: const TextStyle(
                                    color: _textLight, fontSize: 11.5)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: light,
                            borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          '${_catEmoji(cat)} $cat',
                          style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(post['title'],
                      style: const TextStyle(
                          color: _textDark,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          height: 1.3)),
                  const SizedBox(height: 6),

                  // Content preview
                  Text(
                    post['content'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: _textMid, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 14),

                  // Footer
                  Row(
                    children: [
                      // Like button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            post['liked'] = !liked;
                            post['likes'] = (post['likes'] as int) +
                                (liked ? -1 : 1);
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: liked ? _peachLight : _bg,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: liked ? _peach : _border,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                liked
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                color: liked ? _peach : _textLight,
                                size: 15,
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '${post['likes']}',
                                style: TextStyle(
                                  color: liked ? _peach : _textMid,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Reply chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _tealLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.chat_bubble_rounded,
                                color: _teal, size: 15),
                            const SizedBox(width: 5),
                            Text('${post['replies']}',
                                style: TextStyle(
                                    color: _teal,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(children: [
                        Text('Read more',
                            style: TextStyle(
                                color: color,
                                fontSize: 12,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 3),
                        Icon(Icons.arrow_forward_rounded,
                            color: color, size: 14),
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

  // ── Shared Widgets ────────────────────────────────────────────────────────

  Widget _sheetInput(
    TextEditingController controller,
    String hint,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: _textDark, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _textLight),
        prefixIcon:
            maxLines == 1 ? Icon(icon, color: _textLight, size: 20) : null,
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
            borderSide: const BorderSide(color: _teal, width: 1.5)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _statChip(
      IconData icon, String value, Color color, Color light) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: light,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 6),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: FontWeight.w700)),
        ],
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Community Forum',
            style: TextStyle(
                color: _textDark,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: _showNewPostSheet,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: _teal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.add_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text('Post',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
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
        child: Column(
          children: [

            // ── Community Banner ────────────────────────────────────────
            Container(
              color: _surface,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  _communityStatPill(
                      '${_posts.length}', 'Posts', _teal),
                  _dividerV(),
                  _communityStatPill(
                      '${_posts.map((p) => p['likes'] as int).reduce((a, b) => a + b)}',
                      'Likes',
                      _peach),
                  _dividerV(),
                  _communityStatPill(
                      '${_posts.map((p) => p['replies'] as int).reduce((a, b) => a + b)}',
                      'Replies',
                      _lavender),
                  _dividerV(),
                  _communityStatPill('4', 'Members', _sage),
                ],
              ),
            ),
            Divider(height: 1, color: _border),

            // ── Filter Row ──────────────────────────────────────────────
            Container(
              color: _surface,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _filterLabels.map((label) {
                    final selected = _selectedCategory == label;
                    final color = label == 'All'
                        ? _teal
                        : _catColor(label);
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = label),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
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
                        child: Text(
                          label == 'All'
                              ? 'All Posts'
                              : '${_catEmoji(label)} $label',
                          style: TextStyle(
                            color: selected ? Colors.white : _textMid,
                            fontSize: 12.5,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // ── Posts ───────────────────────────────────────────────────
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                                color: _tealLight,
                                shape: BoxShape.circle),
                            child: Icon(Icons.forum_rounded,
                                color: _teal, size: 40),
                          ),
                          const SizedBox(height: 20),
                          const Text('No posts found',
                              style: TextStyle(
                                  color: _textDark,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Text('Be the first to post in this category',
                              style: TextStyle(
                                  color: _textMid, fontSize: 13.5)),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _showNewPostSheet,
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Create a Post'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) =>
                          _buildPostCard(filtered[i], i),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewPostSheet,
        backgroundColor: _teal,
        foregroundColor: Colors.white,
        elevation: 4,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.edit_rounded),
      ),
    );
  }

  Widget _communityStatPill(String value, String label, Color color) {
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