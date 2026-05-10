// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'admin_service.dart';
import 'admin_data_models.dart';

class AdminSupportTicketsScreen extends StatefulWidget {
  const AdminSupportTicketsScreen({super.key});

  @override
  State<AdminSupportTicketsScreen> createState() =>
      _AdminSupportTicketsScreenState();
}

class _AdminSupportTicketsScreenState extends State<AdminSupportTicketsScreen> {
  final AdminService _adminService = AdminService();
  late List<SupportTicket> _allTickets;
  late List<SupportTicket> _filteredTickets;
  String _searchQuery = '';
  String _selectedStatus = 'all';
  bool _isLoading = true;

  // Color Palette
  static const Color _darkBg = Color(0xFF1A1A2E);
  static const Color _cardBg = Color(0xFF16213E);
  static const Color _surface = Color(0xFF0F3460);
  static const Color _accentBlue = Color(0xFF00A3FF);
  static const Color _textLight = Color(0xFFEAEAEA);
  static const Color _textMuted = Color(0xFF9CA3AF);
  static const Color _successGreen = Color(0xFF2ED573);
  static const Color _warningOrange = Color(0xFFF0932B);

  final Map<String, Color> _statusColors = {
    'open': const Color(0xFFFF4757),
    'in_progress': const Color(0xFFF0932B),
    'resolved': const Color(0xFF2ED573),
    'closed': const Color(0xFF9CA3AF),
  };

  final Map<String, Color> _priorityColors = {
    'low': const Color(0xFF2ED573),
    'medium': const Color(0xFFF0932B),
    'high': const Color(0xFFFF6348),
    'critical': const Color(0xFF9C27B0),
  };

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    _allTickets = await _adminService.getAllSupportTickets();
    _filterTickets();
    setState(() => _isLoading = false);
  }

  void _filterTickets() {
    _filteredTickets = _allTickets.where((ticket) {
      final matchesSearch =
          ticket.subject.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              ticket.userId.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesStatus =
          _selectedStatus == 'all' || ticket.status == _selectedStatus;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  int _getStatusCount(String status) {
    if (status == 'all') return _allTickets.length;
    return _allTickets.where((t) => t.status == status).length;
  }

  void _updateTicketStatus(SupportTicket ticket, String newStatus) {
    final snackBarContext = context;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _cardBg,
        title: const Text(
          'Update Ticket Status',
          style: TextStyle(color: _textLight, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Move ticket from ${ticket.status} to $newStatus?',
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
              await _adminService.updateTicketStatus(ticket.id, newStatus);
              if (!mounted) return;
              _loadTickets();
              if (!mounted) return;
              ScaffoldMessenger.of(snackBarContext).showSnackBar(
                SnackBar(
                  content: const Text('Ticket status updated'),
                  backgroundColor: _successGreen,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Update', style: TextStyle(color: _accentBlue)),
          ),
        ],
      ),
    );
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
          'Support Tickets',
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
                // ── Search Bar ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    onChanged: (value) {
                      _searchQuery = value;
                      _filterTickets();
                      setState(() {});
                    },
                    style: const TextStyle(color: _textLight),
                    decoration: InputDecoration(
                      hintText: 'Search tickets...',
                      hintStyle: const TextStyle(color: _textMuted),
                      prefixIcon:
                          const Icon(Icons.search_rounded, color: _textMuted),
                      filled: true,
                      fillColor: _cardBg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _surface, width: 1),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _surface, width: 1),
                      ),
                    ),
                  ),
                ),

                // ── Status Filter Tabs ──────────────────────────────────
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      _statusTab('all', 'All (${_getStatusCount('all')})'),
                      const SizedBox(width: 10),
                      _statusTab('open', 'Open (${_getStatusCount('open')})'),
                      const SizedBox(width: 10),
                      _statusTab('in_progress',
                          'In Progress (${_getStatusCount('in_progress')})'),
                      const SizedBox(width: 10),
                      _statusTab('resolved',
                          'Resolved (${_getStatusCount('resolved')})'),
                      const SizedBox(width: 10),
                      _statusTab(
                          'closed', 'Closed (${_getStatusCount('closed')})'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Tickets List ────────────────────────────────────────
                Expanded(
                  child: _filteredTickets.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.inbox_rounded,
                                  size: 48,
                                  color: _textMuted.withValues(alpha: 0.5)),
                              const SizedBox(height: 12),
                              const Text(
                                'No tickets found',
                                style: TextStyle(
                                  color: _textMuted,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredTickets.length,
                          itemBuilder: (context, index) =>
                              _ticketCard(_filteredTickets[index]),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _statusTab(String status, String label) {
    final isSelected = _selectedStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedStatus = status);
        _filterTickets();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? _accentBlue : _cardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? _accentBlue : _surface,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? _darkBg : _textLight,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _ticketCard(SupportTicket ticket) {
    final statusColor = _statusColors[ticket.status] ?? _textMuted;
    final priorityColor = _priorityColors[ticket.priority] ?? _textMuted;

    return GestureDetector(
      onTap: () => _showTicketDetails(ticket),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _surface, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.subject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: _textLight,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ID: ${ticket.id}',
                          style: const TextStyle(
                            color: _textMuted,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      ticket.priority.toUpperCase(),
                      style: TextStyle(
                        color: priorityColor,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Status badge
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  ticket.status.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // User & created date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'User: ${ticket.userId}',
                    style: const TextStyle(
                      color: _textMuted,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    'Created: ${ticket.createdAt.toString().split(' ')[0]}',
                    style: const TextStyle(
                      color: _textMuted,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTicketDetails(SupportTicket ticket) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardBg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        ticket.subject,
                        style: const TextStyle(
                          color: _textLight,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close_rounded,
                          color: _textMuted, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Status & Priority
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColors[ticket.status]!
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Status: ${ticket.status.replaceAll('_', ' ').toUpperCase()}',
                        style: TextStyle(
                          color: _statusColors[ticket.status],
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _priorityColors[ticket.priority]!
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Priority: ${ticket.priority.toUpperCase()}',
                        style: TextStyle(
                          color: _priorityColors[ticket.priority],
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Details section
                const Text(
                  'Description',
                  style: TextStyle(
                    color: _textLight,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ticket.description,
                  style: const TextStyle(
                    color: _textMuted,
                    fontSize: 12,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),

                // Info grid
                Container(
                  decoration: BoxDecoration(
                    color: _surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      _infoRow('User ID', ticket.userId),
                      const Divider(color: Color(0xFF2A3E5A), height: 12),
                      _infoRow(
                          'Created', ticket.createdAt.toString().split('.')[0]),
                      if (ticket.resolvedAt != null) ...[
                        const Divider(color: Color(0xFF2A3E5A), height: 12),
                        _infoRow('Resolved',
                            ticket.resolvedAt.toString().split('.')[0]),
                      ],
                      if (ticket.assignedTo != null) ...[
                        const Divider(color: Color(0xFF2A3E5A), height: 12),
                        _infoRow('Assigned To', ticket.assignedTo!),
                      ],
                      const Divider(color: Color(0xFF2A3E5A), height: 12),
                      _infoRow('Comments', ticket.comments.length.toString()),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Comments section
                if (ticket.comments.isNotEmpty) ...[
                  const Text(
                    'Comments',
                    style: TextStyle(
                      color: _textLight,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: ticket.comments.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final comment = ticket.comments[index];
                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _darkBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          comment,
                          style: const TextStyle(
                            color: _textMuted,
                            fontSize: 11,
                            height: 1.5,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (ticket.status != 'resolved')
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _updateTicketStatus(ticket, 'resolved');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _successGreen,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Mark as Resolved',
                            style: TextStyle(
                              color: _darkBg,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    if (ticket.status != 'resolved') const SizedBox(width: 10),
                    if (ticket.status != 'in_progress')
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _updateTicketStatus(ticket, 'in_progress');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _warningOrange,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'In Progress',
                            style: TextStyle(
                              color: _darkBg,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: _textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: _textLight,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
