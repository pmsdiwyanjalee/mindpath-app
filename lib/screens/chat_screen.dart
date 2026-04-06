import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../l10n/app_localizations_fallback.dart';

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

  // Dot animation controllers
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

  List<String> get _quickReplies {
    final l = AppLocalizations.of(context)!;
    return [
      l.quickReplyCravings,
      l.quickReplyCopingStrategies,
      l.quickReplyTriggered,
      l.quickReplyRelapse,
      l.quickReplyProud,
    ];
  }

  @override
  void initState() {
    super.initState();
    // Three bouncing dots for typing indicator
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messages.isEmpty) {
      final l = AppLocalizations.of(context)!;
      _messages = [
        {'text': l.chatGreeting,            'isMe': false, 'time': '10:30 AM', 'status': 'read'},
        {'text': l.chatFeelingAnxious,      'isMe': true,  'time': '10:32 AM', 'status': 'read'},
        {'text': l.chatResponseWorkStress,  'isMe': false, 'time': '10:33 AM', 'status': 'read'},
        {'text': l.chatPresentationWorry,   'isMe': true,  'time': '10:35 AM', 'status': 'read'},
        {'text': l.chatPreppingAnxiety,     'isMe': false, 'time': '10:36 AM', 'status': 'read'},
      ];
    }
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
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      final l = AppLocalizations.of(context)!;
      setState(() {
        _messages.add({'text': l.chatFollowUpResponse, 'isMe': false, 'time': _timestamp(), 'status': 'read'});
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _sendQuickReply(String reply) {
    setState(() {
      _messages.add({'text': reply, 'isMe': true, 'time': _timestamp(), 'status': 'sent'});
      _isTyping = true;
    });
    _scrollToBottom();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final l = AppLocalizations.of(context)!;
      setState(() {
        _messages.add({'text': l.chatAutoResponse, 'isMe': false, 'time': _timestamp(), 'status': 'read'});
        _isTyping = false;
      });
      _scrollToBottom();
    });
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

  Widget _buildTypingIndicator(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
            Text(l.counsellorTyping,
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
                      margin:
                          const EdgeInsets.symmetric(horizontal: 2),
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
        title: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF7CA982), Color(0xFF4A9EAF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person_rounded,
                      color: Colors.white, size: 22),
                ),
                Positioned(
                  bottom: 1, right: 1,
                  child: Container(
                    width: 10, height: 10,
                    decoration: BoxDecoration(
                      color: _sage,
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
                Text(l.counsellorSarah,
                    style: const TextStyle(
                        color: _textDark,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700)),
                Text('Online · Counsellor',
                    style: TextStyle(
                        color: _sage,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l.emergencyContactInitiated),
                    backgroundColor: _peach,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              },
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
              itemCount:
                  _messages.length + (_isTyping ? 2 : 1),
              itemBuilder: (context, index) {
                // Date separator at top
                if (index == 0) return _dateSeparator('Today');

                final msgIndex = index - 1;

                // Typing indicator
                if (msgIndex == _messages.length && _isTyping) {
                  return _buildTypingIndicator(context);
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
                        hintText: l.shareFeelingHint,
                        hintStyle: const TextStyle(
                            color: _textLight, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(
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
                      color: _teal,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _teal.withOpacity(0.35),
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