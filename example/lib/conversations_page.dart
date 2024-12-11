import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

import 'custom_video_message/archive_message_page.dart';

class ConversationsPage extends StatefulWidget {
  const ConversationsPage({super.key});

  @override
  State<ConversationsPage> createState() => _ConversationsPageState();
}

class _ConversationsPageState extends State<ConversationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Conversations"),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      // Conversation view page in uikit
      body: ChatConversationsView(
        // Click to jump to the message page.
        onItemTap: (conversation) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ArchiveMessagesPage(conversation);
              },
            ),
          );
        },
        avatarBuilder: (context, conversation) {
          ///Can be returned any Widget
          // return Container(
          //   width: 40,
          //   height: 40,
          //   decoration: BoxDecoration(
          //     shape: BoxShape.circle,
          //   ),
          // );
        },
      ),
    );
  }
}
