import 'package:agora_chat_uikit/agora_chat_uikit.dart';
import 'package:example/conversations_page.dart';
import 'package:example/messages_page.dart';
import 'package:flutter/material.dart';

// jashem:
String jashemToken =
    "007eJxTYAg5999o5hT2d5851U9HaguKr9qrUc3DsXRilNKm2dMfKYUrMJgZJxkbWqSZmJqkWpgYmFokmpikmScnGRknW5qbJSUai9rfSGsIZGRQnaDFysjAysAIhCC+CoNlSlKqiXmSga6hgXGyrqFhapqupUWikW6SqUGKUWqSiVGKmQkAgn4koQ==";

//riead
String rieadToken =
    "007eJxTYFhnllZVXzQ1ST+Su+u6xjWHUG53heCvy7kitErzdl006FBgMDNOMja0SDMxNUm1MDEwtUg0MUkzT04yMk62NDdLSjT+Z3cjrSGQkcFmDi8rIwMrAyMQgvgqDOaplkYplqYGuoYGxsm6hoapabpJxhapumYpZskpFhYmxuYpxgBHaSRx";

//enamul
String enamulToken =
    "007eJxTYDh90qf28pzH2VvD+Nt3hW94YHslaOb6Ko4styU986e2mkUqMJgZJxkbWqSZmJqkWpgYmFokmpikmScnGRknW5qbJSUaWyaFpjUEMjKIxO1kZWRgZWAEQhBfhcEiMcks1dLMQNfQwDhZ19AwNU030dDISNciyTApxdw0NTXRzAQAqgYnRA==";

class ChatConfig {
  static String appKey = "611147007#1332714";
  static String userId = "jashem";
  static String agoraToken = jashemToken;
}

void main() async {
  assert(ChatConfig.appKey.isNotEmpty,
      "You need to configure AppKey information first.");
  WidgetsFlutterBinding.ensureInitialized();
  final options = ChatOptions(
    appKey: ChatConfig.appKey,
    autoLogin: false,
  );
  await ChatClient.getInstance.init(options);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) {
        // ChatUIKit widget at the top of the widget
        return ChatUIKit(child: child!);
      },
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MyHomePage(title: 'Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScrollController scrollController = ScrollController();
  ChatConversation? conversation;
  String _chatId = "";
  final List<String> _logText = [];
  final String groupIdOne = "248845270319106";
  final String groupIdTwo = "248848107765762";
  final String groupIdThree = "249018086129665";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            const SizedBox(height: 10),
            Text("login userId: ${ChatConfig.userId}"),
            Text("agoraToken: ${ChatConfig.agoraToken}"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: TextButton(
                    onPressed: () {
                      _signIn();
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
                    ),
                    child: const Text("SIGN IN"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      _signOut();
                    },
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
                    ),
                    child: const Text("SIGN OUT"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Enter recipient's userId",
                    ),
                    onChanged: (chatId) => _chatId = chatId,
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    _pushToChatPage(_chatId);
                  },
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.lightBlue),
                  ),
                  child: const Text("START CHAT"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                _pushToConversationPage();
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
              ),
              child: const Text("CONVERSATION"),
            ),
            Flexible(
              child: ListView.builder(
                controller: scrollController,
                itemBuilder: (_, index) {
                  return Text(_logText[index]);
                },
                itemCount: _logText.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pushToConversationPage() async {
    if (ChatClient.getInstance.currentUserId == null) {
      _addLogToConsole('user not login');
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return const ConversationsPage();
    }));
  }

  void _pushToChatPage(String userId) async {
    if (ChatClient.getInstance.currentUserId == null) {
      _addLogToConsole('user not login');
      return;
    }
    ChatConversation? conv =
        await ChatClient.getInstance.chatManager.getConversation(userId);

    Future(() {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return MessagesPage(
          conv!,
        );
      }));
    });
  }

  void _signIn() async {
    _addLogToConsole('begin sign in...');
    if (ChatConfig.agoraToken.isNotEmpty) {
      try {
        await ChatClient.getInstance.loginWithAgoraToken(
          ChatConfig.userId,
          ChatConfig.agoraToken,
        );
        _addLogToConsole('sign in success');
      } on ChatError catch (e) {
        _addLogToConsole('sign in fail: ${e.description}');
      }
    } else {
      _addLogToConsole(
          'sign in fail: The password and agoraToken cannot both be null.');
    }
  }

  void _signOut() async {
    _addLogToConsole('begin sign out...');
    try {
      await ChatClient.getInstance.logout();
      _addLogToConsole('sign out success');
    } on ChatError catch (e) {
      _addLogToConsole('sign out fail: ${e.description}');
    }
  }

  void _addLogToConsole(String log) {
    _logText.add("$_timeString: $log");
    setState(() {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  String get _timeString {
    return DateTime.now().toString().split(".").first;
  }
}
