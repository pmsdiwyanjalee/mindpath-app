import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../l10n/app_localizations_fallback.dart';

class ChatScreen extends StatefulWidget {
  // ignore: use_super_parameters
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _messageController = TextEditingController();
  List<Map<String, dynamic>> _messages = [];
  bool _isTyping = false;

  List<String> get _quickReplies {
    final localizations = AppLocalizations.of(context)!;
    return [
      localizations.quickReplyCravings,
      localizations.quickReplyCopingStrategies,
      localizations.quickReplyTriggered,
      localizations.quickReplyRelapse,
      localizations.quickReplyProud,
    ];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_messages.isEmpty) {
      final localizations = AppLocalizations.of(context)!;
      _messages = [
        {
          'text': localizations.chatGreeting,
          'isMe': false,
          'time': '10:30 AM',
          'status': 'read'
        },
        {
          'text': localizations.chatFeelingAnxious,
          'isMe': true,
          'time': '10:32 AM',
          'status': 'read'
        },
        {
          'text': localizations.chatResponseWorkStress,
          'isMe': false,
          'time': '10:33 AM',
          'status': 'read'
        },
        {
          'text': localizations.chatPresentationWorry,
          'isMe': true,
          'time': '10:35 AM',
          'status': 'read'
        },
        {
          'text': localizations.chatPreppingAnxiety,
          'isMe': false,
          'time': '10:36 AM',
          'status': 'read'
        },
      ];
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      final now = DateTime.now();
      final time =
          '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
      setState(() {
        _messages.add({
          'text': _messageController.text.trim(),
          'isMe': true,
          'time': time,
          'status': 'sent'
        });
        _isTyping = true;
      });
      _messageController.clear();
      // Simulate counsellor response
      Future.delayed(const Duration(seconds: 3), () {
        final responseTime = DateTime.now();
        final responseTimeStr =
            '${responseTime.hour}:${responseTime.minute.toString().padLeft(2, '0')} ${responseTime.hour >= 12 ? 'PM' : 'AM'}';
        // ignore: use_build_context_synchronously
        final localizations = AppLocalizations.of(context)!;
        setState(() {
          _messages.add({
            'text': localizations.chatFollowUpResponse,
            'isMe': false,
            'time': responseTimeStr,
            'status': 'read'
          });
          _isTyping = false;
        });
      });
    }
  }

  void _sendQuickReply(String reply) {
    final now = DateTime.now();
    final time =
        '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
    setState(() {
      _messages
          .add({'text': reply, 'isMe': true, 'time': time, 'status': 'sent'});
      _isTyping = true;
    });
    // Simulate response
    Future.delayed(const Duration(seconds: 2), () {
      final responseTime = DateTime.now();
      final responseTimeStr =
          '${responseTime.hour}:${responseTime.minute.toString().padLeft(2, '0')} ${responseTime.hour >= 12 ? 'PM' : 'AM'}';
      // ignore: use_build_context_synchronously
      final localizations = AppLocalizations.of(context)!;
      setState(() {
        _messages.add({
          'text': localizations.chatAutoResponse,
          'isMe': false,
          'time': responseTimeStr,
          'status': 'read'
        });
        _isTyping = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF051A3F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF051A3F),
        elevation: 0,
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFF255BFF),
                  child: Icon(Icons.person, color: Colors.white, size: 16),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Text(localizations.counsellorSarah,
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning, color: Colors.redAccent),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(localizations.emergencyContactInitiated)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping) {
                  return _buildTypingIndicator(context);
                }
                final message = _messages[index];
                return _buildMessageBubble(message['text'], message['isMe'],
                    message['time'], message['status']);
              },
            ),
          ),
          // Quick Replies
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            color: const Color(0xFF0C234E),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _quickReplies.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: ActionChip(
                    label: Text(_quickReplies[index],
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12)),
                    backgroundColor: const Color(0xFF1B3575),
                    onPressed: () => _sendQuickReply(_quickReplies[index]),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF0C234E),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: localizations.shareFeelingHint,
                      hintStyle: const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: const Color(0xFF1B3575),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFF2C74FF),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
      String text, bool isMe, String time, String status) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF2C74FF) : const Color(0xFF1B3575),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                isMe ? const Radius.circular(16) : const Radius.circular(4),
            bottomRight:
                isMe ? const Radius.circular(4) : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    status == 'read' ? Icons.done_all : Icons.done,
                    color:
                        status == 'read' ? Colors.blueAccent : Colors.white70,
                    size: 12,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: const BoxDecoration(
          color: Color(0xFF1B3575),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(localizations.counsellorTyping,
                style: const TextStyle(color: Colors.white70, fontSize: 12)),
            const SizedBox(width: 8),
            SizedBox(
              width: 20,
              height: 10,
              child: Row(
                children: List.generate(
                    3,
                    (index) => Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: const BoxDecoration(
                            color: Colors.white70,
                            shape: BoxShape.circle,
                          ),
                        )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
