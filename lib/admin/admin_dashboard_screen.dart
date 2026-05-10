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
                  // ── Stats Grid ────────────────────────────────────────────
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _statCard('Total Users', _analytics.totalUsers.toString(),
                          Icons.people_rounded, _accentBlue),
                      _statCard(
                          'Active Users',
                          _analytics.activeUsers.toString(),
                          Icons.check_circle_rounded,
                          _successGreen),
                      _statCard(
                          'Counselors',
                          _analytics.activeCounselors.toString(),
                          Icons.psychology_rounded,
                          _warningOrange),
                      _statCard(
                          'App Rating',
                          _analytics.appRating.toStringAsFixed(1),
                          Icons.star_rounded,
                          _accentGold),
                      _statCard(
                          'Total Sessions',
                          _analytics.totalSessions.toString(),
                          Icons.video_call_rounded,
                          _accentBlue),
                      _statCard(
                          'New Registrations',
                          _analytics.newRegistrations.toString(),
                          Icons.person_add_rounded,
                          _successGreen),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Quick Stats ───────────────────────────────────────────
                  const Text(
                    'Platform Overview',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _quickStatsCard(
                      'Avg Days Sober',
                      _analytics.averageDaysSober.toStringAsFixed(1),
                      'days',
                      _accentBlue),
                  const SizedBox(height: 10),
                  _quickStatsCard(
                      'Appointments',
                      _analytics.appointmentsScheduled.toString(),
                      'scheduled',
                      _successGreen),
                  const SizedBox(height: 24),

                  // ── Management Options ────────────────────────────────────
                  const Text(
                    'Management',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _managementButton(
                    'User Management',
                    'View, manage, and suspend users',
                    Icons.people_alt_rounded,
                    _accentBlue,
                    () => Navigator.pushNamed(context, '/admin-users'),
                  ),
                  const SizedBox(height: 10),
                  _managementButton(
                    'Counselor Management',
                    'Verify and manage counselor profiles',
                    Icons.person_outline_rounded,
                    _warningOrange,
                    () => Navigator.pushNamed(context, '/admin-counselors'),
                  ),
                  const SizedBox(height: 10),
                  _managementButton(
                    'Resources Management',
                    'Create, edit, and publish resources',
                    Icons.library_books_rounded,
                    _successGreen,
                    () => Navigator.pushNamed(context, '/admin-resources'),
                  ),
                  const SizedBox(height: 10),
                  _managementButton(
                    'Analytics & Reports',
                    'View detailed analytics and reports',
                    Icons.bar_chart_rounded,
                    _accentGold,
                    () => Navigator.pushNamed(context, '/admin-analytics'),
                  ),
                  const SizedBox(height: 10),
                  _managementButton(
                    'Support Tickets',
                    'Manage user support tickets',
                    Icons.support_agent_rounded,
                    _accentBlue,
                    () => Navigator.pushNamed(context, '/admin-support'),
                  ),
                  const SizedBox(height: 24),

                  // ── Admin Info ────────────────────────────────────────────
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
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _accentGold.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.admin_panel_settings_rounded,
                                color: _accentGold, size: 24),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.adminUser.fullName,
                                style: const TextStyle(
                                  color: _textLight,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                '${widget.adminUser.role} • ${widget.adminUser.email}',
                                style: const TextStyle(
                                  color: _textMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
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
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: _textLight,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickStatsCard(
      String label, String value, String suffix, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _surface, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: _textMuted,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: ' $suffix',
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
          Icon(Icons.trending_up_rounded, color: color, size: 32),
        ],
      ),
    );
  }

  Widget _managementButton(String title, String description, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _surface, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
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
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: const TextStyle(
                      color: _textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: _textMuted, size: 16),
          ],
        ),
      ),
    );
  }
}
