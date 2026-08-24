# Marketly chat upgrade

Added `lib/features/chat/marketly_chat_screen.dart`.

Features:
- Realtime Firestore 1-to-1 messages
- Firebase Storage image messages
- Read receipts using `seenAt`
- Typing indicator stored under `chats/{chatId}.typing`
- Rounded modern chat UI

Required Firestore fields:
- chats/{chatId}: members, lastMessage, lastMessageType, updatedAt, typing
- chats/{chatId}/messages/{messageId}: senderId, type, text, imageUrl, createdAt, seenAt

The existing Firebase project/config is intentionally preserved.
