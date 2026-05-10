import 'package:flutter/material.dart';
import 'admin_service.dart';
import 'admin_data_models.dart';

class AdminDashboardScreen extends StatefulWidget {
  final AdminUser adminUser;

  const AdminDashboardScreen({super.key, required this.adminUser});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final AdminService _adminService = AdminService();
  late Analytics _analytics;
  bool _isLoading = true;

  // Color Palette
  static const Color _darkBg = Color(0xFF1A1A2E);
  static const Color _cardBg = Color(0xFF16213E);
  static const Color _surface = Color(0xFF0F3460);
  static const Color _accentBlue = Color(0xFF00A3FF);
  static const Color _accentGold = Color(0xFFFFB700);
  static const Color _textLight = Color(0xFFEAEAEA);
  static const Color _textMuted = Color(0xFF9CA3AF);
  static const Color _successGreen = Color(0xFF2ED573);
  static const Color _warningOrange = Color(0xFFF0932B);

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    _analytics = await _adminService.getAnalytics();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _darkBg,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _accentGold,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.admin_panel_settings_rounded,
                    color: _darkBg, size: 22),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Admin Dashboard',
                  style: TextStyle(
                    color: _textLight,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Welcome, ${widget.adminUser.fullName}',
                  style: const TextStyle(
                    color: _textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Tooltip(
                  message: 'Logout',
                  child:
                      Icon(Icons.logout_rounded, color: _textMuted, size: 22),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_accentBlue),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Welcome Header ────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_surface, _accentBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.admin_panel_settings_rounded,
                                color: _accentGold, size: 28),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back, ${widget.adminUser.fullName}',
                                    style: const TextStyle(
                                      color: _textLight,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Role: ${widget.adminUser.role.replaceAll('_', ' ').toUpperCase()}',
                                    style: const TextStyle(
                                      color: _textMuted,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Manage users, counselors, resources, and monitor platform analytics.',
                          style: TextStyle(
                            color: _textMuted,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Key Metrics ───────────────────────────────────────────
                  const Text(
                    'Platform Overview',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _metricCard(
                        'Total Users',
                        _analytics.totalUsers.toString(),
                        Icons.people_rounded,
                        _accentBlue,
                      ),
                      _metricCard(
                        'Active Users',
                        _analytics.activeUsers.toString(),
                        Icons.check_circle_rounded,
                        _successGreen,
                      ),
                      _metricCard(
                        'Active Counselors',
                        _analytics.activeCounselors.toString(),
                        Icons.psychology_rounded,
                        _warningOrange,
                      ),
                      _metricCard(
                        'Total Sessions',
                        _analytics.totalSessions.toString(),
                        Icons.video_call_rounded,
                        _accentGold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Management Actions ─────────────────────────────────────
                  const Text(
                    'Management Actions',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _actionCard(
                        'User Management',
                        'Manage user accounts, suspend/activate users',
                        Icons.people_alt_rounded,
                        _accentBlue,
                        () => Navigator.pushNamed(context, '/admin-users'),
                      ),
                      _actionCard(
                        'Counselor Verification',
                        'Review and verify counselor applications',
                        Icons.verified_user_rounded,
                        _successGreen,
                        () => Navigator.pushNamed(context, '/admin-counselors'),
                      ),
                      _actionCard(
                        'Resource Management',
                        'Publish and manage recovery resources',
                        Icons.library_books_rounded,
                        _warningOrange,
                        () => Navigator.pushNamed(context, '/admin-resources'),
                      ),
                      _actionCard(
                        'Support Tickets',
                        'Handle user support requests',
                        Icons.support_agent_rounded,
                        _accentGold,
                        () => Navigator.pushNamed(context, '/admin-support'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Analytics & Reports ────────────────────────────────────
                  const Text(
                    'Analytics & Reports',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _actionCard(
                    'View Detailed Analytics',
                    'Comprehensive platform metrics and insights',
                    Icons.analytics_rounded,
                    _accentBlue,
                    () => Navigator.pushNamed(context, '/admin-analytics'),
                    isFullWidth: true,
                  ),
                  const SizedBox(height: 24),

                  // ── Quick Stats ───────────────────────────────────────────
                  const Text(
                    'Quick Stats',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _surface, width: 1),
                    ),
                    child: Column(
                      children: [
                        _quickStatRow(
                          'New Registrations (30 days)',
                          _analytics.newRegistrations.toString(),
                          Icons.person_add_rounded,
                          _successGreen,
                        ),
                        const Divider(color: Color(0xFF2A3E5A), height: 16),
                        _quickStatRow(
                          'App Rating',
                          _analytics.appRating.toStringAsFixed(1),
                          Icons.star_rounded,
                          _accentGold,
                        ),
                        const Divider(color: Color(0xFF2A3E5A), height: 16),
                        _quickStatRow(
                          'Avg Days Sober',
                          _analytics.averageDaysSober.toStringAsFixed(1),
                          Icons.trending_up_rounded,
                          _accentBlue,
                        ),
                        const Divider(color: Color(0xFF2A3E5A), height: 16),
                        _quickStatRow(
                          'Scheduled Appointments',
                          _analytics.appointmentsScheduled.toString(),
                          Icons.calendar_today_rounded,
                          _warningOrange,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── System Status ──────────────────────────────────────────
                  const Text(
                    'System Status',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _surface, width: 1),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _successGreen,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'All systems operational',
                            style: TextStyle(
                              color: _textLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          'Last updated: ${DateTime.now().toString().split('.')[0]}',
                          style: const TextStyle(
                            color: _textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _metricCard(String label, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _surface, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 20),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionCard(String title, String subtitle, IconData icon, Color color,
      VoidCallback onTap,
      {bool isFullWidth = false}) {
    final card = Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _surface, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(icon, color: color, size: 24),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: _textLight,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: _textMuted,
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: _textMuted, size: 16),
              ],
            ),
          ),
        ),
      ),
    );

    if (isFullWidth) {
      return card;
    }

    return card;
  }

  Widget _quickStatRow(String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Icon(icon, color: color, size: 16),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: _textLight,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
