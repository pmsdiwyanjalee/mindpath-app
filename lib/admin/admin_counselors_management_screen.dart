import 'package:flutter/material.dart';
import 'admin_service.dart';
import 'admin_data_models.dart';

class AdminCounselorsManagementScreen extends StatefulWidget {
  const AdminCounselorsManagementScreen({super.key});

  @override
  State<AdminCounselorsManagementScreen> createState() =>
      _AdminCounselorsManagementScreenState();
}

class _AdminCounselorsManagementScreenState
    extends State<AdminCounselorsManagementScreen>
    with TickerProviderStateMixin {
  final AdminService _adminService = AdminService();
  late List<Counselor> _counselors;
  bool _isLoading = true;
  late TabController _tabController;
  String _searchQuery = '';

  // Color Palette
  static const Color _darkBg = Color(0xFF1A1A2E);
  static const Color _cardBg = Color(0xFF16213E);
  static const Color _surface = Color(0xFF0F3460);
  static const Color _accentBlue = Color(0xFF00A3FF);
  static const Color _accentGold = Color(0xFFFFB700);
  static const Color _textLight = Color(0xFFEAEAEA);
  static const Color _textMuted = Color(0xFF9CA3AF);
  static const Color _successGreen = Color(0xFF2ED573);
  static const Color _errorRed = Color(0xFFFF4757);
  static const Color _warningOrange = Color(0xFFF0932B);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCounselors();
  }

  Future<void> _loadCounselors() async {
    _counselors = await _adminService.getAllCounselors();
    setState(() => _isLoading = false);
  }

  List<Counselor> get _filteredCounselors {
    return _counselors.where((c) {
      final query = _searchQuery.toLowerCase();
      return c.fullName.toLowerCase().contains(query) ||
          c.email.toLowerCase().contains(query) ||
          c.specialization.toLowerCase().contains(query);
    }).toList();
  }

  List<Counselor> get _verifiedCounselors =>
      _filteredCounselors.where((c) => c.isVerified).toList();
  List<Counselor> get _pendingCounselors =>
      _filteredCounselors.where((c) => !c.isVerified).toList();

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
          'Counselor Management',
          style: TextStyle(
            color: _textLight,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_accentBlue),
              ),
            )
          : Column(
              children: [
                // ── Search Bar ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(color: _textLight),
                    decoration: InputDecoration(
                      hintText: 'Search counselors...',
                      hintStyle: const TextStyle(color: _textMuted),
                      prefixIcon: const Icon(Icons.search_rounded,
                          color: _accentBlue, size: 20),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? GestureDetector(
                              onTap: () => setState(() => _searchQuery = ''),
                              child: const Icon(Icons.clear_rounded,
                                  color: _textMuted, size: 20),
                            )
                          : null,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: _surface, width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: _accentBlue, width: 2),
                      ),
                      filled: true,
                      fillColor: _cardBg,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),

                // ── Tabs ───────────────────────────────────────────────────
                Container(
                  color: _surface,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: _accentBlue,
                    unselectedLabelColor: _textMuted,
                    indicatorColor: _accentBlue,
                    tabs: [
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Verified'),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _successGreen.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _verifiedCounselors.length.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Tab(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Pending'),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _warningOrange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _pendingCounselors.length.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Counselor List ─────────────────────────────────────────
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildCounselorList(_verifiedCounselors),
                      _buildCounselorList(_pendingCounselors),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildCounselorList(List<Counselor> counselors) {
    if (counselors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline_rounded, color: _textMuted, size: 48),
            const SizedBox(height: 12),
            Text(
              'No counselors found',
              style: TextStyle(
                color: _textMuted,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: counselors.length,
      itemBuilder: (context, index) {
        final counselor = counselors[index];
        return _counselorCard(counselor);
      },
    );
  }

  Widget _counselorCard(Counselor counselor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _surface, width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ─────────────────────────────────────────────
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [_warningOrange, _accentGold],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.psychology_rounded,
                          color: _darkBg,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  counselor.fullName,
                                  style: const TextStyle(
                                    color: _textLight,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (counselor.isVerified)
                                Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _successGreen.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.verified_rounded,
                                          color: _successGreen, size: 12),
                                      SizedBox(width: 4),
                                      Text(
                                        'Verified',
                                        style: TextStyle(
                                          color: _successGreen,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            counselor.specialization,
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
                const SizedBox(height: 12),

                // ── Stats ───────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _statChip(
                          'Rating', counselor.rating.toString(), _accentBlue),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statChip('Clients',
                          counselor.clientCount.toString(), _successGreen),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statChip('Sessions',
                          counselor.totalSessions.toString(), _warningOrange),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Actions ─────────────────────────────────────────────────
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: _surface, width: 1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _viewCounselorDetails(counselor),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.visibility_rounded,
                              color: _accentBlue, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'View Profile',
                            style: TextStyle(
                              color: _accentBlue,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 24,
                  color: _surface,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _handleCounselorAction(counselor),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            counselor.isVerified
                                ? Icons.block_rounded
                                : Icons.check_circle_rounded,
                            color: counselor.isVerified
                                ? _errorRed
                                : _successGreen,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            counselor.isVerified ? 'Deactivate' : 'Verify',
                            style: TextStyle(
                              color: counselor.isVerified
                                  ? _errorRed
                                  : _successGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              color: _textMuted,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _viewCounselorDetails(Counselor counselor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: DraggableScrollableSheet(
          initialChildSize: 1,
          minChildSize: 0.5,
          maxChildSize: 1,
          builder: (_, controller) => ListView(
            controller: controller,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                counselor.fullName,
                style: const TextStyle(
                  color: _textLight,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 20),
              _detailRow('Email', counselor.email),
              _detailRow('Specialization', counselor.specialization),
              _detailRow('Qualification', counselor.qualification),
              _detailRow('Rating', counselor.rating.toString()),
              _detailRow('Clients', counselor.clientCount.toString()),
              _detailRow('Total Sessions', counselor.totalSessions.toString()),
              _detailRow('Contact', counselor.contactNumber),
              _detailRow('Status', counselor.isActive ? 'Active' : 'Inactive'),
              _detailRow('Verified', counselor.isVerified ? 'Yes' : 'No'),
              _detailRow('Joined', counselor.joinDate.toString().split(' ')[0]),
              const SizedBox(height: 20),
              if (!counselor.isVerified)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _successGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _successGreen, width: 1),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      _handleCounselorAction(counselor);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_user_rounded,
                            color: _successGreen, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Verify Counselor',
                          style: TextStyle(
                            color: _successGreen,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: _textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: _textLight,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }

  void _handleCounselorAction(Counselor counselor) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _cardBg,
        title: Text(
          counselor.isVerified ? 'Deactivate Counselor?' : 'Verify Counselor?',
          style: const TextStyle(color: _textLight),
        ),
        content: Text(
          counselor.isVerified
              ? 'Are you sure you want to deactivate ${counselor.fullName}?'
              : 'Are you sure you want to verify ${counselor.fullName}?',
          style: const TextStyle(color: _textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _textMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              if (!counselor.isVerified) {
                await _adminService.verifyCounselor(counselor.id);
              } else {
                await _adminService.deactivateCounselor(counselor.id);
              }
              _loadCounselors();
            },
            child: Text(
              counselor.isVerified ? 'Deactivate' : 'Verify',
              style: TextStyle(
                color: counselor.isVerified ? _errorRed : _successGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
