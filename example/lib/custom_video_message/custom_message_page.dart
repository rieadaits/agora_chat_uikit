import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:example/custom_video_message/play_video_page.dart';
import 'package:flutter/material.dart';

import 'chat_message_list_video_item.dart';

class CustomMessagesPage extends StatefulWidget {
  const CustomMessagesPage(this.conversation, {super.key});

  final ChatConversation conversation;

  @override
  State<CustomMessagesPage> createState() => _CustomMessagesPageState();
}

class _CustomMessagesPageState extends State<CustomMessagesPage> {
  late final ChatMessageListController controller;

  @override
  void initState() {
    super.initState();
    controller = ChatMessageListController(widget.conversation);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.id),
        actions: [
          UnconstrainedBox(
            child: InkWell(
              onTap: () {
                controller.deleteAllMessages();
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Delete',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: ChatMessagesView(
          messageListViewController: controller,
          conversation: widget.conversation,
          onError: (error) {
            showSnackBar('error: ${error.description}');
          },
          onTap: (context, message) {
            if (message.body.type == MessageType.FILE) {
              ChatFileMessageBody body = message.body as ChatFileMessageBody;
              OpenFilex.open(body.localPath);
              print("${body.localPath}");
            }
            if (message.body.type == MessageType.VOICE) {
              ChatVoiceMessageBody body = message.body as ChatVoiceMessageBody;
              print("${body.localPath}");
            }
            if (message.body.type == MessageType.IMAGE) {
              ChatImageMessageBody body = message.body as ChatImageMessageBody;
              print("${body.localPath}");
            }

            return false;
          },
          itemBuilder: (context, model) {
            if (model.message.body.type == MessageType.VIDEO) {
              return ChatMessageListVideoItem(
                model: model,
                onBubbleLongPress: (context, msg) {
                  longPressAction(msg, context, controller);
                  return true;
                },
                onPlayTap: playVideo,
              );
            }
            return null;
          },
          inputBarMoreActionsOnTap: (items) {
            return items;
            // return items +
            //     [
            //       ChatBottomSheetItem.normal('Video', onTap: () async {
            //         Navigator.of(context).pop();
            //         sendVideoMessage();
            //       }),
            //     ];
          },
        ),
      ),
    );
  }

  void showSnackBar(String str) {
    final snackBar = SnackBar(
      content: Text(str),
      duration: const Duration(milliseconds: 1000),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void playVideo(ChatMessage message) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return PlayVideoPage(message);
    }));
  }
}
