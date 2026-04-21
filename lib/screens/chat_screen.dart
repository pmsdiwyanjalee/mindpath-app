import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with TickerProviderStateMixin {
  final _messageController   = TextEditingController();
  final _scrollController    = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;
  
  // Selected counsellor
  Map<String, dynamic> _selectedCounsellor = {};
  bool _showSelector = false;

  // Counsellors list
  final List<Map<String, dynamic>> _counsellors = [
    {
      'id': 1,
      'name': 'Dr. Sarah Johnson',
      'title': 'Clinical Psychologist & Addiction Specialist',
      'specialties': ['Substance Abuse', 'Anxiety', 'Trauma'],
      'experience': '12+ years',
      'bio': 'Dr. Johnson specializes in evidence-based treatments for addiction recovery, including CBT and motivational interviewing.',
      'rating': 4.9,
      'reviews': 128,
      'imageIcon': Icons.person_rounded,
      'color': Color(0xFF7CA982),
      'isOnline': true,
      'greeting': 'Hello! I\'m Dr. Sarah Johnson. I specialize in addiction recovery and anxiety management. How are you feeling today?',
    },
    {
      'id': 2,
      'name': 'Michael Chen, LCSW',
      'title': 'Licensed Clinical Social Worker',
      'specialties': ['Dual Diagnosis', 'Family Therapy', 'Relapse Prevention'],
      'experience': '8+ years',
      'bio': 'Michael brings a compassionate, client-centered approach to recovery. He specializes in working with individuals facing co-occurring mental health conditions.',
      'rating': 4.8,
      'reviews': 94,
      'imageIcon': Icons.person_rounded,
      'color': Color(0xFF4A9EAF),
      'isOnline': true,
      'greeting': 'Hi there! I\'m Michael Chen. I focus on dual diagnosis and family therapy. What\'s on your mind today?',
    },
    {
      'id': 3,
      'name': 'Dr. Emily Rodriguez',
      'title': 'Psychiatrist & Addiction Medicine',
      'specialties': ['Medication Management', 'Co-occurring Disorders', 'Crisis Intervention'],
      'experience': '15+ years',
      'bio': 'Dr. Rodriguez is board-certified in both Psychiatry and Addiction Medicine. She offers medication-assisted treatment alongside therapeutic support.',
      'rating': 4.95,
      'reviews': 203,
      'imageIcon': Icons.medical_services_rounded,
      'color': Color(0xFFE8926A),
      'isOnline': false,
      'greeting': 'Hello, I\'m Dr. Emily Rodriguez. I specialize in medication management and crisis intervention. I\'ll respond as soon as I\'m available.',
    },
    {
      'id': 4,
      'name': 'David Okonkwo, MA',
      'title': 'Certified Addiction Counselor',
      'specialties': ['Recovery Coaching', 'Life Skills', 'Motivation Enhancement'],
      'experience': '10+ years',
      'bio': 'David is a person in long-term recovery who brings lived experience to his counseling approach.',
      'rating': 4.85,
      'reviews': 156,
      'imageIcon': Icons.person_rounded,
      'color': Color(0xFF9B8EC4),
      'isOnline': true,
      'greeting': 'Hey! I\'m David. As someone in recovery myself, I understand the journey. How can I support you today?',
    },
    {
      'id': 5,
      'name': 'Dr. Lisa Thompson',
      'title': 'Clinical Psychologist',
      'specialties': ['Cognitive Behavioral Therapy', 'Mindfulness', 'Stress Management'],
      'experience': '9+ years',
      'bio': 'Dr. Thompson integrates mindfulness-based approaches with traditional CBT to help clients develop healthier coping mechanisms.',
      'rating': 4.9,
      'reviews': 112,
      'imageIcon': Icons.person_rounded,
      'color': Color(0xFFF4C542),
      'isOnline': false,
      'greeting': 'Hello, I\'m Dr. Lisa Thompson. I focus on CBT and mindfulness techniques. I look forward to connecting with you soon.',
    },
    {
      'id': 6,
      'name': 'Rachel Green, LPC',
      'title': 'Licensed Professional Counselor',
      'specialties': ['Young Adult Recovery', 'Relationship Issues', 'Self-Esteem'],
      'experience': '7+ years',
      'bio': 'Rachel specializes in working with young adults navigating recovery while managing career, relationships, and identity development.',
      'rating': 4.75,
      'reviews': 87,
      'imageIcon': Icons.person_rounded,
      'color': Color(0xFF7CA982),
      'isOnline': true,
      'greeting': 'Hi! I\'m Rachel Green. I specialize in young adult recovery and relationship issues. What would you like to talk about?',
    },
  ];

  // Dot animation controllers for typing indicator
  late List<AnimationController> _dotControllers;
  late List<Animation<double>>   _dotAnims;

  // ── Palette ───────────────────────────────────────────────────────────────
  static const Color _bg         = Color(0xFFF6F4F0);
  static const Color _surface    = Color(0xFFFFFFFF);
  static const Color _sage       = Color(0xFF7CA982);
  static const Color _sageLight  = Color(0xFFD4EAD7);
  static const Color _teal       = Color(0xFF4A9EAF);
  static const Color _tealLight  = Color(0xFFD6EEF3);
  static const Color _peach      = Color(0xFFE8926A);
  static const Color _peachLight = Color(0xFFFAE2D5);
  static const Color _textDark   = Color(0xFF2D3142);
  static const Color _textMid    = Color(0xFF6B7180);
  static const Color _textLight  = Color(0xFF9CA3AF);
  static const Color _border     = Color(0xFFE8E5E0);

  List<String> get _quickReplies => [
    'I\'m having cravings',
    'Need coping strategies',
    'Feeling triggered',
    'Worried about relapse',
    'Proud of my progress',
  ];

  @override
  void initState() {
    super.initState();
    
    // Set default counsellor (first one)
    _selectedCounsellor = _counsellors[0];
    
    // Initialize typing animation controllers
    _dotControllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      )..repeat(reverse: true),
    );
    _dotAnims = _dotControllers.asMap().entries.map((e) {
      Future.delayed(Duration(milliseconds: e.key * 150), () {
        if (mounted) e.value.repeat(reverse: true);
      });
      return Tween<double>(begin: 0, end: -6).animate(
        CurvedAnimation(parent: e.value, curve: Curves.easeInOut),
      );
    }).toList();

    // Initialize chat with greeting from selected counsellor
    _initializeChat();
  }

  void _initializeChat() {
    _messages = [
      {
        'text': _selectedCounsellor['greeting'],
        'isMe': false,
        'time': _timestamp(),
        'status': 'read'
      },
    ];
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    for (final c in _dotControllers) c.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _timestamp() {
    final now = DateTime.now();
    final h   = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final m   = now.minute.toString().padLeft(2, '0');
    final ap  = now.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ap';
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isMe': true, 'time': _timestamp(), 'status': 'sent'});
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();
    
    // Simulate counsellor response based on message content
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      String response = _getResponseForMessage(text);
      setState(() {
        _messages.add({'text': response, 'isMe': false, 'time': _timestamp(), 'status': 'read'});
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  String _getResponseForMessage(String message) {
    final lowerMsg = message.toLowerCase();
    final counsellorName = _selectedCounsellor['name'].split(' ').first;
    
    if (lowerMsg.contains('craving') || lowerMsg.contains('urge')) {
      return 'I understand cravings can be intense, $counsellorName here. Let\'s try some grounding techniques. Take 5 deep breaths with me. Would you like me to suggest some distraction activities?';
    } else if (lowerMsg.contains('trigger') || lowerMsg.contains('stress')) {
      return 'Identifying triggers is so important. Can you tell me more about what triggered you? Remember, you have coping strategies that work - let\'s review them together.';
    } else if (lowerMsg.contains('relapse') || lowerMsg.contains('worry')) {
      return 'It\'s normal to have these concerns. Let\'s focus on what you can control right now. Have you reached out to your support network? You don\'t have to go through this alone.';
    } else if (lowerMsg.contains('proud') || lowerMsg.contains('progress')) {
      return 'That\'s wonderful to hear! Celebrating progress is so important for recovery. What specifically are you proud of today? Every small victory matters!';
    } else if (lowerMsg.contains('sad') || lowerMsg.contains('depress')) {
      return 'I hear that you\'re feeling down. Your feelings are valid. Would you like to talk about what\'s been going on? Sometimes sharing can lighten the load.';
    } else if (lowerMsg.contains('anxious') || lowerMsg.contains('nervous')) {
      return 'Anxiety can be challenging. Let\'s try a quick breathing exercise together. Breathe in for 4 counts, hold for 4, exhale for 4. How does that feel?';
    } else if (lowerMsg.contains('thanks') || lowerMsg.contains('thank you')) {
      return 'You\'re very welcome! I\'m here whenever you need support. Remember, recovery is a journey, and every step counts. 💙';
    } else {
      return 'Thank you for sharing that with me. It takes courage to open up. Based on what you\'ve shared, would you like to explore coping strategies together, or would you prefer to talk more about how you\'re feeling?';
    }
  }

  void _sendQuickReply(String reply) {
    setState(() {
      _messages.add({'text': reply, 'isMe': true, 'time': _timestamp(), 'status': 'sent'});
      _isTyping = true;
    });
    _scrollToBottom();
    
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      String response = _getResponseForMessage(reply);
      setState(() {
        _messages.add({'text': response, 'isMe': false, 'time': _timestamp(), 'status': 'read'});
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _changeCounsellor(Map<String, dynamic> counsellor) {
    setState(() {
      _selectedCounsellor = counsellor;
      _showSelector = false;
      _initializeChat();
    });
    _scrollToBottom();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Now chatting with ${counsellor['name']}'),
        backgroundColor: counsellor['color'],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Emergency Support', style: TextStyle(color: _peach, fontWeight: FontWeight.w800)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('If this is a life-threatening emergency, please call 911 immediately.'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _peachLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildEmergencyNumber('988', 'Suicide & Crisis Lifeline'),
                  const SizedBox(height: 8),
                  _buildEmergencyNumber('1-800-662-4357', 'SAMHSA Helpline'),
                  const SizedBox(height: 8),
                  _buildEmergencyNumber('1-800-950-6264', 'NAMI Helpline'),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: _textMid)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyNumber(String number, String description) {
    return Row(
      children: [
        Icon(Icons.phone_rounded, color: _peach, size: 16),
        const SizedBox(width: 8),
        Text(number, style: TextStyle(color: _peach, fontWeight: FontWeight.w700)),
        const SizedBox(width: 8),
        Text(description, style: TextStyle(color: _textMid, fontSize: 12)),
      ],
    );
  }

  // ── Message Bubble ────────────────────────────────────────────────────────

  Widget _buildMessageBubble(
      String text, bool isMe, String time, String status) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? _teal : _surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: isMe
                      ? const Radius.circular(20)
                      : const Radius.circular(4),
                  bottomRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isMe ? 0.12 : 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : _textDark,
                  fontSize: 14.5,
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(time,
                      style: const TextStyle(
                          color: _textLight, fontSize: 10.5)),
                  if (isMe) ...[
                    const SizedBox(width: 4),
                    Icon(
                      status == 'read'
                          ? Icons.done_all_rounded
                          : Icons.done_rounded,
                      color: status == 'read' ? _teal : _textLight,
                      size: 13,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Typing Indicator ──────────────────────────────────────────────────────

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${_selectedCounsellor['name'].split(' ').first} is typing',
                style: const TextStyle(color: _textLight, fontSize: 12.5)),
            const SizedBox(width: 10),
            Row(
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _dotAnims[i],
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, _dotAnims[i].value),
                    child: Container(
                      width: 6, height: 6,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                          color: _teal, shape: BoxShape.circle),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── Counsellor Selector Modal ────────────────────────────────────────────

  void _openCounsellorSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
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
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.chat_rounded, color: _teal, size: 24),
                    const SizedBox(width: 12),
                    const Text(
                      'Select a Counsellor',
                      style: TextStyle(
                        color: _textDark,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _counsellors.length,
                  itemBuilder: (context, index) {
                    final counsellor = _counsellors[index];
                    final isSelected = _selectedCounsellor['id'] == counsellor['id'];
                    return _buildCounsellorOption(counsellor, isSelected);
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounsellorOption(Map<String, dynamic> counsellor, bool isSelected) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        _changeCounsellor(counsellor);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? (counsellor['color'] as Color).withOpacity(0.1) : _bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? counsellor['color'] : _border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: counsellor['color'],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    counsellor['imageIcon'],
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                if (counsellor['isOnline'] == true)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _sage,
                        shape: BoxShape.circle,
                        border: Border.all(color: _surface, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        counsellor['name'],
                        style: const TextStyle(
                          color: _textDark,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: (counsellor['color'] as Color).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          counsellor['rating'].toString(),
                          style: TextStyle(
                            color: counsellor['color'],
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    counsellor['title'],
                    style: const TextStyle(
                      color: _textMid,
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    children: (counsellor['specialties'] as List<String>).take(2).map((specialty) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _border,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          specialty,
                          style: const TextStyle(
                            color: _textLight,
                            fontSize: 9,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: counsellor['color'], size: 24)
            else if (counsellor['isOnline'] == true)
              Icon(Icons.circle_rounded, color: _sage, size: 12)
            else
              Icon(Icons.circle_rounded, color: _textLight, size: 12),
          ],
        ),
      ),
    );
  }

  // ── Date Separator ────────────────────────────────────────────────────────

  Widget _dateSeparator(String label) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            const Expanded(child: Divider()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: _border,
                    borderRadius: BorderRadius.circular(20)),
                child: Text(label,
                    style: const TextStyle(
                        color: _textLight,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            const Expanded(child: Divider()),
          ],
        ),
      );

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isOnline = _selectedCounsellor['isOnline'] as bool;
    final counsellorColor = _selectedCounsellor['color'] as Color;

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
        title: GestureDetector(
          onTap: _openCounsellorSelector,
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: counsellorColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _selectedCounsellor['imageIcon'],
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  Positioned(
                    bottom: 1, right: 1,
                    child: Container(
                      width: 10, height: 10,
                      decoration: BoxDecoration(
                        color: isOnline ? _sage : _textLight,
                        shape: BoxShape.circle,
                        border: Border.all(color: _surface, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _selectedCounsellor['name'],
                        style: const TextStyle(
                          color: _textDark,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_drop_down_rounded,
                        color: _textMid,
                        size: 20,
                      ),
                    ],
                  ),
                  Text(
                    isOnline ? 'Online · Tap to change' : 'Offline · Tap to change',
                    style: TextStyle(
                      color: isOnline ? _sage : _textLight,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: _showEmergencyDialog,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                    color: _peachLight,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  Icon(Icons.warning_rounded, color: _peach, size: 15),
                  const SizedBox(width: 4),
                  Text('SOS',
                      style: TextStyle(
                          color: _peach,
                          fontSize: 12,
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
      body: Column(
        children: [
          // ── Message List ─────────────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              itemCount: _messages.length + (_isTyping ? 2 : 1),
              itemBuilder: (context, index) {
                // Date separator at top
                if (index == 0) return _dateSeparator('Today');

                final msgIndex = index - 1;

                // Typing indicator
                if (msgIndex == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }

                if (msgIndex >= _messages.length) {
                  return const SizedBox.shrink();
                }

                final msg = _messages[msgIndex];
                return _buildMessageBubble(
                  msg['text'] as String,
                  msg['isMe'] as bool,
                  msg['time'] as String,
                  msg['status'] as String,
                );
              },
            ),
          ),

          // ── Quick Replies ────────────────────────────────────────────────
          Container(
            color: _surface,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: SizedBox(
              height: 34,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _quickReplies.length,
                itemBuilder: (_, i) {
                  return GestureDetector(
                    onTap: () => _sendQuickReply(_quickReplies[i]),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: _tealLight,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _teal.withOpacity(0.3)),
                      ),
                      child: Text(
                        _quickReplies[i],
                        style: TextStyle(
                            color: _teal,
                            fontSize: 12,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Divider(height: 1, color: _border),

          // ── Input Bar ────────────────────────────────────────────────────
          Container(
            color: _surface,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: _border),
                    ),
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(
                          color: _textDark, fontSize: 14.5),
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Type your message here...',
                        hintStyle: const TextStyle(
                            color: _textLight, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 46, height: 46,
                    decoration: BoxDecoration(
                      color: counsellorColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: counsellorColor.withOpacity(0.35),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
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