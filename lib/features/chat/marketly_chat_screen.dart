import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Marketly enhanced 1-to-1 chat:
/// - Firebase Firestore realtime messages
/// - Firebase Storage image messages
/// - read receipts (seenAt)
/// - typing indicator (typing.{uid})
///
/// Expected Firestore structure:
/// chats/{chatId}
///   members: [uidA, uidB]
///   lastMessage: String
///   lastMessageType: "text" | "image"
///   updatedAt: Timestamp
///   typing: {uidA: true, uidB: false}
/// chats/{chatId}/messages/{messageId}
///   senderId: String
///   type: "text" | "image"
///   text: String
///   imageUrl: String
///   createdAt: Timestamp
///   seenAt: Timestamp?
class MarketlyChatScreen extends StatefulWidget {
  final String otherUid;
  final String otherUsername;

  const MarketlyChatScreen({
    super.key,
    required this.otherUid,
    required this.otherUsername,
  });

  @override
  State<MarketlyChatScreen> createState() => _MarketlyChatScreenState();
}

class _MarketlyChatScreenState extends State<MarketlyChatScreen> {
  final _text = TextEditingController();
  final _picker = ImagePicker();
  bool _sending = false;
  bool _typing = false;

  User get _me => FirebaseAuth.instance.currentUser!;

  String get _chatId {
    final ids = [_me.uid, widget.otherUid]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  DocumentReference<Map<String, dynamic>> get _chat =>
      FirebaseFirestore.instance.collection('chats').doc(_chatId);

  CollectionReference<Map<String, dynamic>> get _messages =>
      _chat.collection('messages');

  @override
  void initState() {
    super.initState();
    _text.addListener(_onTextChanged);
    _markIncomingMessagesSeen();
  }

  @override
  void dispose() {
    _setTyping(false);
    _text.removeListener(_onTextChanged);
    _text.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final next = _text.text.trim().isNotEmpty;
    if (next != _typing) {
      _typing = next;
      _setTyping(next);
    }
  }

  Future<void> _setTyping(bool value) async {
    try {
      await _chat.set({
        'typing': {_me.uid: value},
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  Future<void> _markIncomingMessagesSeen() async {
    try {
      final snap = await _messages
          .where('senderId', isEqualTo: widget.otherUid)
          .where('seenAt', isNull: true)
          .limit(100)
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (final doc in snap.docs) {
        batch.update(doc.reference, {'seenAt': FieldValue.serverTimestamp()});
      }
      if (snap.docs.isNotEmpty) await batch.commit();
    } catch (_) {}
  }

  Future<void> _sendText() async {
    final value = _text.text.trim();
    if (value.isEmpty || _sending) return;

    _text.clear();
    setState(() => _sending = true);

    try {
      await _chat.set({
        'members': [_me.uid, widget.otherUid],
        'lastMessage': value,
        'lastMessageType': 'text',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _messages.add({
        'senderId': _me.uid,
        'type': 'text',
        'text': value,
        'createdAt': FieldValue.serverTimestamp(),
        'seenAt': null,
      });
    } finally {
      if (mounted) setState(() => _sending = false);
      await _setTyping(false);
    }
  }

  Future<void> _sendImage() async {
    if (_sending) return;

    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 82,
      maxWidth: 1800,
    );
    if (picked == null) return;

    setState(() => _sending = true);
    try {
      final file = File(picked.path);
      final name =
          '${DateTime.now().millisecondsSinceEpoch}_${_me.uid}.jpg';
      final ref = FirebaseStorage.instance
          .ref()
          .child('chat_images')
          .child(_chatId)
          .child(name);

      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      await _chat.set({
        'members': [_me.uid, widget.otherUid],
        'lastMessage': 'Fotoğraf',
        'lastMessageType': 'image',
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _messages.add({
        'senderId': _me.uid,
        'type': 'image',
        'imageUrl': url,
        'text': '',
        'createdAt': FieldValue.serverTimestamp(),
        'seenAt': null,
      });
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 4,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              child: Text(
                widget.otherUsername.isEmpty
                    ? '?'
                    : widget.otherUsername[0].toUpperCase(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: _chat.snapshots(),
                builder: (context, snapshot) {
                  final data = snapshot.data?.data();
                  final typing = Map<String, dynamic>.from(
                    data?['typing'] ?? const {},
                  );
                  final isTyping = typing[widget.otherUid] == true;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.otherUsername,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Text(
                          isTyping ? 'yazıyor...' : 'mesajlar',
                          key: ValueKey(isTyping),
                          style: TextStyle(
                            fontSize: 12,
                            color: isTyping
                                ? scheme.primary
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _messages
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _markIncomingMessagesSeen();
                });

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data();
                    final mine = data['senderId'] == _me.uid;
                    final type = data['type'] ?? 'text';

                    return Align(
                      alignment:
                          mine ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 310),
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: type == 'image'
                            ? const EdgeInsets.all(5)
                            : const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                        decoration: BoxDecoration(
                          color: type == 'image'
                              ? scheme.surfaceContainerHighest
                              : mine
                                  ? scheme.primary
                                  : scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(20),
                            topRight: const Radius.circular(20),
                            bottomLeft: Radius.circular(mine ? 20 : 5),
                            bottomRight: Radius.circular(mine ? 5 : 20),
                          ),
                        ),
                        child: type == 'image'
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.network(
                                  '${data['imageUrl'] ?? ''}',
                                  width: 250,
                                  height: 250,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const SizedBox(
                                    width: 250,
                                    height: 120,
                                    child: Center(
                                      child: Icon(Icons.broken_image_rounded),
                                    ),
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: mine
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${data['text'] ?? ''}',
                                    style: TextStyle(
                                      color: mine
                                          ? scheme.onPrimary
                                          : scheme.onSurface,
                                      fontSize: 15,
                                    ),
                                  ),
                                  if (mine) ...[
                                    const SizedBox(height: 3),
                                    _SeenIndicator(
                                      seen: data['seenAt'] != null,
                                      color: scheme.onPrimary.withValues(
                                        alpha: .75,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 10),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Fotoğraf gönder',
                    onPressed: _sending ? null : _sendImage,
                    icon: const Icon(Icons.add_photo_alternate_rounded),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _text,
                      minLines: 1,
                      maxLines: 5,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'Mesaj yaz...',
                        suffixIcon: _sending
                            ? const Padding(
                                padding: EdgeInsets.all(13),
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton.filled(
                    tooltip: 'Gönder',
                    onPressed: _sending ? null : _sendText,
                    icon: const Icon(Icons.arrow_upward_rounded),
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

class _SeenIndicator extends StatelessWidget {
  final bool seen;
  final Color color;

  const _SeenIndicator({
    required this.seen,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          seen ? Icons.done_all_rounded : Icons.done_rounded,
          size: 15,
          color: color,
        ),
        const SizedBox(width: 3),
        Text(
          seen ? 'Görüldü' : 'Gönderildi',
          style: TextStyle(fontSize: 9, color: color),
        ),
      ],
    );
  }
}
