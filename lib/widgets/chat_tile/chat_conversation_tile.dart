import 'package:flutter/material.dart';

import '../../agora_chat_uikit.dart';

class ChatConversationListTile extends StatefulWidget {
  const ChatConversationListTile({
    super.key,
    this.avatar,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    required this.conversation,
  });

  final Widget? avatar;
  final Widget? title;
  final Widget? subtitle;
  final Widget? trailing;
  final void Function(ChatConversation conversation)? onTap;
  final ChatConversation conversation;

  @override
  State<ChatConversationListTile> createState() =>
      _ChatConversationListTileState();
}

class _ChatConversationListTileState extends State<ChatConversationListTile> {
  @override
  void initState() {
    super.initState();
    // getGroupNameById();
  }

  // getGroupNameById() async{
  //   ChatCursorResult<ChatGroupInfo> grpData =
  //   await ChatClient.getInstance.groupManager.fetchPublicGroupsFromServer();
  //
  //   final data = grpData.data;
  //
  //   for (var element in data) {
  //     if(element.groupId == widget.conversation.id){
  //       setState(() {
  //         groupName = element.name!;
  //       });
  //     }
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.conversation.latestMessage(),
      builder: (context, snapshot) {
        ChatMessage? msg;
        if (snapshot.hasData) {
          msg = snapshot.data!;
        }

        return ListTile(
          leading: widget.avatar,
          title: widget.title ??
              Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: widget.title ??
                          Text(
                            widget.conversation.id,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                    ),
                    Text(
                      msg?.createTs ?? "",
                      style: ChatUIKit.of(context)
                              ?.theme
                              .conversationListItemTsStyle ??
                          const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ]),
          subtitle: widget.subtitle ??
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Expanded(child: Builder(
                  builder: (context) {
                    return Text(
                      msg?.summary(context) ?? "",
                      style: ChatUIKit.of(context)
                              ?.theme
                              .conversationListItemTitleStyle ??
                          const TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                    );
                  },
                )),
                FutureBuilder<int>(
                  future: widget.conversation.unreadCount(),
                  builder: (context, snapshot) {
                    return ChatBadgeWidget(snapshot.data ?? 0);
                  },
                )
              ]),
          trailing: widget.trailing,
          onTap: () => widget.onTap?.call(widget.conversation),
        );
      },
    );
  }
}
