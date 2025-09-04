import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:flutter/material.dart';

import 'custom_video_message/chat_message_list_video_item.dart';
import 'custom_video_message/play_video_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage(this.conversation, {super.key});

  final ChatConversation conversation;

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  late final ChatMessageListController controller;
  String groupName = '';

  @override
  void initState() {
    super.initState();
    controller = ChatMessageListController(widget.conversation);
    // getGroupNameById();
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
        // Message page in uikit.
        child: ChatMessagesView(
          conversation: widget.conversation,
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

  void playVideo(ChatMessage message) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return PlayVideoPage(message);
    }));
  }
}
