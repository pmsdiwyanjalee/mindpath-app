import 'package:flutter/material.dart';

class CounsellorsScreen extends StatelessWidget {
  const CounsellorsScreen({Key? key}) : super(key: key);

  // Counsellor data model
  static const List<Map<String, dynamic>> _counsellors = [
    {
      'id': 1,
      'name': 'Dr. Sarah Johnson',
      'title': 'Clinical Psychologist & Addiction Specialist',
      'specialties': ['Substance Abuse', 'Anxiety', 'Trauma'],
      'experience': '12+ years',
      'languages': ['English', 'Spanish'],
      'bio': 'Dr. Johnson specializes in evidence-based treatments for addiction recovery, including CBT and motivational interviewing. She has helped hundreds of individuals achieve lasting sobriety.',
      'education': 'Ph.D. in Clinical Psychology - Stanford University',
      'certifications': 'Certified Addiction Specialist (CAS), Licensed Clinical Psychologist',
      'availability': 'Mon, Wed, Fri: 9 AM - 5 PM',
      'rating': 4.9,
      'reviews': 128,
      'imageIcon': Icons.person_rounded,
      'color': Color(0xFF7CA982),
    },
    {
      'id': 2,
      'name': 'Michael Chen, LCSW',
      'title': 'Licensed Clinical Social Worker',
      'specialties': ['Dual Diagnosis', 'Family Therapy', 'Relapse Prevention'],
      'experience': '8+ years',
      'languages': ['English', 'Mandarin'],
      'bio': 'Michael brings a compassionate, client-centered approach to recovery. He specializes in working with individuals facing co-occurring mental health conditions.',
      'education': 'Master of Social Work - University of Michigan',
      'certifications': 'Licensed Clinical Social Worker (LCSW), Certified Clinical Trauma Professional',
      'availability': 'Tue, Thu: 10 AM - 7 PM, Sat: 9 AM - 1 PM',
      'rating': 4.8,
      'reviews': 94,
      'imageIcon': Icons.person_rounded,
      'color': Color(0xFF4A9EAF),
    },
    {
      'id': 3,
      'name': 'Dr. Emily Rodriguez',
      'title': 'Psychiatrist & Addiction Medicine',
      'specialties': ['Medication Management', 'Co-occurring Disorders', 'Crisis Intervention'],
      'experience': '15+ years',
      'languages': ['English', 'Portuguese'],
      'bio': 'Dr. Rodriguez is board-certified in both Psychiatry and Addiction Medicine. She offers medication-assisted treatment alongside therapeutic support.',
      'education': 'M.D. - Johns Hopkins University School of Medicine',
      'certifications': 'Board Certified in Psychiatry and Addiction Medicine',
      'availability': 'Mon-Thu: 8 AM - 4 PM',
      'rating': 4.95,
      'reviews': 203,
      'imageIcon': Icons.medical_services_rounded,
      'color': Color(0xFFE8926A),
    },
    {
      'id': 4,
      'name': 'David Okonkwo, MA',
      'title': 'Certified Addiction Counselor',
      'specialties': ['Recovery Coaching', 'Life Skills', 'Motivation Enhancement'],
      'experience': '10+ years',
      'languages': ['English', 'Igbo'],
      'bio': 'David is a person in long-term recovery who brings lived experience to his counseling approach. He specializes in helping clients build meaningful lives in sobriety.',
      'education': 'M.A. in Counseling Psychology - Loyola University',
      'certifications': 'Certified Alcohol and Drug Counselor (CADC), Peer Recovery Specialist',
      'availability': 'Mon-Fri: 12 PM - 8 PM',
      'rating': 4.85,
      'reviews': 156,
      'imageIcon': Icons.person_rounded,
      'color': Color(0xFF9B8EC4),
    },
    {
      'id': 5,
      'name': 'Dr. Lisa Thompson',
      'title': 'Clinical Psychologist',
      'specialties': ['Cognitive Behavioral Therapy', 'Mindfulness', 'Stress Management'],
      'experience': '9+ years',
      'languages': ['English'],
      'bio': 'Dr. Thompson integrates mindfulness-based approaches with traditional CBT to help clients develop healthier coping mechanisms and reduce relapse risk.',
      'education': 'Psy.D. in Clinical Psychology - Rutgers University',
      'certifications': 'Licensed Psychologist, Certified Mindfulness-Based Stress Reduction Instructor',
      'availability': 'Tue, Wed, Thu: 9 AM - 6 PM',
      'rating': 4.9,
      'reviews': 112,
      'imageIcon': Icons.person_rounded,
      'color': Color(0xFFF4C542),
    },
    {
      'id': 6,
      'name': 'Rachel Green, LPC',
      'title': 'Licensed Professional Counselor',
      'specialties': ['Young Adult Recovery', 'Relationship Issues', 'Self-Esteem'],
      'experience': '7+ years',
      'languages': ['English', 'French'],
      'bio': 'Rachel specializes in working with young adults navigating recovery while managing career, relationships, and identity development.',
      'education': 'M.Ed. in Counseling - University of Pennsylvania',
      'certifications': 'Licensed Professional Counselor (LPC), Certified in TEAM-CBT',
      'availability': 'Mon, Wed, Fri: 11 AM - 7 PM',
      'rating': 4.75,
      'reviews': 87,
      'imageIcon': Icons.person_rounded,
      'color': Color(0xFF7CA982),
    },
  ];

  static const Color _bg = Color(0xFFF6F4F0);
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _textDark = Color(0xFF2D3142);
  static const Color _textMid = Color(0xFF6B7280);
  static const Color _textLight = Color(0xFF9CA3AF);
  static const Color _border = Color(0xFFE8E5E0);
  static const Color _sage = Color(0xFF7CA982);
  static const Color _sageLight = Color(0xFFD4EAD7);
  static const Color _teal = Color(0xFF4A9EAF);
  static const Color _tealLight = Color(0xFFD6EEF3);
  static const Color _peach = Color(0xFFE8926A);
  static const Color _peachLight = Color(0xFFFAE2D5);
  static const Color _lavender = Color(0xFF9B8EC4);
  static const Color _lavLight = Color(0xFFEAE6F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text(
          'Our Counsellors',
          style: TextStyle(color: _textDark, fontWeight: FontWeight.w700),
        ),
        backgroundColor: _surface,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: _textMid),
            onPressed: () {
              // Search functionality would go here
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search coming soon!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: _textMid),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filter coming soon!')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _counsellors.length,
        itemBuilder: (context, index) {
          final counsellor = _counsellors[index];
          return _buildCounsellorCard(context, counsellor);
        },
      ),
    );
  }

  Widget _buildCounsellorCard(BuildContext context, Map<String, dynamic> counsellor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with image/icon and basic info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: (counsellor['color'] as Color).withOpacity(0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                // Avatar/Icon
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: counsellor['color'],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (counsellor['color'] as Color).withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    counsellor['imageIcon'],
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        counsellor['name'],
                        style: const TextStyle(
                          color: _textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        counsellor['title'],
                        style: TextStyle(
                          color: counsellor['color'],
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Color(0xFFF4C542), size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${counsellor['rating']}',
                            style: const TextStyle(
                              color: _textDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${counsellor['reviews']} reviews)',
                            style: const TextStyle(
                              color: _textLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Details section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Experience and availability
                Row(
                  children: [
                    _buildInfoChip(
                      Icons.work_rounded,
                      counsellor['experience'],
                      _teal,
                      _tealLight,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      Icons.schedule_rounded,
                      '${counsellor['availability'].split(',').first}...',
                      _sage,
                      _sageLight,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Specialties
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (counsellor['specialties'] as List<String>).map((specialty) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _border),
                      ),
                      child: Text(
                        specialty,
                        style: const TextStyle(
                          color: _textMid,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),

                // Languages
                Row(
                  children: [
                    const Icon(Icons.language_rounded, color: _textLight, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      (counsellor['languages'] as List<String>).join(' · '),
                      style: const TextStyle(color: _textMid, fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Bio (truncated)
                Text(
                  counsellor['bio'],
                  style: const TextStyle(
                    color: _textMid,
                    fontSize: 13,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),
                Divider(color: _border, height: 1),

                // Action buttons
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _showCounsellorDetails(context, counsellor),
                          icon: const Icon(Icons.info_rounded, size: 18),
                          label: const Text('View Profile'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _teal,
                            side: BorderSide(color: _teal),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _scheduleSession(context, counsellor),
                          icon: const Icon(Icons.calendar_today_rounded, size: 18),
                          label: const Text('Book Session'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: counsellor['color'],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color, Color lightColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showCounsellorDetails(BuildContext context, Map<String, dynamic> counsellor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: _border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.all(20),
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: counsellor['color'],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            counsellor['imageIcon'],
                            color: Colors.white,
                            size: 42,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                counsellor['name'],
                                style: const TextStyle(
                                  color: _textDark,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                counsellor['title'],
                                style: TextStyle(
                                  color: counsellor['color'],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, color: Color(0xFFF4C542), size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${counsellor['rating']}',
                                    style: const TextStyle(
                                      color: _textDark,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '(${counsellor['reviews']} reviews)',
                                    style: const TextStyle(
                                      color: _textLight,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Education
                    _buildDetailSection(
                      'Education',
                      Icons.school_rounded,
                      counsellor['education'],
                      _sage,
                    ),
                    const SizedBox(height: 16),

                    // Certifications
                    _buildDetailSection(
                      'Certifications',
                      Icons.verified_rounded,
                      counsellor['certifications'],
                      _teal,
                    ),
                    const SizedBox(height: 16),

                    // Availability
                    _buildDetailSection(
                      'Availability',
                      Icons.schedule_rounded,
                      counsellor['availability'],
                      _peach,
                    ),
                    const SizedBox(height: 16),

                    // Languages
                    _buildDetailSection(
                      'Languages',
                      Icons.language_rounded,
                      (counsellor['languages'] as List<String>).join(' · '),
                      _lavender,
                    ),
                    const SizedBox(height: 16),

                    // Bio
                    _buildDetailSection(
                      'Biography',
                      Icons.description_rounded,
                      counsellor['bio'],
                      _textMid,
                      isLongText: true,
                    ),
                    const SizedBox(height: 24),

                    // Book button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _scheduleSession(context, counsellor);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: counsellor['color'],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Book a Session',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(
    String title,
    IconData icon,
    String content,
    Color iconColor, {
    bool isLongText = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: _textDark,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Text(
            content,
            style: TextStyle(
              color: _textMid,
              fontSize: isLongText ? 14 : 13,
              height: isLongText ? 1.5 : 1.4,
            ),
          ),
        ),
      ],
    );
  }

  void _scheduleSession(BuildContext context, Map<String, dynamic> counsellor) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        decoration: const BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: _border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Icon(Icons.calendar_month_rounded, size: 48, color: _sage),
            const SizedBox(height: 12),
            Text(
              'Book Session with ${counsellor['name']}',
              style: const TextStyle(
                color: _textDark,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Select a date and time that works for you',
              style: TextStyle(color: _textMid, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _bg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.access_time_rounded, color: _teal),
                    title: const Text('45 min session'),
                    subtitle: Text('\$${counsellor['experience'].contains('15') ? '150' : '120'} per session'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.videocam_rounded, color: _teal),
                    title: const Text('Video call'),
                    subtitle: const Text('Secure, confidential platform'),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Session request sent to ${counsellor['name']}!'),
                    backgroundColor: _sage,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: counsellor['color'],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Request Session',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: _textLight)),
            ),
          ],
        ),
      ),
    );
  }
}