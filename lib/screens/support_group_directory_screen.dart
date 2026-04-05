import 'package:flutter/material.dart';

class SupportGroupDirectoryScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const SupportGroupDirectoryScreen({Key? key}) : super(key: key);

  @override
  State<SupportGroupDirectoryScreen> createState() =>
      _SupportGroupDirectoryScreenState();
}

class _SupportGroupDirectoryScreenState
    extends State<SupportGroupDirectoryScreen> {
  final List<Map<String, dynamic>> _supportGroups = [
    {
      'name': 'Narcotics Anonymous',
      'type': 'NA Meetings',
      'time': 'Mon, Wed, Fri - 7:00 PM',
      'location': 'Community Center, Main St',
      'distance': '2.3 km',
      'members': 156,
      'rating': 4.8,
      'format': 'In-Person'
    },
    {
      'name': 'Alcoholics Anonymous Downtown',
      'type': 'AA Meetings',
      'time': 'Daily - 6:00 PM',
      'location': 'Church Hall, 5th Ave',
      'distance': '1.5 km',
      'members': 234,
      'rating': 4.9,
      'format': 'In-Person'
    },
    {
      'name': 'Recovery Online Support',
      'type': 'Online Support',
      'time': 'Daily - 8:00 PM',
      'location': 'Zoom Meeting',
      'distance': 'Online',
      'members': 89,
      'rating': 4.6,
      'format': 'Online'
    },
    {
      'name': 'SMART Recovery Group',
      'type': 'SMART Recovery',
      'time': 'Tuesday, Thursday - 6:30 PM',
      'location': 'Library Meeting Room',
      'distance': '3.1 km',
      'members': 45,
      'rating': 4.7,
      'format': 'In-Person'
    },
    {
      'name': 'Women\'s Recovery Circle',
      'type': 'Women Only',
      'time': 'Saturday - 10:00 AM',
      'location': 'Wellness Center',
      'distance': '4.2 km',
      'members': 67,
      'rating': 4.9,
      'format': 'In-Person'
    },
  ];

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedFilter == 'All'
        ? _supportGroups
        : _selectedFilter == 'In-Person'
            ? _supportGroups.where((g) => g['format'] == 'In-Person').toList()
            : _supportGroups.where((g) => g['format'] == 'Online').toList();

    return Scaffold(
      backgroundColor: const Color(0xFF051A3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF051A3F),
        elevation: 0,
        title: const Text('Support Groups',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Filter buttons
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: const Color(0xFF0C234E),
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildFilterChip('All'),
                    const SizedBox(width: 8),
                    _buildFilterChip('In-Person'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Online'),
                  ],
                ),
              ),
            ),
            // Groups list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return _buildGroupCard(filtered[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2C74FF) : const Color(0xFF1B3575),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.white24,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupCard(Map<String, dynamic> group) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF0C234E),
              title: Text(group['name'],
                  style: const TextStyle(color: Colors.white)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Type:', group['type']),
                    _buildDetailRow('Time:', group['time']),
                    _buildDetailRow('Location:', group['location']),
                    _buildDetailRow('Distance:', group['distance']),
                    _buildDetailRow('Members:', '${group['members']}'),
                    _buildDetailRow('Rating:',
                        '⭐ ${group['rating']} (${group['members']} reviews)'),
                    const SizedBox(height: 16),
                    const Text('Group Description',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                        'A supportive community dedicated to recovery and mutual support. Open to all individuals seeking help.',
                        style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close',
                      style: TextStyle(color: Colors.white70)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Joined group! See you there.')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C74FF),
                  ),
                  child: const Text('Join'),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B3575),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(group['name'],
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14)),
                      const SizedBox(height: 4),
                      Text(group['type'],
                          style: const TextStyle(
                              color: Colors.blueAccent, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C234E),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(group['format'],
                      style: const TextStyle(
                          color: Colors.greenAccent, fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('🕐 ${group['time']}',
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 4),
            Text('📍 ${group['distance']}',
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('⭐ ${group['rating']}',
                    style: const TextStyle(
                        color: Colors.yellowAccent, fontSize: 12)),
                Text('👥 ${group['members']} members',
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Expanded(
            child: Text(value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
