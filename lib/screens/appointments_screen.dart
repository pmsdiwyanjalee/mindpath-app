import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../l10n/app_localizations_fallback.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final List<Map<String, dynamic>> _appointments = [
    {
      'typeKey': 'counsellingSession',
      'counsellor': 'Sarah Johnson',
      'date': 'April 5, 2026',
      'time': '2:00 PM - 3:00 PM',
      'statusKey': 'confirmed',
      'methodKey': 'videoCall',
      'icon': Icons.video_call,
    },
    {
      'typeKey': 'supportGroupMeeting',
      'counsellor': 'Group Leaders',
      'date': 'April 7, 2026',
      'time': '7:00 PM - 8:30 PM',
      'statusKey': 'confirmed',
      'methodKey': 'inPerson',
      'icon': Icons.group,
    },
    {
      'typeKey': 'followUpSession',
      'counsellor': 'Dr. Marcus Cole',
      'date': 'April 12, 2026',
      'time': '3:30 PM - 4:30 PM',
      'statusKey': 'pending',
      'methodKey': 'phoneCall',
      'icon': Icons.call,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF051A3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF051A3F),
        elevation: 0,
        title: Text(localizations.appointmentsAndBooking,
            style: const TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => _showBookingDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(localizations.yourAppointments,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              // Key Info
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B3575),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(localizations.upcoming,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          const Text('1',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B3575),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(localizations.thisWeek,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          const Text('2',
                              style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1B3575),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Text(localizations.completed,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const SizedBox(height: 4),
                          const Text('12',
                              style: TextStyle(
                                  color: Colors.purpleAccent,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Upcoming Appointments
              Text(localizations.scheduledSessions,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              Column(
                children: _appointments.map((apt) {
                  return _buildAppointmentCard(apt, localizations);
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Available Slots
              Text(localizations.bookNewAppointment,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),

              _buildCounsellorsSection(),

              const SizedBox(height: 24),

              // Cancellation Policy
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C234E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localizations.cancellationPolicy,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      localizations.cancellationPolicyText,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
      Map<String, dynamic> apt, dynamic localizations) {
    return GestureDetector(
      onTap: () => _showAppointmentDetails(apt),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(apt['icon'], color: Colors.blueAccent, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _localizedAppointmentType(
                                  context, apt['typeKey'] as String),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('${localizations.withLabel} ${apt['counsellor']}',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        _localizedStatus(context, apt['statusKey'] as String) ==
                                localizations.confirmed
                            ? Colors.green
                            : Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _localizedStatus(context, apt['statusKey'] as String),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(apt['date'],
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white70, size: 16),
                const SizedBox(width: 8),
                Text(apt['time'],
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  _methodIcon(apt['methodKey'] as String),
                  color: Colors.blueAccent,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _localizedAppointmentMethod(
                      context, apt['methodKey'] as String),
                  style:
                      const TextStyle(color: Colors.blueAccent, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounsellorsSection() {
    final counsellors = [
      {
        'name': 'Sarah Johnson',
        'specialty': 'Addiction Recovery',
        'available': 'Tomorrow, 10:00 AM',
        'rating': '4.9'
      },
      {
        'name': 'Dr. Marcus Cole',
        'specialty': 'Family Counselling',
        'available': 'Wednesday, 3:00 PM',
        'rating': '4.8'
      },
      {
        'name': 'Lisa Chen',
        'specialty': 'Mindfulness & Meditation',
        'available': 'Friday, 2:00 PM',
        'rating': '4.7'
      },
    ];

    return Column(
      children: counsellors.map((c) {
        return _buildCounselllorCard(c);
      }).toList(),
    );
  }

  Widget _buildCounselllorCard(Map<String, String> counsellor) {
    return GestureDetector(
      onTap: () => _showBookingConfirmation(counsellor),
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
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF255BFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(counsellor['name']!,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(counsellor['specialty']!,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Colors.yellowAccent, size: 12),
                      const SizedBox(width: 4),
                      Text(counsellor['rating']!,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 11)),
                      const SizedBox(width: 12),
                      Text(counsellor['available']!,
                          style: const TextStyle(
                              color: Colors.blueAccent, fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }

  void _showAppointmentDetails(Map<String, dynamic> apt) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0C234E),
          title: Text(
            _localizedAppointmentType(context, apt['typeKey'] as String),
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${localizations.withLabel} ${apt['counsellor']}',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 12),
              Text('${localizations.dateLabel} ${apt['date']}',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text('${localizations.timeLabel} ${apt['time']}',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Text(
                  '${localizations.methodLabel} ${_localizedAppointmentMethod(context, apt['methodKey'] as String)}',
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3575),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${localizations.statusLabel} ${_localizedStatus(context, apt['statusKey'] as String)}',
                  style: TextStyle(
                    color:
                        _localizedStatus(context, apt['statusKey'] as String) ==
                                localizations.confirmed
                            ? Colors.greenAccent
                            : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.closeLabel,
                  style: const TextStyle(color: Colors.white70)),
            ),
            if (apt['statusKey'] == 'pending')
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localizations.appointmentConfirmed)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                ),
                child: Text(localizations.confirmBooking),
              ),
          ],
        );
      },
    );
  }

  void _showBookingDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0C234E),
          title: Text(localizations.bookNewAppointment,
              style: const TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(localizations.selectCounsellor,
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: localizations.chooseCounsellor,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Text(localizations.preferredDate,
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: localizations.selectDate,
                    border: const OutlineInputBorder(),
                    suffixIcon: const Icon(Icons.calendar_today),
                  ),
                ),
                const SizedBox(height: 16),
                Text(localizations.sessionType,
                    style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2C74FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(localizations.videoCall,
                                style: const TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1B3575),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(localizations.phone,
                                style: const TextStyle(color: Colors.white70)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancelLabel,
                  style: const TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(localizations.appointmentRequestSent)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C74FF),
              ),
              child: Text(localizations.bookNewAppointmentButton),
            ),
          ],
        );
      },
    );
  }

  void _showBookingConfirmation(Map<String, String> counsellor) {
    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0C234E),
          title: Text(localizations.bookWithLabel(counsellor['name']!),
              style: const TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${localizations.available} ${counsellor['available']!}',
                style: const TextStyle(color: Colors.blueAccent),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1B3575),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  localizations.confirmationSent,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(localizations.cancelLabel,
                  style: const TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(localizations
                          .appointmentBookedWith(counsellor['name']!))),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
              ),
              child: Text(localizations.confirmBooking),
            ),
          ],
        );
      },
    );
  }

  String _localizedAppointmentType(BuildContext context, String typeKey) {
    final localizations = AppLocalizations.of(context)!;
    switch (typeKey) {
      case 'counsellingSession':
        return localizations.counsellingSession;
      case 'supportGroupMeeting':
        return localizations.supportGroupMeeting;
      case 'followUpSession':
        return localizations.followUpSession;
      default:
        return typeKey;
    }
  }

  String _localizedAppointmentMethod(BuildContext context, String methodKey) {
    final localizations = AppLocalizations.of(context)!;
    switch (methodKey) {
      case 'videoCall':
        return localizations.videoCall;
      case 'phoneCall':
        return localizations.phoneCall;
      case 'inPerson':
        return localizations.inPerson;
      default:
        return methodKey;
    }
  }

  String _localizedStatus(BuildContext context, String statusKey) {
    final localizations = AppLocalizations.of(context)!;
    switch (statusKey) {
      case 'confirmed':
        return localizations.confirmed;
      case 'pending':
        return localizations.pending;
      default:
        return statusKey;
    }
  }

  IconData _methodIcon(String methodKey) {
    switch (methodKey) {
      case 'videoCall':
        return Icons.video_call;
      case 'phoneCall':
        return Icons.call;
      case 'inPerson':
        return Icons.person;
      default:
        return Icons.help;
    }
  }
}
