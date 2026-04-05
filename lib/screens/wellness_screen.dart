import 'package:flutter/material.dart';

class WellnessScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const WellnessScreen({Key? key}) : super(key: key);

  @override
  State<WellnessScreen> createState() => _WellnessScreenState();
}

class _WellnessScreenState extends State<WellnessScreen> {
  final List<Map<String, dynamic>> _wellnessData = [
    {
      'date': 'Today',
      'water': 8,
      'exercise': 45,
      'sleep': 8,
      'meditation': 20,
      'mood': '😊'
    },
    {
      'date': 'Yesterday',
      'water': 7,
      'exercise': 30,
      'sleep': 7,
      'meditation': 15,
      'mood': '😊'
    },
    {
      'date': 'Apr 2',
      'water': 6,
      'exercise': 60,
      'sleep': 8,
      'meditation': 25,
      'mood': '😊'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051A3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF051A3F),
        elevation: 0,
        title: const Text('Wellness & Health',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Daily Goals Progress
              const Text('Today\'s Goals',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _buildGoalProgressCard(
                  'Water Intake', 8, 8, 'cups', Colors.blueAccent),
              _buildGoalProgressCard(
                  'Exercise', 45, 60, 'minutes', Colors.greenAccent),
              _buildGoalProgressCard(
                  'Sleep', 8, 8, 'hours', Colors.purpleAccent),
              _buildGoalProgressCard(
                  'Meditation', 20, 30, 'minutes', Colors.orangeAccent),
              const SizedBox(height: 24),
              // Health Metrics
              const Text('Health Metrics',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard('Heart Rate', '72', 'bpm',
                        Colors.redAccent, Icons.favorite),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard('Blood Pressure', '120/80', 'mmHg',
                        Colors.orangeAccent, Icons.monitor_heart),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                        'Weight', '155', 'lbs', Colors.blueAccent, Icons.scale),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricCard('Steps', '8,542', 'today',
                        Colors.greenAccent, Icons.directions_walk),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Wellness History
              const Text('Weekly History',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _wellnessData.length,
                itemBuilder: (context, index) {
                  final data = _wellnessData[index];
                  return _buildHistoryCard(data);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Health data logged!')),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Log Health Data'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C74FF),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalProgressCard(
      String goal, int current, int target, String unit, Color color) {
    final progress = current / target;
    return Container(
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
              Text(goal,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
              Text('$current/$target $unit',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white12,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String label, String value, String unit, Color color, IconData icon) {
    return Container(
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
              Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 20, fontWeight: FontWeight.bold)),
          Text(unit,
              style: const TextStyle(color: Colors.white54, fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0C234E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1B3575)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data['date'],
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold)),
              Text(data['mood'], style: const TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHistoryItem('💧', '${data['water']}', 'cups'),
              _buildHistoryItem('🏃', '${data['exercise']}', 'min'),
              _buildHistoryItem('😴', '${data['sleep']}', 'hrs'),
              _buildHistoryItem('🧘', '${data['meditation']}', 'min'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }
}
