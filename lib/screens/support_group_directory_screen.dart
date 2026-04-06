import 'package:flutter/material.dart';

class SupportGroupDirectoryScreen extends StatefulWidget {
  const SupportGroupDirectoryScreen({Key? key}) : super(key: key);

  @override
  State<SupportGroupDirectoryScreen> createState() =>
      _SupportGroupDirectoryScreenState();
}

class _SupportGroupDirectoryScreenState
    extends State<SupportGroupDirectoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double>   _fadeAnim;
  String _selectedFilter = 'All';

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

  // Cycling accent pairs for cards
  static const List<List<Color>> _accentCycle = [
    [Color(0xFF4A9EAF), Color(0xFFD6EEF3)],
    [Color(0xFF7CA982), Color(0xFFD4EAD7)],
    [Color(0xFF9B8EC4), Color(0xFFEAE6F5)],
    [Color(0xFFE8926A), Color(0xFFFAE2D5)],
    [Color(0xFFF4C542), Color(0xFFFDF3CC)],
  ];

  final List<Map<String, dynamic>> _supportGroups = [
    {
      'name': 'Narcotics Anonymous',
      'type': 'NA Meetings',
      'time': 'Mon, Wed, Fri · 7:00 PM',
      'location': 'Community Center, Main St',
      'distance': '2.3 km',
      'members': 156,
      'rating': 4.8,
      'format': 'In-Person',
      'emoji': '🤝',
    },
    {
      'name': 'Alcoholics Anonymous Downtown',
      'type': 'AA Meetings',
      'time': 'Daily · 6:00 PM',
      'location': 'Church Hall, 5th Ave',
      'distance': '1.5 km',
      'members': 234,
      'rating': 4.9,
      'format': 'In-Person',
      'emoji': '🏛️',
    },
    {
      'name': 'Recovery Online Support',
      'type': 'Online Support',
      'time': 'Daily · 8:00 PM',
      'location': 'Zoom Meeting',
      'distance': 'Online',
      'members': 89,
      'rating': 4.6,
      'format': 'Online',
      'emoji': '💻',
    },
    {
      'name': 'SMART Recovery Group',
      'type': 'SMART Recovery',
      'time': 'Tue, Thu · 6:30 PM',
      'location': 'Library Meeting Room',
      'distance': '3.1 km',
      'members': 45,
      'rating': 4.7,
      'format': 'In-Person',
      'emoji': '📚',
    },
    {
      'name': "Women's Recovery Circle",
      'type': 'Women Only',
      'time': 'Saturday · 10:00 AM',
      'location': 'Wellness Center',
      'distance': '4.2 km',
      'members': 67,
      'rating': 4.9,
      'format': 'In-Person',
      'emoji': '🌸',
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

  List<Map<String, dynamic>> get _filtered {
    if (_selectedFilter == 'All') return _supportGroups;
    return _supportGroups
        .where((g) => g['format'] == _selectedFilter)
        .toList();
  }

  // ── Group Detail Sheet ────────────────────────────────────────────────────

  void _showGroupDetail(Map<String, dynamic> group, int index) {
    final accent = _accentCycle[index % _accentCycle.length][0];
    final light  = _accentCycle[index % _accentCycle.length][1];
    final isOnline = group['format'] == 'Online';

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
                    borderRadius: BorderRadius.circular(24)),
                child: Column(
                  children: [
                    Text(group['emoji'],
                        style: const TextStyle(fontSize: 52)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _formatBadge(group['format'] as String,
                            accent, light),
                        const SizedBox(width: 8),
                        _ratingBadge(group['rating'] as double),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Name & type
              Text(group['name'],
                  style: const TextStyle(
                      color: _textDark,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3)),
              const SizedBox(height: 5),
              Row(children: [
                Icon(Icons.group_rounded, color: accent, size: 14),
                const SizedBox(width: 5),
                Text(group['type'],
                    style: TextStyle(
                        color: accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 18),

              // Detail rows
              _detailCard([
                _detailRow(Icons.access_time_rounded, 'Schedule',
                    group['time'], accent, light),
                _detailRow(
                    isOnline
                        ? Icons.video_call_rounded
                        : Icons.location_on_rounded,
                    'Location',
                    group['location'],
                    accent,
                    light),
                _detailRow(
                    isOnline
                        ? Icons.wifi_rounded
                        : Icons.near_me_rounded,
                    'Distance',
                    group['distance'],
                    accent,
                    light),
                _detailRow(Icons.people_rounded, 'Members',
                    '${group['members']} members', accent, light,
                    isLast: true),
              ]),
              const SizedBox(height: 14),

              // Description
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: _bg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _border)),
                child: const Text(
                  'A supportive community dedicated to recovery and mutual support. Open to all individuals seeking help with their recovery journey.',
                  style: TextStyle(
                      color: _textMid, fontSize: 14, height: 1.65),
                ),
              ),
              const SizedBox(height: 20),

              // Join button
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Joined ${group['name']}! See you there 🌿'),
                      backgroundColor: accent,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                icon: const Icon(Icons.group_add_rounded),
                label: const Text('Join This Group',
                    style: TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
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

  Widget _detailCard(List<Widget> children) => Container(
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _border),
        ),
        child: Column(children: children),
      );

  Widget _detailRow(IconData icon, String label, String value,
      Color accent, Color light,
      {bool isLast = false}) =>
      Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: light,
                      borderRadius: BorderRadius.circular(9)),
                  child: Icon(icon, color: accent, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              color: _textLight, fontSize: 11)),
                      Text(value,
                          style: const TextStyle(
                              color: _textDark,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(height: 1, color: _border, indent: 14, endIndent: 14),
        ],
      );

  // ── Group Card ────────────────────────────────────────────────────────────

  Widget _buildGroupCard(Map<String, dynamic> group, int index) {
    final accent = _accentCycle[index % _accentCycle.length][0];
    final light  = _accentCycle[index % _accentCycle.length][1];

    return GestureDetector(
      onTap: () => _showGroupDetail(group, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(22),
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
            // Top strip
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: accent,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(22)),
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
                      // Emoji bubble
                      Container(
                        width: 50, height: 50,
                        decoration: BoxDecoration(
                            color: light,
                            borderRadius: BorderRadius.circular(14)),
                        child: Center(
                          child: Text(group['emoji'],
                              style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Name & type
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(group['name'],
                                style: const TextStyle(
                                    color: _textDark,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3)),
                            const SizedBox(height: 4),
                            Row(children: [
                              Icon(Icons.group_rounded,
                                  color: accent, size: 12),
                              const SizedBox(width: 4),
                              Text(group['type'],
                                  style: TextStyle(
                                      color: accent,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600)),
                            ]),
                          ],
                        ),
                      ),

                      // Format badge
                      _formatBadge(group['format'] as String, accent, light),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Time & location row
                  Row(children: [
                    Icon(Icons.access_time_rounded,
                        color: _textLight, size: 13),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(group['time'],
                          style: const TextStyle(
                              color: _textMid, fontSize: 12.5)),
                    ),
                  ]),
                  const SizedBox(height: 5),
                  Row(children: [
                    Icon(
                      group['format'] == 'Online'
                          ? Icons.video_call_rounded
                          : Icons.location_on_rounded,
                      color: _textLight,
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      group['format'] == 'Online'
                          ? 'Online · ${group['location']}'
                          : '${group['distance']} · ${group['location']}',
                      style: const TextStyle(
                          color: _textMid, fontSize: 12.5),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]),
                  const SizedBox(height: 12),

                  // Footer
                  Row(children: [
                    _ratingBadge(group['rating'] as double),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                          color: _bg,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _border)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.people_rounded,
                              color: _textLight, size: 12),
                          const SizedBox(width: 4),
                          Text('${group['members']}',
                              style: const TextStyle(
                                  color: _textMid,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(children: [
                      Text('Details',
                          style: TextStyle(
                              color: accent,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(width: 3),
                      Icon(Icons.arrow_forward_rounded,
                          color: accent, size: 14),
                    ]),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shared badge widgets ──────────────────────────────────────────────────

  Widget _formatBadge(String format, Color accent, Color light) {
    final isOnline = format == 'Online';
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isOnline ? _lavLight : _sageLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.wifi_rounded : Icons.place_rounded,
            color: isOnline ? _lavender : _sage,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(format,
              style: TextStyle(
                  color: isOnline ? _lavender : _sage,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _ratingBadge(double rating) => Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
            color: _goldLight, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, color: _gold, size: 13),
            const SizedBox(width: 4),
            Text('$rating',
                style: TextStyle(
                    color: _gold,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700)),
          ],
        ),
      );

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final inPersonCount =
        _supportGroups.where((g) => g['format'] == 'In-Person').length;
    final onlineCount =
        _supportGroups.where((g) => g['format'] == 'Online').length;

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
        title: const Text('Support Groups',
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
                  _statPill('${_supportGroups.length}', 'Total', _teal),
                  _dividerV(),
                  _statPill('$inPersonCount', 'In-Person', _sage),
                  _dividerV(),
                  _statPill('$onlineCount', 'Online', _lavender),
                  _dividerV(),
                  _statPill(
                      '${_supportGroups.map((g) => g['members'] as int).reduce((a, b) => a + b)}',
                      'Members',
                      _peach),
                ],
              ),
            ),
            Divider(height: 1, color: _border),

            // ── Filter Row ───────────────────────────────────────────────
            Container(
              color: _surface,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _filterChip('All', Icons.apps_rounded, _teal),
                    const SizedBox(width: 8),
                    _filterChip('In-Person',
                        Icons.place_rounded, _sage),
                    const SizedBox(width: 8),
                    _filterChip('Online',
                        Icons.video_call_rounded, _lavender),
                  ],
                ),
              ),
            ),

            // ── Group List ───────────────────────────────────────────────
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
                            child: Icon(Icons.group_rounded,
                                color: _teal, size: 40),
                          ),
                          const SizedBox(height: 20),
                          const Text('No groups found',
                              style: TextStyle(
                                  color: _textDark,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          const Text('Try a different filter',
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
                          _buildGroupCard(filtered[i], i),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, IconData icon, Color accent) {
    final selected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? accent : _surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? accent : _border),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: accent.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3))
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: selected ? Colors.white : _textMid, size: 14),
            const SizedBox(width: 5),
            Text(label,
                style: TextStyle(
                    color: selected ? Colors.white : _textMid,
                    fontSize: 12.5,
                    fontWeight: selected
                        ? FontWeight.w700
                        : FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _statPill(String value, String label, Color color) =>
      Expanded(
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
                style:
                    const TextStyle(color: _textLight, fontSize: 11)),
          ],
        ),
      );

  Widget _dividerV() =>
      Container(width: 1, height: 32, color: _border);
}