import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;

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

  // ── Type → accent mapping ─────────────────────────────────────────────────
  static const Map<String, Map<String, dynamic>> _typeConfig = {
    'Reminder':    {'color': Color(0xFF4A9EAF), 'light': Color(0xFFD6EEF3), 'icon': Icons.alarm_rounded},
    'Achievement': {'color': Color(0xFFF4C542), 'light': Color(0xFFFDF3CC), 'icon': Icons.emoji_events_rounded},
    'Appointment': {'color': Color(0xFF9B8EC4), 'light': Color(0xFFEAE6F5), 'icon': Icons.calendar_today_rounded},
    'Message':     {'color': Color(0xFF7CA982), 'light': Color(0xFFD4EAD7), 'icon': Icons.chat_rounded},
    'Community':   {'color': Color(0xFFE8926A), 'light': Color(0xFFFAE2D5), 'icon': Icons.people_rounded},
    'Tip':         {'color': Color(0xFF9B8EC4), 'light': Color(0xFFEAE6F5), 'icon': Icons.lightbulb_rounded},
  };

  final List<Map<String, dynamic>> _notifications = [
    {
      'type': 'Reminder',
      'title': 'Time for your morning medication',
      'message': 'Take Naltrexone 50mg',
      'time': '2 hours ago',
      'emoji': '💊',
      'read': false,
    },
    {
      'type': 'Achievement',
      'title': 'Congratulations!',
      'message': 'You\'ve completed 30 days sober!',
      'time': '1 day ago',
      'emoji': '🏆',
      'read': true,
    },
    {
      'type': 'Appointment',
      'title': 'Upcoming appointment reminder',
      'message': 'Session with Dr. Lisa in 2 hours',
      'time': '3 hours ago',
      'emoji': '📅',
      'read': true,
    },
    {
      'type': 'Message',
      'title': 'New message from your counsellor',
      'message': 'Check your chat for important updates',
      'time': '1 day ago',
      'emoji': '💬',
      'read': true,
    },
    {
      'type': 'Community',
      'title': 'New reply to your post',
      'message': 'James replied to your milestone post',
      'time': '2 days ago',
      'emoji': '👥',
      'read': true,
    },
    {
      'type': 'Tip',
      'title': 'Daily coping tip',
      'message': 'Try the 5-4-3-2-1 grounding technique today',
      'time': '3 days ago',
      'emoji': '💡',
      'read': true,
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

  int get _unreadCount => _notifications.where((n) => !(n['read'] as bool)).length;

  Color _typeColor(String type) =>
      (_typeConfig[type]?['color'] as Color?) ?? _lavender;
  Color _typeLight(String type) =>
      (_typeConfig[type]?['light'] as Color?) ?? _lavLight;
  IconData _typeIcon(String type) =>
      (_typeConfig[type]?['icon'] as IconData?) ?? Icons.notifications_rounded;

  // ── Mark all read ─────────────────────────────────────────────────────────

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n['read'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All notifications marked as read'),
        backgroundColor: _sage,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Notification Detail Sheet ─────────────────────────────────────────────

  void _showDetail(Map<String, dynamic> n) {
    final type  = n['type'] as String;
    final color = _typeColor(type);
    final light = _typeLight(type);

    // Mark as read
    setState(() => n['read'] = true);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                    color: _border, borderRadius: BorderRadius.circular(2)),
              ),
            ),

            // Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                  color: light, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Text(n['emoji'], style: const TextStyle(fontSize: 44)),
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
                        Icon(_typeIcon(type), color: Colors.white, size: 13),
                        const SizedBox(width: 5),
                        Text(type,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Text(n['title'],
                style: const TextStyle(
                    color: _textDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: _bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _border)),
              child: Text(n['message'],
                  style: const TextStyle(
                      color: _textMid, fontSize: 14.5, height: 1.55),
                  textAlign: TextAlign.center),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time_rounded,
                    color: _textLight, size: 13),
                const SizedBox(width: 5),
                Text(n['time'],
                    style: const TextStyle(
                        color: _textLight, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                setState(() => _notifications.remove(n));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Notification dismissed'),
                    backgroundColor: _teal,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Dismiss',
                  style:
                      TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  // ── Notification Card ─────────────────────────────────────────────────────

  Widget _buildNotificationCard(Map<String, dynamic> n) {
    final type    = n['type'] as String;
    final read    = n['read'] as bool;
    final color   = _typeColor(type);
    final light   = _typeLight(type);

    return GestureDetector(
      onTap: () => _showDetail(n),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          border: read
              ? Border.all(color: _border)
              : Border.all(color: color.withOpacity(0.4), width: 1.5),
          boxShadow: read
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          children: [
            // Left accent strip
            Container(
              width: 5,
              height: 80,
              decoration: BoxDecoration(
                color: read ? _border : color,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20)),
              ),
            ),
            const SizedBox(width: 14),

            // Emoji bubble
            Container(
              width: 46, height: 46,
              decoration: BoxDecoration(
                color: read ? _bg : light,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child:
                    Text(n['emoji'], style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(n['title'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _textDark,
                                fontSize: 13.5,
                                fontWeight: read
                                    ? FontWeight.w600
                                    : FontWeight.w800,
                              )),
                        ),
                        if (!read)
                          Container(
                            width: 8, height: 8,
                            margin: const EdgeInsets.only(left: 6),
                            decoration: BoxDecoration(
                                color: color, shape: BoxShape.circle),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(n['message'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: _textMid, fontSize: 12.5)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        // Type pill
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: read ? _bg : light,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_typeIcon(type),
                                  color: read ? _textLight : color,
                                  size: 11),
                              const SizedBox(width: 3),
                              Text(type,
                                  style: TextStyle(
                                      color: read ? _textLight : color,
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(n['time'],
                            style: const TextStyle(
                                color: _textLight, fontSize: 11)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final unread = _unreadCount;

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
        title: const Text('Notifications',
            style: TextStyle(
                color: _textDark,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        actions: [
          if (unread > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: _markAllRead,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                      color: _tealLight,
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('Mark all read',
                      style: TextStyle(
                          color: _teal,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
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

            // ── Stats Banner ─────────────────────────────────────────────
            Container(
              color: _surface,
              padding:
                  const EdgeInsets.fromLTRB(20, 14, 20, 14),
              child: Row(
                children: [
                  _statPill('${_notifications.length}', 'Total', _teal),
                  _dividerV(),
                  _statPill('$unread', 'Unread', _peach),
                  _dividerV(),
                  _statPill(
                      '${_notifications.length - unread}',
                      'Read',
                      _sage),
                ],
              ),
            ),
            Divider(height: 1, color: _border),

            // ── Notification List ────────────────────────────────────────
            Expanded(
              child: _notifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                                color: _tealLight,
                                shape: BoxShape.circle),
                            child: Icon(
                                Icons.notifications_none_rounded,
                                color: _teal,
                                size: 40),
                          ),
                          const SizedBox(height: 20),
                          const Text('No notifications',
                              style: TextStyle(
                                  color: _textDark,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          const Text(
                              'You\'re all caught up!',
                              style: TextStyle(
                                  color: _textMid, fontSize: 13.5)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding:
                          const EdgeInsets.fromLTRB(16, 16, 16, 40),
                      itemCount: _notifications.length,
                      itemBuilder: (_, i) =>
                          _buildNotificationCard(_notifications[i]),
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