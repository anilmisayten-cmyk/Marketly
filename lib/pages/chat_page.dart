import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketplace_app/constants/colors.dart';

class ChatPage extends StatefulWidget {
  final String otherUid;
  final String otherName;
  final String? otherEmail;

  const ChatPage({
    super.key,
    required this.otherUid,
    required this.otherName,
    this.otherEmail,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _sending = false;

  String get _myUid => FirebaseAuth.instance.currentUser!.uid;

  String get _chatId {
    final ids = [_myUid, widget.otherUid]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  CollectionReference<Map<String, dynamic>> get _messages =>
      FirebaseFirestore.instance
          .collection('Chats')
          .doc(_chatId)
          .collection('Messages');

  DocumentReference<Map<String, dynamic>> get _chat =>
      FirebaseFirestore.instance.collection('Chats').doc(_chatId);

  @override
  void initState() {
    super.initState();
    _messageController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _sending) return;

    setState(() => _sending = true);
    _messageController.clear();

    try {
      final now = FieldValue.serverTimestamp();
      await _chat.set({
        'participants': [_myUid, widget.otherUid],
        'participantNames': {
          _myUid: FirebaseAuth.instance.currentUser?.displayName ??
              FirebaseAuth.instance.currentUser?.email ??
              'User',
          widget.otherUid: widget.otherName,
        },
        'lastMessage': text,
        'lastSenderId': _myUid,
        'updatedAt': now,
      }, SetOptions(merge: true));

      await _messages.add({
        'senderId': _myUid,
        'text': text,
        'createdAt': now,
        'seen': false,
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Mesaj gönderilemedi: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: kDefaultRedColor.withOpacity(.14),
              child: Text(
                widget.otherName.isEmpty ? '?' : widget.otherName[0].toUpperCase(),
                style: const TextStyle(
                  color: kDefaultRedColor,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.otherName,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(fontWeight: FontWeight.w800)),
                  Text(
                    'Marketly sohbeti',
                    style: GoogleFonts.nunito(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Sohbet seçenekleri',
            onPressed: () {},
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _messages
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Text(
                        'Mesajlar yüklenemedi. Firestore güvenlik kurallarında Chats/Messages erişimini açmalısın.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunito(),
                      ),
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: kDefaultRedColor.withOpacity(.12),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(Icons.chat_bubble_rounded,
                              color: kDefaultRedColor, size: 30),
                        ),
                        const SizedBox(height: 15),
                        Text('Sohbeti başlat',
                            style: GoogleFonts.nunito(
                                fontSize: 19, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 5),
                        Text('İlk mesajını gönder.',
                            style: GoogleFonts.nunito(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_scrollController.hasClients) {
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOut,
                    );
                  }
                });

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    final mine = data['senderId'] == _myUid;
                    return _Bubble(
                      text: '${data['text'] ?? ''}',
                      mine: mine,
                      isDark: isDark,
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(top: BorderSide(color: Colors.black.withOpacity(.06))),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 5,
                      textCapitalization: TextCapitalization.sentences,
                      onSubmitted: (_) => _send(),
                      decoration: InputDecoration(
                        hintText: 'Mesaj yaz...',
                        prefixIcon: const Icon(Icons.add_rounded),
                        suffixIcon: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.image_outlined),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedScale(
                    scale: _messageController.text.trim().isEmpty ? .88 : 1,
                    duration: const Duration(milliseconds: 180),
                    child: IconButton.filled(
                      onPressed: _messageController.text.trim().isEmpty || _sending
                          ? null
                          : _send,
                      icon: _sending
                          ? const SizedBox(
                              width: 19,
                              height: 19,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.arrow_upward_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final String text;
  final bool mine;
  final bool isDark;

  const _Bubble({required this.text, required this.mine, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = mine
        ? kDefaultRedColor
        : (isDark ? const Color(0xFF202229) : Colors.white);
    final fg = mine ? Colors.white : (isDark ? Colors.white : const Color(0xFF22242A));

    return Align(
      alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .78),
        margin: const EdgeInsets.only(bottom: 9),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(mine ? 20 : 5),
            bottomRight: Radius.circular(mine ? 5 : 20),
          ),
          boxShadow: mine
              ? null
              : [BoxShadow(color: Colors.black.withOpacity(.04), blurRadius: 8)],
        ),
        child: Text(text, style: GoogleFonts.nunito(color: fg, fontSize: 15)),
      ),
    );
  }
}

class ConversationsPage extends StatelessWidget {
  const ConversationsPage({super.key});

  String _otherId(Map<String, dynamic> data, String me) {
    final ids = List<String>.from(data['participants'] ?? const []);
    return ids.firstWhere((id) => id != me, orElse: () => '');
  }

  String _otherName(Map<String, dynamic> data, String me) {
    final names = Map<String, dynamic>.from(data['participantNames'] ?? const {});
    return '${names[ _otherId(data, me)] ?? 'Kullanıcı'}';
  }

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Mesajlar', style: GoogleFonts.nunito(fontWeight: FontWeight.w800)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search_rounded),
                hintText: 'Sohbet ara',
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('Chats')
                  .where('participants', arrayContains: me)
                  .orderBy('updatedAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return _MessageError();
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                if (docs.isEmpty) {
                  return _EmptyMessages(onStart: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const NewChatPage()),
                    );
                  });
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 3),
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    final otherId = _otherId(data, me);
                    final otherName = _otherName(data, me);
                    return ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor: kDefaultRedColor.withOpacity(.13),
                        child: Text(otherName.isEmpty ? '?' : otherName[0].toUpperCase(),
                            style: const TextStyle(color: kDefaultRedColor, fontWeight: FontWeight.w800)),
                      ),
                      title: Text(otherName, style: GoogleFonts.nunito(fontWeight: FontWeight.w800)),
                      subtitle: Text('${data['lastMessage'] ?? ''}', maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatPage(otherUid: otherId, otherName: otherName),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewChatPage()),
        ),
        child: const Icon(Icons.edit_rounded),
      ),
    );
  }
}

class NewChatPage extends StatelessWidget {
  const NewChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final me = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: Text('Yeni mesaj', style: GoogleFonts.nunito(fontWeight: FontWeight.w800))),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Users').orderBy('fullName').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Kullanıcılar yüklenemedi.'));
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final users = snapshot.data!.docs.where((d) => d.id != me).toList();
          if (users.isEmpty) return const Center(child: Text('Henüz başka kullanıcı yok.'));
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: users.length,
            itemBuilder: (_, i) {
              final data = users[i].data();
              final name = '${data['fullName'] ?? data['Email'] ?? 'Kullanıcı'}';
              final email = '${data['Email'] ?? ''}';
              return Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  leading: CircleAvatar(
                    backgroundColor: kDefaultRedColor.withOpacity(.13),
                    child: Text(name.isEmpty ? '?' : name[0].toUpperCase(),
                        style: const TextStyle(color: kDefaultRedColor, fontWeight: FontWeight.w800)),
                  ),
                  title: Text(name, style: GoogleFonts.nunito(fontWeight: FontWeight.w800)),
                  subtitle: Text(email),
                  trailing: const Icon(Icons.chat_bubble_outline_rounded),
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(otherUid: users[i].id, otherName: name, otherEmail: email),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _EmptyMessages extends StatelessWidget {
  final VoidCallback onStart;
  const _EmptyMessages({required this.onStart});
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.forum_outlined, size: 55, color: kDefaultRedColor),
            const SizedBox(height: 15),
            Text('Henüz mesaj yok', style: GoogleFonts.nunito(fontSize: 21, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text('Bir kullanıcı seçip sohbeti başlat.', textAlign: TextAlign.center, style: GoogleFonts.nunito(color: Colors.grey)),
            const SizedBox(height: 18),
            FilledButton.icon(onPressed: onStart, icon: const Icon(Icons.edit_rounded), label: const Text('Yeni mesaj')),
          ]),
        ),
      );
}

class _MessageError extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Text(
            'Mesaj sistemi Firestore erişimi bekliyor. Chats koleksiyonuna okuma/yazma izni vermelisin.',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(),
          ),
        ),
      );
}
