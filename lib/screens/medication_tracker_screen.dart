import 'package:flutter/material.dart';

class MedicationTrackerScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const MedicationTrackerScreen({Key? key}) : super(key: key);

  @override
  State<MedicationTrackerScreen> createState() =>
      _MedicationTrackerScreenState();
}

class _MedicationTrackerScreenState extends State<MedicationTrackerScreen> {
  final List<Map<String, dynamic>> _medications = [
    {
      'name': 'Naltrexone',
      'dosage': '50 mg',
      'frequency': 'Daily',
      'time': '8:00 AM',
      'purpose': 'Reduces cravings',
      'startDate': 'March 18, 2026',
      'adherence': 98,
      'today': true
    },
    {
      'name': 'Sertraline',
      'dosage': '100 mg',
      'frequency': 'Daily',
      'time': '8:00 AM',
      'purpose': 'Depression & Anxiety',
      'startDate': 'March 15, 2026',
      'adherence': 95,
      'today': true
    },
    {
      'name': 'Bupropion',
      'dosage': '300 mg',
      'frequency': 'Daily',
      'time': '6:00 AM',
      'purpose': 'Energy & Motivation',
      'startDate': 'March 20, 2026',
      'adherence': 92,
      'today': false
    },
  ];

  final List<Map<String, dynamic>> _history = [
    {
      'date': 'April 4 (Today)',
      'medication': 'Naltrexone',
      'taken': true,
      'time': '8:15 AM'
    },
    {
      'date': 'April 4 (Today)',
      'medication': 'Sertraline',
      'taken': true,
      'time': '8:10 AM'
    },
    {
      'date': 'April 3',
      'medication': 'Naltrexone',
      'taken': true,
      'time': '8:00 AM'
    },
    {
      'date': 'April 3',
      'medication': 'Sertraline',
      'taken': true,
      'time': '8:05 AM'
    },
    {
      'date': 'April 3',
      'medication': 'Bupropion',
      'taken': true,
      'time': '6:10 AM'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF051A3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF051A3F),
        elevation: 0,
        title: const Text('Medication Tracker',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Today's Medications
              const Text('Today\'s Medications',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              // ignore: unnecessary_to_list_in_spreads
              ..._medications.map((med) => _buildMedicationCard(med)).toList(),
              const SizedBox(height: 24),
              // Adherence Summary
              const Text('Adherence Summary',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Average Adherence',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 4),
                            const Text('95%',
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.greenAccent,
                              width: 4,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text('Excellent',
                                    style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10)),
                                Text('Work!',
                                    style: TextStyle(
                                        color: Colors.greenAccent,
                                        fontSize: 10)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                        'You\'ve taken 47 out of 50 doses this month. Keep up the great work!',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Medication History
              const Text('Recent Medication History',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final item = _history[index];
                  return _buildHistoryItem(item);
                },
              ),
              const SizedBox(height: 16),
              // Add reminder button
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reminder set!')),
                  );
                },
                icon: const Icon(Icons.notifications_active),
                label: const Text('Set Medication Reminder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2C74FF),
                  minimumSize: const Size.fromHeight(48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationCard(Map<String, dynamic> med) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF0C234E),
            title:
                Text(med['name'], style: const TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Dosage:', med['dosage']),
                _buildDetailRow('Frequency:', med['frequency']),
                _buildDetailRow('Time:', med['time']),
                _buildDetailRow('Purpose:', med['purpose']),
                _buildDetailRow('Started:', med['startDate']),
                _buildDetailRow('Adherence:', '${med['adherence']}%'),
                const SizedBox(height: 12),
                const Text(
                    'Side Effects:\nMinimal. Report any unusual symptoms to your doctor.',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close',
                    style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1B3575),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: med['today'] ? Colors.greenAccent : Colors.orangeAccent,
              ),
              child: Center(
                child: Text(med['today'] ? '✓' : '!',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(med['name'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                  Text('${med['dosage']} - ${med['frequency']}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12)),
                  Text(med['time'],
                      style: const TextStyle(
                          color: Colors.blueAccent, fontSize: 11)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF0C234E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('${med['adherence']}%',
                  style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0C234E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item['medication'],
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
              Text(item['date'],
                  style: const TextStyle(color: Colors.white54, fontSize: 10)),
            ],
          ),
          Row(
            children: [
              Icon(
                item['taken'] ? Icons.check_circle : Icons.cancel,
                color: item['taken'] ? Colors.greenAccent : Colors.redAccent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(item['time'],
                  style: const TextStyle(color: Colors.white70, fontSize: 11)),
            ],
          ),
        ],
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
