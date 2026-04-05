import 'package:flutter/material.dart';

class JournalEntriesScreen extends StatefulWidget {
  const JournalEntriesScreen({Key? key}) : super(key: key);

  @override
  State<JournalEntriesScreen> createState() => _JournalEntriesScreenState();
}

class _JournalEntriesScreenState extends State<JournalEntriesScreen>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = 'All';
  late AnimationController _fabController;

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
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7280);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  // ── Category styling ──────────────────────────────────────────────────────
  static const Map<String, Map<String, dynamic>> _catStyle = {
    'Positive':    {'color': Color(0xFF7CA982), 'light': Color(0xFFD4EAD7), 'icon': Icons.sentiment_very_satisfied_rounded},
    'Neutral':     {'color': Color(0xFF4A9EAF), 'light': Color(0xFFD6EEF3), 'icon': Icons.sentiment_neutral_rounded},
    'Challenging': {'color': Color(0xFFE8926A), 'light': Color(0xFFFAE2D5), 'icon': Icons.sentiment_dissatisfied_rounded},
    'Personal':    {'color': Color(0xFF9B8EC4), 'light': Color(0xFFEAE6F5), 'icon': Icons.person_rounded},
  };

  final List<Map<String, dynamic>> _journalEntries = [
    {
      'date': 'April 4, 2026',
      'title': 'Feeling Strong Today',
      'content': 'Had a great day without any cravings. Went to support group and felt really supported.',
      'mood': '😊',
      'category': 'Positive',
    },
    {
      'date': 'April 3, 2026',
      'title': 'Managing Stress',
      'content': 'Work was challenging today but I handled it well. Used breathing techniques.',
      'mood': '😐',
      'category': 'Neutral',
    },
    {
      'date': 'April 2, 2026',
      'title': 'Milestone Celebration',
      'content': 'Reached 30 days sober! So proud of myself. Had a challenging moment at lunch but stayed strong.',
      'mood': '😊',
      'category': 'Positive',
    },
    {
      'date': 'April 1, 2026',
      'title': 'Struggled but Stayed Strong',
      'content': 'Had a moment of weakness but called my sponsor. We talked through it and I feel better.',
      'mood': '😔',
      'category': 'Challenging',
    },
    {
      'date': 'March 31, 2026',
      'title': 'Good Support System',
      'content': 'Spent time with my recovery group. Reminded me why I\'m doing this.',
      'mood': '😊',
      'category': 'Positive',
    },
  ];

  // Mood → emoji mapping for filtering display
  static const List<Map<String, String>> _filters = [
    {'label': 'All',  'emoji': ''},
    {'label': '😊',   'emoji': '😊'},
    {'label': '😐',   'emoji': '😐'},
    {'label': '😔',   'emoji': '😔'},
    {'label': '😢',   'emoji': '😢'},
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selectedFilter == 'All') return _journalEntries;
    return _journalEntries
        .where((e) => e['mood'].toString() == _selectedFilter)
        .toList();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Color _catColor(String cat)  => (_catStyle[cat]?['color']  as Color?) ?? _lavender;
  Color _catLight(String cat)  => (_catStyle[cat]?['light']  as Color?) ?? _lavLight;
  IconData _catIcon(String cat) => (_catStyle[cat]?['icon'] as IconData?) ?? Icons.label_rounded;

  // ── Filter Chip ───────────────────────────────────────────────────────────

  Widget _filterChip(String label, String emoji) {
    final selected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? _sage : _surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? _sage : _border),
          boxShadow: selected
              ? [BoxShadow(color: _sage.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 3))]
              : [],
        ),
        child: Text(
          label == 'All' ? 'All Moods' : emoji,
          style: TextStyle(
            color: selected ? Colors.white : _textMid,
            fontSize: label == 'All' ? 13 : 18,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ── Entry Card ────────────────────────────────────────────────────────────

  Widget _buildEntryCard(Map<String, dynamic> entry, int index) {
    final cat   = entry['category'] as String;
    final color = _catColor(cat);
    final light = _catLight(cat);

    return GestureDetector(
      onTap: () => _showEntryDetails(entry),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mood bubble
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: light,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Center(
                          child: Text(entry['mood'],
                              style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry['title'],
                              style: const TextStyle(
                                color: _textDark,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                Icon(Icons.calendar_today_rounded,
                                    size: 11, color: _textLight),
                                const SizedBox(width: 4),
                                Text(entry['date'],
                                    style: const TextStyle(
                                        color: _textLight, fontSize: 12)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        color: _surface,
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditEntryDialog(entry);
                          } else if (value == 'delete') {
                            setState(() => _journalEntries.remove(entry));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Entry deleted'),
                                backgroundColor: _peach,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            );
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(children: [
                              Icon(Icons.edit_rounded, color: _teal, size: 18),
                              const SizedBox(width: 8),
                              const Text('Edit',
                                  style: TextStyle(color: _textDark)),
                            ]),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(children: [
                              Icon(Icons.delete_outline_rounded,
                                  color: _peach, size: 18),
                              const SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: _peach)),
                            ]),
                          ),
                        ],
                        child:
                            Icon(Icons.more_vert_rounded, color: _textLight),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    entry['content'],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: _textMid, fontSize: 13.5, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: light,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_catIcon(cat), color: color, size: 12),
                            const SizedBox(width: 4),
                            Text(cat,
                                style: TextStyle(
                                    color: color,
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.chevron_right_rounded,
                          color: _textLight, size: 18),
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

  // ── Bottom Sheet base ─────────────────────────────────────────────────────

  void _showSheet(BuildContext context, {required Widget child}) {
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
          child: child,
        ),
      ),
    );
  }

  Widget _sheetHandle() => Center(
        child: Container(
          width: 40,
          height: 4,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              color: _border, borderRadius: BorderRadius.circular(2)),
        ),
      );

  Widget _sheetTitle(String text) => Text(text,
      style: const TextStyle(
          color: _textDark, fontSize: 18, fontWeight: FontWeight.w800));

  // ── Entry Details Sheet ───────────────────────────────────────────────────

  void _showEntryDetails(Map<String, dynamic> entry) {
    final cat   = entry['category'] as String;
    final color = _catColor(cat);
    final light = _catLight(cat);
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
            color: _surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              _sheetHandle(),
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                        color: light, borderRadius: BorderRadius.circular(16)),
                    child: Center(
                      child: Text(entry['mood'],
                          style: const TextStyle(fontSize: 28)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry['title'],
                            style: const TextStyle(
                                color: _textDark,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Row(children: [
                          Icon(Icons.calendar_today_rounded,
                              size: 12, color: _textLight),
                          const SizedBox(width: 4),
                          Text(entry['date'],
                              style: const TextStyle(
                                  color: _textLight, fontSize: 12)),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                    color: light, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_catIcon(cat), color: color, size: 14),
                    const SizedBox(width: 6),
                    Text(cat,
                        style: TextStyle(
                            color: color,
                            fontSize: 12,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: _bg, borderRadius: BorderRadius.circular(16)),
                child: Text(entry['content'],
                    style: const TextStyle(
                        color: _textMid, fontSize: 15, height: 1.7)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── New Entry Sheet ───────────────────────────────────────────────────────

  void _showNewEntryDialog(BuildContext context) {
    final titleController   = TextEditingController();
    final contentController = TextEditingController();
    String tempMood = '😊';

    _showSheet(
      context,
      child: StatefulBuilder(
        builder: (ctx, setSheet) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _sheetHandle(),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: _sageLight,
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.edit_rounded, color: _sage, size: 18),
                ),
                const SizedBox(width: 10),
                _sheetTitle('New Journal Entry'),
              ],
            ),
            const SizedBox(height: 20),
            _sheetInput(titleController, 'Entry title', Icons.title_rounded),
            const SizedBox(height: 12),
            _sheetInput(contentController, 'Write your thoughts…',
                Icons.notes_rounded,
                maxLines: 5),
            const SizedBox(height: 16),
            const Text('How are you feeling?',
                style: TextStyle(
                    color: _textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final m in ['😊', '😐', '😔', '😢'])
                  GestureDetector(
                    onTap: () => setSheet(() => tempMood = m),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: tempMood == m ? _sageLight : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: tempMood == m ? _sage : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(m,
                          style: TextStyle(
                              fontSize: tempMood == m ? 30 : 26)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  setState(() {
                    _journalEntries.insert(0, {
                      'date': 'April 5, 2026',
                      'title': titleController.text,
                      'content': contentController.text,
                      'mood': tempMood,
                      'category': 'Personal',
                    });
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Journal entry saved! 🌿'),
                      backgroundColor: _sage,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _sage,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('Save Entry',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Edit Entry Sheet ──────────────────────────────────────────────────────

  void _showEditEntryDialog(Map<String, dynamic> entry) {
    final titleController =
        TextEditingController(text: entry['title'] as String);
    final contentController =
        TextEditingController(text: entry['content'] as String);

    _showSheet(
      context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _sheetHandle(),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: _tealLight,
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(Icons.edit_note_rounded, color: _teal, size: 18),
              ),
              const SizedBox(width: 10),
              _sheetTitle('Edit Entry'),
            ],
          ),
          const SizedBox(height: 20),
          _sheetInput(titleController, 'Entry title', Icons.title_rounded),
          const SizedBox(height: 12),
          _sheetInput(contentController, 'Write your thoughts…',
              Icons.notes_rounded,
              maxLines: 5),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                entry['title']   = titleController.text;
                entry['content'] = contentController.text;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Entry updated!'),
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
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 0,
            ),
            child: const Text('Update Entry',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

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
        prefixIcon: maxLines == 1
            ? Icon(icon, color: _textLight, size: 20)
            : null,
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
            borderSide: const BorderSide(color: _sage, width: 1.5)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        title: const Text('Journal Entries',
            style: TextStyle(
                color: _textDark,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _showNewEntryDialog(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: _sage,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.add_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text('New',
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
      body: Column(
        children: [

          // ── Stats Banner ─────────────────────────────────────────────────
          Container(
            color: _surface,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
            child: Row(
              children: [
                _statPill(
                    _journalEntries.length.toString(), 'Total', _sage),
                _dividerV(),
                _statPill(
                    _journalEntries
                        .where((e) => e['category'] == 'Positive')
                        .length
                        .toString(),
                    'Positive',
                    _sage),
                _dividerV(),
                _statPill(
                    _journalEntries
                        .where((e) => e['category'] == 'Challenging')
                        .length
                        .toString(),
                    'Challenging',
                    _peach),
                _dividerV(),
                _statPill(
                    _journalEntries
                        .where((e) => e['category'] == 'Neutral')
                        .length
                        .toString(),
                    'Neutral',
                    _teal),
              ],
            ),
          ),
          Divider(height: 1, color: _border),

          // ── Filter row ───────────────────────────────────────────────────
          Container(
            color: _surface,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
            child: SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (final f in _filters)
                    _filterChip(f['label']!, f['emoji']!),
                ],
              ),
            ),
          ),

          // ── Entry List ───────────────────────────────────────────────────
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
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.book_rounded,
                              color: _sage, size: 40),
                        ),
                        const SizedBox(height: 20),
                        const Text('No entries found',
                            style: TextStyle(
                                color: _textDark,
                                fontSize: 17,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        const Text(
                          'Start journaling your recovery journey',
                          style:
                              TextStyle(color: _textMid, fontSize: 13.5),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => _showNewEntryDialog(context),
                          icon: const Icon(Icons.add_rounded),
                          label: const Text('Write First Entry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _sage,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: filtered.length,
                    itemBuilder: (_, i) =>
                        _buildEntryCard(filtered[i], i),
                  ),
          ),
        ],
      ),

      // ── FAB ──────────────────────────────────────────────────────────────
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewEntryDialog(context),
        backgroundColor: _sage,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.edit_rounded),
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
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  height: 1)),
          const SizedBox(height: 3),
          Text(label,
              style:
                  const TextStyle(color: _textLight, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _dividerV() =>
      Container(width: 1, height: 32, color: _border);
}