import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../style/colors.dart';
import '../style/text_style.dart';
import '../services/konsultasi_service.dart';

class ChatKonsultasiPage extends StatefulWidget {
  final String title;
  final String categoryId;

  const ChatKonsultasiPage({
    super.key,
    required this.title,
    required this.categoryId,
  });

  @override
  State<ChatKonsultasiPage> createState() => _ChatKonsultasiPageState();
}

class _ChatKonsultasiPageState extends State<ChatKonsultasiPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final KonsultasiService _service = KonsultasiService();
  String? _userId;
  String? _userName;
  DateTime? _lastReadTime;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _userId = user?.uid;

    // Try to fetch display name and NIK from users collection
    if (_userId != null) {
      // 1. Fetch User Data
      FirebaseFirestore.instance.collection('users').doc(_userId).get().then((
        doc,
      ) {
        if (doc.exists) {
          final data = doc.data() ?? {};
          if (mounted) {
            setState(() {
              _userName = data['name'] ?? _userName;
            });
          }
        }
      });

      // 2. Fetch Last Read Time & Mark as Read
      _initializeReadStatus();
    }
  }

  Future<void> _initializeReadStatus() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('konsultasi')
          .doc(widget.categoryId)
          .collection('chats')
          .doc(_userId)
          .get();

      if (doc.exists && mounted) {
        final data = doc.data();
        if (data != null) {
          final dynamic ts = data['lastReadTimestampUser'];
          if (ts is Timestamp) {
            setState(() {
              _lastReadTime = ts.toDate();
            });
          }
        }
      }

      // Mark as read immediately after fetching status
      if (mounted) {
        await _service.markAsRead(widget.categoryId, _userId!);
      }
    } catch (e) {
      debugPrint('Error initializing read status: $e');
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _formatTimestamp(dynamic ts) {
    if (ts == null) return '';
    DateTime dt;
    if (ts is Timestamp) {
      dt = ts.toDate();
    } else if (ts is int) {
      dt = DateTime.fromMillisecondsSinceEpoch(ts);
    } else if (ts is DateTime) {
      dt = ts;
    } else {
      return '';
    }

    try {
      return DateFormat.Hm().format(dt); // e.g., 14:35
    } catch (e) {
      return '';
    }
  }

  Future<void> _handleSubmitted(String text) async {
    if (text.trim().isEmpty || _userId == null) return;

    // Ensure NIK is loaded (though Guard in Dashboard should guarantee it)
    // If null, we might send empty string or handle error.
    // For now, defaulting to empty string if not loaded yet to prevent crash.

    await _service.sendMessage(
      widget.categoryId,
      _userId!,
      _userName ?? 'User',
      text.trim(),
    );
    _textController.clear();

    // Scroll to bottom after short delay
    Future.delayed(const Duration(milliseconds: 250), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildMessageItem(Map<String, dynamic> data) {
    final senderId = data['senderId'] as String? ?? '';
    final text = data['text'] as String? ?? '';
    final senderName = data['senderName'] as String? ?? '';
    final timestamp = data['timestamp'];
    final formattedTs = _formatTimestamp(timestamp);

    if (senderId == _userId) {
      return _buildUserMessage(context, text, formattedTs);
    } else {
      return _buildConsultantMessage(context, text, senderName, formattedTs);
    }
  }

  Widget _buildConsultantMessage(
    BuildContext context,
    String text,
    String senderName,
    String timestamp,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.secondary,
          child: Image.asset(
            'assets/images/logo_pemkot.png',
            width: 35,
            height: 35,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            margin: const EdgeInsets.only(right: 50, top: 4),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.zero,
                topRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              border: Border.all(color: AppColors.primary, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  senderName,
                  style: AppTextStyles.caption.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textDark,
                  ),
                ),
                if (timestamp.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      timestamp,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 9,
                        color: AppColors.textDark.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserMessage(
    BuildContext context,
    String text,
    String timestamp,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            margin: const EdgeInsets.only(left: 50, top: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.zero,
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.background,
                  ),
                ),
                if (timestamp.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    timestamp,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 9,
                      color: AppColors.background.withOpacity(0.85),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          child: Text(
            (_userName != null && _userName!.isNotEmpty)
                ? _userName![0].toUpperCase()
                : '?',
            style: const TextStyle(
              color: AppColors.background,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageInput(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: AppColors.primaryLight.withOpacity(0.5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: AppColors.primary, width: 1),
              ),
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration(
                  hintText: 'Ketik di sini...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.send,
                color: AppColors.background,
                size: 24,
              ),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        toolbarHeight: 50,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.background,
            size: 28,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.background,
              child: Image.asset(
                'assets/images/logo_pemkot.png',
                width: 30,
                height: 30,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.title,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.headline2.copyWith(
                  fontSize: 20,
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _userId == null
                  ? const Stream.empty()
                  : _service.messagesStream(widget.categoryId, _userId!),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Terjadi kesalahan: \\${snapshot.error}'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount: docs.length,
                  shrinkWrap: true,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;

                    // Logic for Unread Divider
                    bool showDivider = false;
                    if (_lastReadTime != null) {
                      final dynamic ts = data['timestamp'];
                      DateTime? msgTime;
                      if (ts is Timestamp)
                        msgTime = ts.toDate();
                      else if (ts is DateTime)
                        msgTime = ts;

                      if (msgTime != null && msgTime.isAfter(_lastReadTime!)) {
                        // Check previous message
                        if (index == 0) {
                          showDivider = true;
                        } else {
                          final prevData =
                              docs[index - 1].data() as Map<String, dynamic>;
                          final dynamic prevTs = prevData['timestamp'];
                          DateTime? prevTime;
                          if (prevTs is Timestamp)
                            prevTime = prevTs.toDate();
                          else if (prevTs is DateTime)
                            prevTime = prevTs;

                          if (prevTime != null &&
                              !prevTime.isAfter(_lastReadTime!)) {
                            showDivider = true;
                          }
                        }
                      }
                    }

                    final messageWidget = _buildMessageItem(data);

                    if (showDivider) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(color: Colors.red[200]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: Text(
                                    'Pesan Belum Terbaca',
                                    style: TextStyle(
                                      color: Colors.red[300],
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(color: Colors.red[200]),
                                ),
                              ],
                            ),
                          ),
                          messageWidget,
                        ],
                      );
                    }

                    return messageWidget;
                  },
                );
              },
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }
}
