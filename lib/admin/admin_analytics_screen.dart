import 'package:flutter/material.dart';
import 'admin_service.dart';
import 'admin_data_models.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> {
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: _textLight),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Analytics & Reports',
          style: TextStyle(
            color: _textLight,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: _loadAnalytics,
                child: const Tooltip(
                  message: 'Refresh',
                  child:
                      Icon(Icons.refresh_rounded, color: _accentBlue, size: 22),
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
                  // ── Key Metrics Grid ──────────────────────────────────────
                  const Text(
                    'Key Metrics',
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
                        'Total Sessions',
                        _analytics.totalSessions.toString(),
                        Icons.video_call_rounded,
                        _warningOrange,
                      ),
                      _metricCard(
                        'Active Counselors',
                        _analytics.activeCounselors.toString(),
                        Icons.psychology_rounded,
                        _accentGold,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── Recovery Stats ─────────────────────────────────────────
                  const Text(
                    'Recovery Statistics',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _largeStatCard(
                    'Average Days Sober',
                    _analytics.averageDaysSober.toStringAsFixed(1),
                    'days',
                    _successGreen,
                    Icons.trending_up_rounded,
                  ),
                  const SizedBox(height: 12),
                  _largeStatCard(
                    'Appointments Scheduled',
                    _analytics.appointmentsScheduled.toString(),
                    'total',
                    _accentBlue,
                    Icons.calendar_today_rounded,
                  ),
                  const SizedBox(height: 24),

                  // ── Growth Section ─────────────────────────────────────────
                  const Text(
                    'Growth & Engagement',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _statRow(
                    'New Registrations (30 days)',
                    _analytics.newRegistrations.toString(),
                    _warningOrange,
                    Icons.person_add_rounded,
                  ),
                  const SizedBox(height: 10),
                  _statRow(
                    'App Rating',
                    _analytics.appRating.toStringAsFixed(1),
                    _accentGold,
                    Icons.star_rounded,
                  ),
                  const SizedBox(height: 24),

                  // ── Engagement Breakdown ────────────────────────────────────
                  const Text(
                    'User Engagement',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _engagementBreakdown(),
                  const SizedBox(height: 24),

                  // ── Recommendations ────────────────────────────────────────
                  const Text(
                    'Recommendations',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _recommendationCard(
                    'Increase Counselor Availability',
                    'Current counselor load is increasing. Consider adding more counselors.',
                    Icons.psychology_rounded,
                    _warningOrange,
                  ),
                  const SizedBox(height: 10),
                  _recommendationCard(
                    'Promote Success Stories',
                    'User engagement is high. Share more success stories to maintain momentum.',
                    Icons.star_rounded,
                    _successGreen,
                  ),
                  const SizedBox(height: 10),
                  _recommendationCard(
                    'Resource Updates',
                    'Review and update resources regularly to keep content fresh and relevant.',
                    Icons.library_books_rounded,
                    _accentBlue,
                  ),
                  const SizedBox(height: 24),

                  // ── Data Timestamp ─────────────────────────────────────────
                  Center(
                    child: Text(
                      'Last updated: ${_analytics.generatedAt.toString().split('.')[0]}',
                      style: const TextStyle(
                        color: _textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _largeStatCard(
      String label, String value, String suffix, Color color, IconData icon) {
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
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value,
                      style: TextStyle(
                        color: color,
                        fontSize: 28,
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 32),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statRow(String label, String value, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _surface, width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(icon, color: color, size: 20),
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
      ),
    );
  }

  Widget _engagementBreakdown() {
    final activePercent = (_analytics.activeUsers / _analytics.totalUsers * 100)
        .toStringAsFixed(0);
    final inactivePercent =
        (100 - double.parse(activePercent)).toStringAsFixed(0);

    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _surface, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Active vs Inactive Users',
            style: TextStyle(
              color: _textLight,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                Expanded(
                  flex: int.parse(activePercent),
                  child: Container(
                    height: 20,
                    color: _successGreen,
                  ),
                ),
                Expanded(
                  flex: int.parse(inactivePercent),
                  child: Container(
                    height: 20,
                    color: _surface,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _successGreen,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Active: $activePercent%',
                    style: const TextStyle(
                      color: _textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _surface,
                      borderRadius: BorderRadius.circular(2),
                      border: Border.all(color: _textMuted, width: 1),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Inactive: $inactivePercent%',
                    style: const TextStyle(
                      color: _textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _recommendationCard(
      String title, String description, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _surface, width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _textLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: _textMuted,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
