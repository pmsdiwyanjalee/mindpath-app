import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JournalEntriesScreen extends StatefulWidget {
  const JournalEntriesScreen({super.key});

  @override
  State<JournalEntriesScreen> createState() => _JournalEntriesScreenState();
}

class _JournalEntriesScreenState extends State<JournalEntriesScreen>
    with SingleTickerProviderStateMixin {
  String _selectedFilter = 'All';
  String _selectedMoodFilter = 'All';
  String _searchQuery = '';
  late AnimationController _fabController;
  
  // Search controller
  final TextEditingController _searchController = TextEditingController();
  
  // Date range filter
  DateTimeRange? _selectedDateRange;
  
  // Sort options
  String _sortBy = 'date'; // 'date' or 'title'
  bool _sortDescending = true;

  // ── Palette ───────────────────────────────────────────────────────────────
  static const Color _bg         = Color(0xFFF6F4F0);
  static const Color _surface    = Color(0xFFFFFFFF);
  static const Color _sage       = Color(0xFF7CA982);
  static const Color _sageLight  = Color(0xFFD4EAD7);
  static const Color _teal       = Color(0xFF4A9EAF);
  static const Color _tealLight  = Color(0xFFD6EEF3);
  static const Color _peach      = Color(0xFFE8926A);
  static const Color _lavender   = Color(0xFF9B8EC4);
  static const Color _lavLight   = Color(0xFFEAE6F5);
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
      'dateTime': DateTime(2026, 4, 4),
      'title': 'Feeling Strong Today',
      'content': 'Had a great day without any cravings. Went to support group and felt really supported.',
      'mood': '😊',
      'category': 'Positive',
    },
    {
      'date': 'April 3, 2026',
      'dateTime': DateTime(2026, 4, 3),
      'title': 'Managing Stress',
      'content': 'Work was challenging today but I handled it well. Used breathing techniques.',
      'mood': '😐',
      'category': 'Neutral',
    },
    {
      'date': 'April 2, 2026',
      'dateTime': DateTime(2026, 4, 2),
      'title': 'Milestone Celebration',
      'content': 'Reached 30 days sober! So proud of myself. Had a challenging moment at lunch but stayed strong.',
      'mood': '😊',
      'category': 'Positive',
    },
    {
      'date': 'April 1, 2026',
      'dateTime': DateTime(2026, 4, 1),
      'title': 'Struggled but Stayed Strong',
      'content': 'Had a moment of weakness but called my sponsor. We talked through it and I feel better.',
      'mood': '😔',
      'category': 'Challenging',
    },
    {
      'date': 'March 31, 2026',
      'dateTime': DateTime(2026, 3, 31),
      'title': 'Good Support System',
      'content': 'Spent time with my recovery group. Reminded me why I\'m doing this.',
      'mood': '😊',
      'category': 'Positive',
    },
  ];

  // Mood filter options
  static const List<Map<String, String>> _moodFilters = [
    {'label': 'All', 'emoji': '📊', 'value': 'All'},
    {'label': '😊', 'emoji': '😊', 'value': '😊'},
    {'label': '😐', 'emoji': '😐', 'value': '😐'},
    {'label': '😔', 'emoji': '😔', 'value': '😔'},
    {'label': '😢', 'emoji': '😢', 'value': '😢'},
  ];

  // Category filter options
  static const List<Map<String, String>> _categoryFilters = [
    {'label': 'All', 'value': 'All'},
    {'label': 'Positive', 'value': 'Positive'},
    {'label': 'Neutral', 'value': 'Neutral'},
    {'label': 'Challenging', 'value': 'Challenging'},
    {'label': 'Personal', 'value': 'Personal'},
  ];

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _searchController.addListener(_filterEntries);
  }

  @override
  void dispose() {
    _fabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredEntries {
    List<Map<String, dynamic>> filtered = List.from(_journalEntries);
    
    // Filter by mood
    if (_selectedMoodFilter != 'All') {
      filtered = filtered.where((e) => e['mood'] == _selectedMoodFilter).toList();
    }
    
    // Filter by category
    if (_selectedFilter != 'All') {
      filtered = filtered.where((e) => e['category'] == _selectedFilter).toList();
    }
    
    // Filter by date range
    if (_selectedDateRange != null) {
      filtered = filtered.where((e) {
        final entryDate = e['dateTime'] as DateTime;
        return entryDate.isAfter(_selectedDateRange!.start.subtract(const Duration(days: 1))) &&
               entryDate.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
      }).toList();
    }
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((e) {
        final title = e['title'].toLowerCase();
        final content = e['content'].toLowerCase();
        final date = e['date'].toLowerCase();
        final query = _searchQuery.toLowerCase();
        return title.contains(query) || content.contains(query) || date.contains(query);
      }).toList();
    }
    
    // Sort entries
    filtered.sort((a, b) {
      if (_sortBy == 'date') {
        final dateA = a['dateTime'] as DateTime;
        final dateB = b['dateTime'] as DateTime;
        return _sortDescending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
      } else {
        final titleA = a['title'] as String;
        final titleB = b['title'] as String;
        return _sortDescending ? titleB.compareTo(titleA) : titleA.compareTo(titleB);
      }
    });
    
    return filtered;
  }

  void _filterEntries() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  void _clearFilters() {
    setState(() {
      _selectedFilter = 'All';
      _selectedMoodFilter = 'All';
      _searchQuery = '';
      _searchController.clear();
      _selectedDateRange = null;
      _sortBy = 'date';
      _sortDescending = true;
    });
  }

  Future<void> _showDateRangePicker() async {
    final DateTime now = DateTime.now();
    
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7CA982),
              onPrimary: Colors.white,
              surface: Color(0xFFFFFFFF),
              onSurface: Color(0xFF2D3142),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
      });
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: _border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sort Options',
              style: TextStyle(
                color: _textDark,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.date_range_rounded,
                  color: _sortBy == 'date' ? _sage : _textLight),
              title: const Text('Sort by Date'),
              trailing: _sortBy == 'date'
                  ? IconButton(
                      icon: Icon(_sortDescending
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded),
                      onPressed: () {
                        setState(() {
                          _sortDescending = !_sortDescending;
                        });
                        Navigator.pop(ctx);
                      },
                    )
                  : null,
              onTap: () {
                setState(() {
                  _sortBy = 'date';
                });
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(Icons.title_rounded,
                  color: _sortBy == 'title' ? _sage : _textLight),
              title: const Text('Sort by Title'),
              trailing: _sortBy == 'title'
                  ? IconButton(
                      icon: Icon(_sortDescending
                          ? Icons.arrow_downward_rounded
                          : Icons.arrow_upward_rounded),
                      onPressed: () {
                        setState(() {
                          _sortDescending = !_sortDescending;
                        });
                        Navigator.pop(ctx);
                      },
                    )
                  : null,
              onTap: () {
                setState(() {
                  _sortBy = 'title';
                });
                Navigator.pop(ctx);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.5,
            maxChildSize: 0.9,
            builder: (_, controller) => Container(
              decoration: const BoxDecoration(
                color: _surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      decoration: BoxDecoration(
                        color: _border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      padding: const EdgeInsets.all(20),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Filter Entries',
                              style: TextStyle(
                                color: _textDark,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _clearFilters();
                                Navigator.pop(ctx);
                              },
                              child: const Text('Clear All'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        // Category Filter
                        const Text(
                          'Category',
                          style: TextStyle(
                            color: _textDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: _categoryFilters.map((filter) {
                            final isSelected = _selectedFilter == filter['value'];
                            return FilterChip(
                              label: Text(filter['label']!),
                              selected: isSelected,
                              onSelected: (selected) {
                                setSheetState(() {
                                  _selectedFilter = selected ? filter['value']! : 'All';
                                });
                              },
                              backgroundColor: _bg,
                              selectedColor: _sageLight,
                              checkmarkColor: _sage,
                              labelStyle: TextStyle(
                                color: isSelected ? _sage : _textMid,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        
                        // Mood Filter
                        const Text(
                          'Mood',
                          style: TextStyle(
                            color: _textDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: _moodFilters.map((filter) {
                            final isSelected = _selectedMoodFilter == filter['value'];
                            return FilterChip(
                              label: Text(filter['emoji']!),
                              selected: isSelected,
                              onSelected: (selected) {
                                setSheetState(() {
                                  _selectedMoodFilter = selected ? filter['value']! : 'All';
                                });
                              },
                              backgroundColor: _bg,
                              selectedColor: _sageLight,
                              labelStyle: const TextStyle(
                                fontSize: 18,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        
                        // Date Range Filter
                        const Text(
                          'Date Range',
                          style: TextStyle(
                            color: _textDark,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            await _showDateRangePicker();
                            setSheetState(() {});
                          },
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _bg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _border),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.date_range_rounded,
                                    color: _selectedDateRange != null ? _sage : _textLight),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    _selectedDateRange != null
                                        ? '${DateFormat('MMM d, yyyy').format(_selectedDateRange!.start)} - ${DateFormat('MMM d, yyyy').format(_selectedDateRange!.end)}'
                                        : 'Select date range',
                                    style: TextStyle(
                                      color: _selectedDateRange != null ? _textDark : _textLight,
                                    ),
                                  ),
                                ),
                                if (_selectedDateRange != null)
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded, size: 16),
                                    onPressed: () {
                                      setSheetState(() {
                                        _selectedDateRange = null;
                                      });
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Apply Button
                        ElevatedButton(
                          onPressed: () {
                            setState(() {});
                            Navigator.pop(ctx);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _sage,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Apply Filters', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Color _catColor(String cat)  => (_catStyle[cat]?['color']  as Color?) ?? _lavender;
  Color _catLight(String cat)  => (_catStyle[cat]?['light']  as Color?) ?? _lavLight;
  IconData _catIcon(String cat) => (_catStyle[cat]?['icon'] as IconData?) ?? Icons.label_rounded;

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
              color: Colors.black.withValues(alpha: 0.05),
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
                            _deleteEntry(entry);
                          }
                        },
                        itemBuilder: (_) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(children: [
                              Icon(Icons.edit_rounded, color: Color(0xFF4A9EAF), size: 18),
                              SizedBox(width: 8),
                              Text('Edit', style: TextStyle(color: Color(0xFF2D3142))),
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

  // FIXED: Proper void method for deletion
  void _deleteEntry(Map<String, dynamic> entry) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Entry'),
        content: Text('Are you sure you want to delete "${entry['title']}"?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _journalEntries.remove(entry);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Entry deleted'),
                  backgroundColor: Color(0xFFE8926A),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFE8926A))),
          ),
        ],
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
    String tempCategory = 'Personal';

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
            
            // Category selection
            const Text('Category',
                style: TextStyle(
                    color: _textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _categoryFilters.where((c) => c['value'] != 'All').map((category) {
                final isSelected = tempCategory == category['value'];
                return FilterChip(
                  label: Text(category['label']!),
                  selected: isSelected,
                  onSelected: (selected) {
                    setSheet(() => tempCategory = category['value']!);
                  },
                  backgroundColor: _bg,
                  selectedColor: _catLight(category['value']!),
                  labelStyle: TextStyle(
                    color: isSelected ? _catColor(category['value']!) : _textMid,
                  ),
                );
              }).toList(),
            ),
            
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
                  final now = DateTime.now();
                  setState(() {
                    _journalEntries.insert(0, {
                      'date': DateFormat('MMMM d, yyyy').format(now),
                      'dateTime': now,
                      'title': titleController.text,
                      'content': contentController.text,
                      'mood': tempMood,
                      'category': tempCategory,
                    });
                  });
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Journal entry saved! 🌿'),
                      backgroundColor: Color(0xFF7CA982),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
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
    String tempMood = entry['mood'];
    String tempCategory = entry['category'];

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
            const SizedBox(height: 16),
            
            // Category selection
            const Text('Category',
                style: TextStyle(
                    color: _textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _categoryFilters.where((c) => c['value'] != 'All').map((category) {
                final isSelected = tempCategory == category['value'];
                return FilterChip(
                  label: Text(category['label']!),
                  selected: isSelected,
                  onSelected: (selected) {
                    setSheet(() => tempCategory = category['value']!);
                  },
                  backgroundColor: _bg,
                  selectedColor: _catLight(category['value']!),
                  labelStyle: TextStyle(
                    color: isSelected ? _catColor(category['value']!) : _textMid,
                  ),
                );
              }).toList(),
            ),
            
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
                setState(() {
                  entry['title'] = titleController.text;
                  entry['content'] = contentController.text;
                  entry['mood'] = tempMood;
                  entry['category'] = tempCategory;
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Entry updated!'),
                    backgroundColor: Color(0xFF4A9EAF),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12))),
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

  // ── Stats Widget ──────────────────────────────────────────────────────────

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
      
  Widget _buildActiveFilterChip(String label, VoidCallback onDelete) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 12)),
        onDeleted: onDelete,
        deleteIcon: const Icon(Icons.close, size: 14),
        backgroundColor: _sageLight,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredEntries;
    final hasActiveFilters = _selectedFilter != 'All' ||
        _selectedMoodFilter != 'All' ||
        _searchQuery.isNotEmpty ||
        _selectedDateRange != null;

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
          // Sort button
          IconButton(
            icon: Icon(Icons.sort_rounded, color: _textMid),
            onPressed: _showSortOptions,
          ),
          // Filter button
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.filter_list_rounded, 
                    color: hasActiveFilters ? _sage : _textMid),
                if (hasActiveFilters)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _sage,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: _showFilterModal,
          ),
          // New entry button
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
          
          // ── Search Bar ───────────────────────────────────────────────────
          Container(
            color: _surface,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by title, content, or date...',
                prefixIcon: const Icon(Icons.search_rounded, color: _textLight),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded),
                        onPressed: () {
                          _searchController.clear();
                          _filterEntries();
                        },
                      )
                    : null,
                filled: true,
                fillColor: _bg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: _sage),
                ),
              ),
            ),
          ),
          
          // ── Active Filters Row ──────────────────────────────────────────
          if (hasActiveFilters)
            Container(
              color: _surface,
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text('Active filters: ',
                        style: TextStyle(color: _textLight, fontSize: 12)),
                    if (_selectedFilter != 'All')
                      _buildActiveFilterChip('Category: $_selectedFilter', () {
                        setState(() => _selectedFilter = 'All');
                      }),
                    if (_selectedMoodFilter != 'All')
                      _buildActiveFilterChip('Mood: $_selectedMoodFilter', () {
                        setState(() => _selectedMoodFilter = 'All');
                      }),
                    if (_selectedDateRange != null)
                      _buildActiveFilterChip(
                          'Date: ${DateFormat('MMM d').format(_selectedDateRange!.start)} - ${DateFormat('MMM d').format(_selectedDateRange!.end)}',
                          () {
                        setState(() => _selectedDateRange = null);
                      }),
                    if (_searchQuery.isNotEmpty)
                      _buildActiveFilterChip('Search: $_searchQuery', () {
                        _searchController.clear();
                        _filterEntries();
                      }),
                    TextButton(
                      onPressed: _clearFilters,
                      child: const Text('Clear All', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),
          
          Divider(height: 1, color: _border),

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
                        Text(
                          hasActiveFilters
                              ? 'Try adjusting your filters'
                              : 'Start journaling your recovery journey',
                          style: const TextStyle(
                              color: _textMid, fontSize: 13.5),
                        ),
                        const SizedBox(height: 24),
                        if (!hasActiveFilters)
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
}
