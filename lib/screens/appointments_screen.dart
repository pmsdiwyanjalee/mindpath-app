import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../l10n/app_localizations_fallback.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double>   _fadeAnim;

  // ── Palette ───────────────────────────────────────────────────────────────
  static const Color _bg         = Color(0xFFF6F4F0);
  static const Color _surface    = Color(0xFFFFFFFF);
  static const Color _sage       = Color(0xFF7CA982);
  static const Color _sageLight  = Color(0xFFD4EAD7);
  static const Color _teal       = Color(0xFF4A9EAF);
  static const Color _tealLight  = Color(0xFFD6EEF3);
  static const Color _peach      = Color(0xFFE8926A);
  static const Color _peachLight = Color(0xFFFAE2D5);
  static const Color _lavender   = Color(0xFF9B8EC4);
  static const Color _lavLight   = Color(0xFFEAE6F5);
  static const Color _gold       = Color(0xFFF4C542);
  static const Color _goldLight  = Color(0xFFFDF3CC);
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7280);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  // Cycling accent for appointment cards
  static const List<List<Color>> _accentCycle = [
    [Color(0xFF4A9EAF), Color(0xFFD6EEF3)],
    [Color(0xFF7CA982), Color(0xFFD4EAD7)],
    [Color(0xFF9B8EC4), Color(0xFFEAE6F5)],
  ];

  final List<Map<String, dynamic>> _appointments = [
    {
      'typeKey': 'counsellingSession',
      'counsellor': 'Sarah Johnson',
      'date': 'April 5, 2026',
      'time': '2:00 PM – 3:00 PM',
      'statusKey': 'confirmed',
      'methodKey': 'videoCall',
      'icon': Icons.video_call_rounded,
    },
    {
      'typeKey': 'supportGroupMeeting',
      'counsellor': 'Group Leaders',
      'date': 'April 7, 2026',
      'time': '7:00 PM – 8:30 PM',
      'statusKey': 'confirmed',
      'methodKey': 'inPerson',
      'icon': Icons.group_rounded,
    },
    {
      'typeKey': 'followUpSession',
      'counsellor': 'Dr. Marcus Cole',
      'date': 'April 12, 2026',
      'time': '3:30 PM – 4:30 PM',
      'statusKey': 'pending',
      'methodKey': 'phoneCall',
      'icon': Icons.call_rounded,
    },
  ];

  static const List<Map<String, String>> _counsellors = [
    {
      'name': 'Sarah Johnson',
      'specialty': 'Addiction Recovery',
      'available': 'Tomorrow, 10:00 AM',
      'rating': '4.9',
      'emoji': '👩‍⚕️',
    },
    {
      'name': 'Dr. Marcus Cole',
      'specialty': 'Family Counselling',
      'available': 'Wednesday, 3:00 PM',
      'rating': '4.8',
      'emoji': '👨‍⚕️',
    },
    {
      'name': 'Lisa Chen',
      'specialty': 'Mindfulness & Meditation',
      'available': 'Friday, 2:00 PM',
      'rating': '4.7',
      'emoji': '🧘‍♀️',
    },
  ];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim = CurvedAnimation(
        parent: _entranceController, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  // ── Localization helpers ──────────────────────────────────────────────────

  String _aptType(BuildContext context, String key) {
    final l = AppLocalizations.of(context)!;
    switch (key) {
      case 'counsellingSession':  return l.counsellingSession;
      case 'supportGroupMeeting': return l.supportGroupMeeting;
      case 'followUpSession':     return l.followUpSession;
      default:                    return key;
    }
  }

  String _aptMethod(BuildContext context, String key) {
    final l = AppLocalizations.of(context)!;
    switch (key) {
      case 'videoCall':  return l.videoCall;
      case 'phoneCall':  return l.phoneCall;
      case 'inPerson':   return l.inPerson;
      default:           return key;
    }
  }

  String _aptStatus(BuildContext context, String key) {
    final l = AppLocalizations.of(context)!;
    switch (key) {
      case 'confirmed': return l.confirmed;
      case 'pending':   return l.pending;
      default:          return key;
    }
  }

  IconData _methodIcon(String key) {
    switch (key) {
      case 'videoCall': return Icons.video_call_rounded;
      case 'phoneCall': return Icons.call_rounded;
      case 'inPerson':  return Icons.person_rounded;
      default:          return Icons.help_outline_rounded;
    }
  }

  bool _isConfirmed(BuildContext context, String statusKey) =>
      _aptStatus(context, statusKey) ==
      AppLocalizations.of(context)!.confirmed;

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _card({required Widget child}) => Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: child,
      );

  Widget _sectionHeader(
      String title, IconData icon, Color accent, Color accentLight) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: accentLight,
                borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: accent, size: 18),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  color: _textDark,
                  fontSize: 17,
                  fontWeight: FontWeight.w700)),
        ]),
      );

  Widget _handle() => Center(
        child: Container(
          width: 40, height: 4,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
              color: _border, borderRadius: BorderRadius.circular(2)),
        ),
      );

  Widget _sheetInput(String hint, IconData icon,
      {TextInputType keyboardType = TextInputType.text,
      Widget? suffixIcon}) =>
      TextField(
        keyboardType: keyboardType,
        style: const TextStyle(color: _textDark, fontSize: 14.5),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: _textLight),
          prefixIcon: Icon(icon, color: _textLight, size: 20),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: _bg,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _border)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _border)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: _teal, width: 1.5)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      );

  // ── Appointment Detail Sheet ──────────────────────────────────────────────

  void _showAppointmentDetails(Map<String, dynamic> apt, int index) {
    final accent    = _accentCycle[index % _accentCycle.length][0];
    final light     = _accentCycle[index % _accentCycle.length][1];
    final confirmed = _isConfirmed(context, apt['statusKey'] as String);
    final l         = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        decoration: const BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _handle(),

            // Hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                  color: light, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Icon(apt['icon'] as IconData, color: accent, size: 44),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                        color: confirmed ? _sage : _peach,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      _aptStatus(context, apt['statusKey'] as String),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            Text(_aptType(context, apt['typeKey'] as String),
                style: const TextStyle(
                    color: _textDark,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
                textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Text('${l.withLabel} ${apt['counsellor']}',
                style: const TextStyle(color: _textMid),
                textAlign: TextAlign.center),
            const SizedBox(height: 18),

            // Detail rows
            _detailCard([
              _detailRow(Icons.calendar_today_rounded, l.dateLabel,
                  apt['date'] as String, accent, light),
              _detailRow(Icons.access_time_rounded, l.timeLabel,
                  apt['time'] as String, accent, light),
              _detailRow(_methodIcon(apt['methodKey'] as String),
                  l.methodLabel,
                  _aptMethod(context, apt['methodKey'] as String),
                  accent, light,
                  isLast: true),
            ]),
            const SizedBox(height: 16),

            if (!confirmed) ...[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l.appointmentConfirmed),
                      backgroundColor: _sage,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _sage,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(l.confirmBooking,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w700)),
              ),
            ] else ...[
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: _textMid,
                  side: const BorderSide(color: _border),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(l.closeLabel,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _detailCard(List<Widget> children) => Container(
        decoration: BoxDecoration(
            color: _surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _border)),
        child: Column(children: children),
      );

  Widget _detailRow(IconData icon, String label, String value,
      Color accent, Color light,
      {bool isLast = false}) =>
      Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                      color: light,
                      borderRadius: BorderRadius.circular(9)),
                  child: Icon(icon, color: accent, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label,
                          style: const TextStyle(
                              color: _textLight, fontSize: 11)),
                      Text(value,
                          style: const TextStyle(
                              color: _textDark,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (!isLast)
            Divider(height: 1, color: _border, indent: 14, endIndent: 14),
        ],
      );

  // ── Booking Sheet ─────────────────────────────────────────────────────────

  void _showBookingSheet(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    String _selectedMethod = 'videoCall';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: StatefulBuilder(
          builder: (ctx, setSheet) => Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            decoration: const BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _handle(),
                Row(children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: _tealLight,
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.add_circle_rounded,
                        color: _teal, size: 18),
                  ),
                  const SizedBox(width: 10),
                  Text(l.bookNewAppointment,
                      style: const TextStyle(
                          color: _textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                ]),
                const SizedBox(height: 20),
                Text(l.selectCounsellor,
                    style: const TextStyle(
                        color: _textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _sheetInput(l.chooseCounsellor,
                    Icons.person_search_rounded),
                const SizedBox(height: 14),
                Text(l.preferredDate,
                    style: const TextStyle(
                        color: _textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _sheetInput(l.selectDate,
                    Icons.calendar_today_rounded,
                    suffixIcon: Icon(Icons.calendar_today_rounded,
                        color: _teal, size: 20)),
                const SizedBox(height: 14),
                Text(l.sessionType,
                    style: const TextStyle(
                        color: _textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                Row(children: [
                  for (final m in [
                    ['videoCall', Icons.video_call_rounded],
                    ['phoneCall', Icons.call_rounded],
                    ['inPerson',  Icons.person_rounded],
                  ])
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setSheet(
                            () => _selectedMethod = m[0] as String),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: EdgeInsets.only(
                              right: m[0] != 'inPerson' ? 8 : 0),
                          padding: const EdgeInsets.symmetric(
                              vertical: 12),
                          decoration: BoxDecoration(
                            color: _selectedMethod == m[0]
                                ? _teal
                                : _bg,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: _selectedMethod == m[0]
                                    ? _teal
                                    : _border),
                          ),
                          child: Column(
                            children: [
                              Icon(m[1] as IconData,
                                  color: _selectedMethod == m[0]
                                      ? Colors.white
                                      : _textMid,
                                  size: 20),
                              const SizedBox(height: 4),
                              Text(
                                _aptMethod(ctx, m[0] as String),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _selectedMethod == m[0]
                                      ? Colors.white
                                      : _textMid,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ]),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.appointmentRequestSent),
                        backgroundColor: _teal,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(l.bookNewAppointmentButton,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Booking Confirm Sheet ─────────────────────────────────────────────────

  void _showBookingConfirmation(Map<String, String> counsellor) {
    final l = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
        decoration: const BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _handle(),

            // Counsellor hero
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 22),
              decoration: BoxDecoration(
                  color: _tealLight, borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Text(counsellor['emoji']!,
                      style: const TextStyle(fontSize: 52)),
                  const SizedBox(height: 8),
                  Text(counsellor['name']!,
                      style: const TextStyle(
                          color: _textDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w800)),
                  Text(counsellor['specialty']!,
                      style: const TextStyle(
                          color: _textMid, fontSize: 13)),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Availability + rating
            _detailCard([
              _detailRow(Icons.schedule_rounded, l.available,
                  counsellor['available']!, _teal, _tealLight),
              _detailRow(Icons.star_rounded, 'Rating',
                  '${counsellor['rating']} / 5.0', _gold, _goldLight,
                  isLast: true),
            ]),
            const SizedBox(height: 14),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  color: _sageLight,
                  borderRadius: BorderRadius.circular(14)),
              child: Text(
                l.confirmationSent,
                style: const TextStyle(
                    color: Color(0xFF5A8A60), fontSize: 13, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),

            Row(children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _textMid,
                    side: const BorderSide(color: _border),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(l.cancelLabel,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l.appointmentBookedWith(
                            counsellor['name']!)),
                        backgroundColor: _sage,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _sage,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: Text(l.confirmBooking,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // ── Appointment Card ──────────────────────────────────────────────────────

  Widget _buildAppointmentCard(
      Map<String, dynamic> apt, int index, AppLocalizations l) {
    final accent    = _accentCycle[index % _accentCycle.length][0];
    final light     = _accentCycle[index % _accentCycle.length][1];
    final confirmed = _isConfirmed(context, apt['statusKey'] as String);

    return GestureDetector(
      onTap: () => _showAppointmentDetails(apt, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top strip
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: accent,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(22)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon bubble
                      Container(
                        width: 48, height: 48,
                        decoration: BoxDecoration(
                            color: light,
                            borderRadius: BorderRadius.circular(14)),
                        child: Icon(apt['icon'] as IconData,
                            color: accent, size: 24),
                      ),
                      const SizedBox(width: 12),

                      // Type & counsellor
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                _aptType(context, apt['typeKey'] as String),
                                style: const TextStyle(
                                    color: _textDark,
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3)),
                            const SizedBox(height: 3),
                            Text('${l.withLabel} ${apt['counsellor']}',
                                style: const TextStyle(
                                    color: _textMid, fontSize: 12.5)),
                          ],
                        ),
                      ),

                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: confirmed ? _sageLight : _peachLight,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _aptStatus(context, apt['statusKey'] as String),
                          style: TextStyle(
                            color: confirmed ? _sage : _peach,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Divider(height: 1, color: _border),
                  const SizedBox(height: 10),

                  // Date / time / method row
                  Row(children: [
                    _infoChip(Icons.calendar_today_rounded,
                        apt['date'] as String, accent, light),
                    const SizedBox(width: 8),
                    _infoChip(Icons.access_time_rounded,
                        apt['time'] as String, accent, light),
                  ]),
                  const SizedBox(height: 8),
                  Row(children: [
                    Icon(_methodIcon(apt['methodKey'] as String),
                        color: accent, size: 14),
                    const SizedBox(width: 5),
                    Text(
                        _aptMethod(
                            context, apt['methodKey'] as String),
                        style: TextStyle(
                            color: accent,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Row(children: [
                      Text('Details',
                          style: TextStyle(
                              color: accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(width: 3),
                      Icon(Icons.arrow_forward_rounded,
                          color: accent, size: 13),
                    ]),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label, Color accent, Color light) =>
      Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: light, borderRadius: BorderRadius.circular(20)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: accent, size: 12),
            const SizedBox(width: 4),
            Text(label,
                style: TextStyle(
                    color: accent,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      );

  // ── Counsellor Card ───────────────────────────────────────────────────────

  Widget _buildCounsellorCard(Map<String, String> c, int index) {
    final accent = _accentCycle[index % _accentCycle.length][0];
    final light  = _accentCycle[index % _accentCycle.length][1];

    return GestureDetector(
      onTap: () => _showBookingConfirmation(c),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left strip
            Container(
              width: 5, height: 80,
              decoration: BoxDecoration(
                color: accent,
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(20)),
              ),
            ),
            const SizedBox(width: 14),

            // Emoji
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                  color: light, borderRadius: BorderRadius.circular(14)),
              child: Center(
                child: Text(c['emoji']!,
                    style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c['name']!,
                        style: const TextStyle(
                            color: _textDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(c['specialty']!,
                        style: const TextStyle(
                            color: _textMid, fontSize: 12.5)),
                    const SizedBox(height: 5),
                    Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                            color: _goldLight,
                            borderRadius: BorderRadius.circular(20)),
                        child: Row(children: [
                          Icon(Icons.star_rounded,
                              color: _gold, size: 12),
                          const SizedBox(width: 3),
                          Text(c['rating']!,
                              style: TextStyle(
                                  color: _gold,
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700)),
                        ]),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.schedule_rounded,
                          color: _textLight, size: 12),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(c['available']!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: accent,
                                fontSize: 11,
                                fontWeight: FontWeight.w600)),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14),
              child: Icon(Icons.arrow_forward_rounded,
                  color: accent, size: 18),
            ),
          ],
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: _surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l.appointmentsAndBooking,
            style: const TextStyle(
                color: _textDark,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => _showBookingSheet(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                    color: _teal,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(children: const [
                  Icon(Icons.add_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 4),
                  Text('Book',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700)),
                ]),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: _border),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ── Stats Row ────────────────────────────────────────────────
              _card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statPill('1', l.upcoming, _teal),
                      Container(width: 1, height: 36, color: _border),
                      _statPill('2', l.thisWeek, _sage),
                      Container(width: 1, height: 36, color: _border),
                      _statPill('12', l.completed, _lavender),
                    ],
                  ),
                ),
              ),

              // ── Scheduled Sessions ───────────────────────────────────────
              _sectionHeader(l.scheduledSessions,
                  Icons.event_rounded, _teal, _tealLight),
              ..._appointments.asMap().entries.map(
                    (e) => _buildAppointmentCard(e.value, e.key, l),
                  ),
              const SizedBox(height: 4),

              // ── Book New Appointment ─────────────────────────────────────
              _sectionHeader(l.bookNewAppointment,
                  Icons.person_search_rounded, _sage, _sageLight),
              ..._counsellors.asMap().entries.map(
                    (e) => _buildCounsellorCard(e.value, e.key),
                  ),
              const SizedBox(height: 4),

              // ── Cancellation Policy ──────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: _goldLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _gold.withOpacity(0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.info_outline_rounded,
                          color: _gold, size: 18),
                      const SizedBox(width: 8),
                      Text(l.cancellationPolicy,
                          style: const TextStyle(
                              color: _textDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                    ]),
                    const SizedBox(height: 10),
                    Text(l.cancellationPolicyText,
                        style: const TextStyle(
                            color: _textMid,
                            fontSize: 13,
                            height: 1.55)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statPill(String value, String label, Color color) => Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  height: 1)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(
                  color: _textLight, fontSize: 11.5)),
        ],
      );
}