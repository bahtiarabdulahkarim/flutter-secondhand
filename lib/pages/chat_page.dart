import 'package:chatview/chatview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String? vehicleName;
  final String? initialMessage;

  const ChatPage({super.key, this.vehicleName, this.initialMessage});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatController _chatController;
  late TextEditingController _templateController;

  static const String adminId = 'admin_secondhand';

  late final ChatUser currentUser;

  final ChatUser admin = ChatUser(id: adminId, name: 'Admin SecondHand');

  bool _showTemplate = true;

  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    currentUser = ChatUser(
      id: user?.uid ?? 'demo_user',
      name: user?.displayName ?? user?.email?.split('@').first ?? 'Pelanggan',
    );

    _templateController = TextEditingController(
      text: widget.initialMessage ?? '',
    );

    _chatController = ChatController(
      initialMessageList: [
        Message(
          id: 'welcome_message',
          message:
              'Halo! Selamat datang di SecondHand Motors 👋\n\n'
              'Ada yang bisa kami bantu? Silakan tanyakan tentang '
              'stok kendaraan, harga, atau jadwal test drive.',
          createdAt: DateTime.now(),
          sentBy: adminId,
        ),
      ],
      scrollController: ScrollController(),
      currentUser: currentUser,
      otherUsers: [admin],
    );
  }

  // Mengirim pesan template kendaraan
  void _sendTemplate() {
    final message = _templateController.text.trim();

    if (message.isEmpty) return;

    _chatController.addMessage(
      Message(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        message: message,
        createdAt: DateTime.now(),
        sentBy: currentUser.id,
      ),
    );

    setState(() {
      _showTemplate = false;
    });

    _sendAdminReply(message);
  }

  // Mengirim pesan biasa melalui ChatView
  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    _chatController.addMessage(
      Message(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        message: message,
        createdAt: DateTime.now(),
        sentBy: currentUser.id,
        replyMessage: replyMessage,
        messageType: messageType,
      ),
    );

    _sendAdminReply(message);
  }

  // Simulasi balasan admin
  void _sendAdminReply(String message) {
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      _chatController.addMessage(
        Message(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          message: _getAdminReply(message),
          createdAt: DateTime.now(),
          sentBy: adminId,
        ),
      );
    });
  }

  String _getAdminReply(String message) {
    final text = message.toLowerCase();

    if (text.contains('harga')) {
      return 'Untuk informasi harga kendaraan, silakan sebutkan unit yang ingin kamu tanyakan ya 😊';
    }

    if (text.contains('stok') || text.contains('tersedia')) {
      return 'Tentu! Kami siap membantu mengecek ketersediaan unit. Kendaraan apa yang sedang kamu cari?';
    }

    if (text.contains('test drive')) {
      return 'Bisa banget! Kamu bisa melakukan test drive. Silakan informasikan kendaraan dan jadwal yang kamu inginkan.';
    }

    if (text.contains('halo') || text.contains('hai')) {
      return 'Halo juga! Ada kendaraan yang sedang kamu cari? 😊';
    }

    return 'Terima kasih sudah menghubungi SecondHand Motors! Pesan kamu sudah kami terima. Ada hal lain yang ingin ditanyakan?';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF789449),
              child: Icon(Icons.storefront_rounded, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Admin SecondHand',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.vehicleName != null
                            ? 'Tentang ${widget.vehicleName}'
                            : 'Online',
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant,
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
      body: SafeArea(
        child: Column(
          children: [
            // Template pesan kendaraan
            if (_showTemplate && widget.initialMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: isDark
                    ? const Color(0xFF242B1F)
                    : const Color(0xFFF1F4EB),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.edit_note_rounded, color: Color(0xFF789449)),
                        SizedBox(width: 6),
                        Text(
                          'Template pesan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _templateController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        filled: true,
                        fillColor: theme.cardColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: _sendTemplate,
                        icon: const Icon(Icons.send_rounded, size: 17),
                        label: const Text('Kirim template'),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF557128),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Area percakapan
            Expanded(
              child: ChatView(
                chatController: _chatController,
                onSendTap: _onSendTap,
                chatViewState: ChatViewState.hasMessages,
                chatBackgroundConfig: ChatBackgroundConfiguration(
                  backgroundColor: isDark
                      ? const Color(0xFF141712)
                      : const Color(0xFFF6F7F3),
                ),
                sendMessageConfig: SendMessageConfiguration(
                  textFieldBackgroundColor: Colors.white,
                  textFieldConfig: TextFieldConfiguration(
                    hintText: 'Ketik pesan...',
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                chatBubbleConfig: ChatBubbleConfiguration(
                  outgoingChatBubbleConfig: ChatBubble(
                    color: const Color(0xFF557128),
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  inComingChatBubbleConfig: ChatBubble(
                    color: isDark
                        ? const Color(0xFF2B3422)
                        : const Color(0xFFEAF0DF),
                    textStyle: TextStyle(
                      color: isDark
                          ? Colors.white
                          : const Color(0xFF252A20),
                      fontSize: 15,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _templateController.dispose();
    _chatController.dispose();
    super.dispose();
  }
}
