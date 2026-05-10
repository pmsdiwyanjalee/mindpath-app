import 'package:flutter/material.dart';
import 'admin_service.dart';
import 'admin_data_models.dart';

class AdminResourcesManagementScreen extends StatefulWidget {
  const AdminResourcesManagementScreen({super.key});

  @override
  State<AdminResourcesManagementScreen> createState() =>
      _AdminResourcesManagementScreenState();
}

class _AdminResourcesManagementScreenState
    extends State<AdminResourcesManagementScreen>
    with TickerProviderStateMixin {
  final AdminService _adminService = AdminService();
  late List<Resource> _resources;
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
    _loadResources();
  }

  Future<void> _loadResources() async {
    _resources = await _adminService.getAllResources();
    setState(() => _isLoading = false);
  }

  List<Resource> get _filteredResources {
    return _resources.where((r) {
      final query = _searchQuery.toLowerCase();
      return r.title.toLowerCase().contains(query) ||
          r.description.toLowerCase().contains(query) ||
          r.source.toLowerCase().contains(query);
    }).toList();
  }

  List<Resource> get _publishedResources =>
      _filteredResources.where((r) => r.isPublished).toList();
  List<Resource> get _draftResources =>
      _filteredResources.where((r) => !r.isPublished).toList();

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
          'Resources Management',
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
                onTap: _showCreateResourceDialog,
                child: const Tooltip(
                  message: 'Create New Resource',
                  child: Icon(Icons.add_circle_outline_rounded,
                      color: _accentBlue, size: 26),
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
          : Column(
              children: [
                // ── Search Bar ────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) => setState(() => _searchQuery = value),
                    style: const TextStyle(color: _textLight),
                    decoration: InputDecoration(
                      hintText: 'Search resources...',
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
                            const Text('Published'),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _successGreen.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _publishedResources.length.toString(),
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
                            const Text('Draft'),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _warningOrange.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _draftResources.length.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Resource List ──────────────────────────────────────────
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildResourceList(_publishedResources),
                      _buildResourceList(_draftResources),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildResourceList(List<Resource> resources) {
    if (resources.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books_rounded, color: _textMuted, size: 48),
            const SizedBox(height: 12),
            Text(
              'No resources found',
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
      itemCount: resources.length,
      itemBuilder: (context, index) {
        final resource = resources[index];
        return _resourceCard(resource);
      },
    );
  }

  Widget _resourceCard(Resource resource) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: _accentGold.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.article_rounded,
                          color: _accentGold,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            resource.title,
                            style: const TextStyle(
                              color: _textLight,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _accentBlue.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  resource.type.toUpperCase(),
                                  style: const TextStyle(
                                    color: _accentBlue,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: resource.isPublished
                                      ? _successGreen.withValues(alpha: 0.2)
                                      : _warningOrange.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  resource.isPublished ? 'PUBLISHED' : 'DRAFT',
                                  style: TextStyle(
                                    color: resource.isPublished
                                        ? _successGreen
                                        : _warningOrange,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ── Source ─────────────────────────────────────────────
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: _accentBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_user_rounded,
                          color: _accentBlue, size: 13),
                      const SizedBox(width: 6),
                      Text(
                        resource.source,
                        style: const TextStyle(
                          color: _accentBlue,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // ── Stats ───────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(
                      child: _statChip('Views', resource.viewCount.toString(),
                          _successGreen),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _statChip(
                          'Rating', resource.rating.toString(), _accentGold),
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
                    onTap: () => _viewResourceDetails(resource),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.visibility_rounded,
                              color: _accentBlue, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'View',
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
                    onTap: () => _handleResourceAction(resource),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            resource.isPublished
                                ? Icons.unpublished_rounded
                                : Icons.publish_rounded,
                            color: resource.isPublished
                                ? _errorRed
                                : _successGreen,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            resource.isPublished ? 'Unpublish' : 'Publish',
                            style: TextStyle(
                              color: resource.isPublished
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
                Container(
                  width: 1,
                  height: 24,
                  color: _surface,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _deleteResource(resource),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_rounded,
                              color: _errorRed, size: 16),
                          SizedBox(width: 6),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: _errorRed,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 4),
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

  void _viewResourceDetails(Resource resource) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
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
                resource.title,
                style: const TextStyle(
                  color: _textLight,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                resource.description,
                style: const TextStyle(
                  color: _textMuted,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _detailRow('Type', resource.type),
              _detailRow('Category', resource.category),
              _detailRow('Source', resource.source),
              _detailRow('Source Type', resource.sourceType),
              _detailRow('Views', resource.viewCount.toString()),
              _detailRow('Rating', resource.rating.toString()),
              _detailRow(
                  'Status', resource.isPublished ? 'Published' : 'Draft'),
              _detailRow(
                  'Created', resource.createdAt.toString().split(' ')[0]),
              _detailRow(
                  'Updated', resource.updatedAt.toString().split(' ')[0]),
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

  void _handleResourceAction(Resource resource) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _cardBg,
        title: Text(
          resource.isPublished ? 'Unpublish Resource?' : 'Publish Resource?',
          style: const TextStyle(color: _textLight),
        ),
        content: Text(
          resource.isPublished
              ? 'This resource will no longer be visible to users.'
              : 'This resource will be visible to all users.',
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
              if (!resource.isPublished) {
                await _adminService.publishResource(resource.id);
              }
              _loadResources();
            },
            child: Text(
              resource.isPublished ? 'Unpublish' : 'Publish',
              style: TextStyle(
                color: resource.isPublished ? _errorRed : _successGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteResource(Resource resource) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _cardBg,
        title: const Text(
          'Delete Resource?',
          style: TextStyle(color: _textLight),
        ),
        content: const Text(
          'This action cannot be undone.',
          style: TextStyle(color: _textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: _textMuted)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _adminService.deleteResource(resource.id);
              _loadResources();
            },
            child: const Text('Delete', style: TextStyle(color: _errorRed)),
          ),
        ],
      ),
    );
  }

  void _showCreateResourceDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _cardBg,
        title: const Text(
          'Create New Resource',
          style: TextStyle(color: _textLight),
        ),
        content: const Text(
          'Resource creation feature coming soon!',
          style: TextStyle(color: _textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: _accentBlue)),
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
