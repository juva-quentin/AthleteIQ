import 'package:athlete_iq/ui/community/providers/active_groups_provider.dart';
import 'package:athlete_iq/ui/community/chat-page/chat_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import 'components/message_tile.dart';
import 'components/group_info.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage(this.args, {Key, key}) : super(key: key);

  static const route = "/groups/chat";

  final Object args;

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  @override
  void initState() {
    final model = ref.read(chatViewModelProvider);
    model.groupeId = widget.args.toString();
    model.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final group = ref.watch(streamGroupsProvider(widget.args.toString()));
    final width = MediaQuery.of(context).size.width;
    final model = ref.watch(chatViewModelProvider);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              UniconsLine.arrow_left,
              size: width * .1,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, GroupInfo.route,
                      arguments: widget.args);
                },
                icon: Icon(Icons.info, size: width * .07, color: Colors.white))
          ],
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: group.when(
              data: (data) {
                return Text(
                  data.groupName,
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                );
              },
              error: (error, _) {
                return Text(Error as String);
              },
              loading: () => CircularProgressIndicator()),
        ),
        body: Stack(
          children: <Widget>[
            // chat messages here
            Padding(
              padding: EdgeInsets.only(bottom: 100),
              child: chatMessages(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(children: [
                  Expanded(
                      child: TextField(
                    controller: model.messageController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    textInputAction: TextInputAction.newline,
                    style: const TextStyle(color: Colors.black),
                    decoration: const InputDecoration(
                      hintText: "Envoyer un message...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      border: InputBorder.none,
                    ),
                  )),
                  const SizedBox(
                    width: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      model.sendMessage();
                      FocusManager.instance.primaryFocus?.unfocus();
                      model.scrollController.animateTo(
                          model.scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 010),
                          curve: Curves.easeOut);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                          child: Icon(
                        Icons.send,
                        size: 19,
                        color: Colors.white,
                      )),
                    ),
                  )
                ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

chatMessages() {
  return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
    final model = ref.watch(chatViewModelProvider);
    return StreamBuilder(
      stream: model.chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                controller: model.scrollController,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: model.username ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  });
}
