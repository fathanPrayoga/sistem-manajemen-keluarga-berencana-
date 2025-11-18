import 'package:flutter/material.dart';
import '../style/colors.dart';
import '../style/text_style.dart';

class ChatKonsultasiPage extends StatefulWidget {
  final String title;

  const ChatKonsultasiPage({super.key, required this.title});

  @override
  State<ChatKonsultasiPage> createState() => _ChatKonsultasiPageState();
}

class _ChatKonsultasiPageState extends State<ChatKonsultasiPage> {
  final TextEditingController _textController = TextEditingController();
  final List<Widget> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.add(
      _buildConsultantMessage(
        context,
        'Halo, Selamat siang. Silakan ceritakan kondisi atau keluhan yang sedang Anda alami. Saya akan membantu sebisa mungkin dalam sesi konsultasi ini.',
      ),
    );
    _messages.add(const SizedBox(height: 10));
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(_buildUserMessage(context, text));
      _messages.add(const SizedBox(height: 10));
    });

    _textController.clear();
  }

  Widget _buildConsultantMessage(BuildContext context, String text) {
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.textDark),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserMessage(BuildContext context, String text) {
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.background,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey,
          child: Icon(Icons.person, color: AppColors.background),
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
            child: SingleChildScrollView(
              reverse: true,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _messages,
              ),
            ),
          ),
          _buildMessageInput(context),
        ],
      ),
    );
  }
}
