import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:example/custom_video_message/play_video_page.dart';
import 'package:flutter/material.dart';

import 'chat_message_list_video_item.dart';

class ArchiveMessagesPage extends StatefulWidget {
  const ArchiveMessagesPage(
    this.conversation, {
    super.key,
  });

  final ChatConversation conversation;

  @override
  State<ArchiveMessagesPage> createState() => _ArchiveMessagesPageState();
}

class _ArchiveMessagesPageState extends State<ArchiveMessagesPage> {
  late final ChatMessageListController controller;
  String groupName = '';

  @override
  void initState() {
    super.initState();
    controller = ChatMessageListController(widget.conversation);
    // getGroupNameById();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // getGroupNameById() async {
  //   ChatCursorResult<ChatGroupInfo> grpData =
  //       await ChatClient.getInstance.groupManager.fetchPublicGroupsFromServer();
  //
  //   final data = grpData.data;
  //
  //   for (var element in data) {
  //     if (element.groupId == widget.conversation.id) {
  //       setState(() {
  //         groupName = element.name!;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.conversation.id),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: ChatMessagesView(
          canStartChat: false,
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
