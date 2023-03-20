import 'package:athlete_iq/ui/chat/providers/active_groups_provider.dart';
import 'package:athlete_iq/ui/chat/providers/chat_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'components/message_tile.dart';
import 'group_info.dart';


class ChatPage extends ConsumerWidget {
  const ChatPage({Key, key}) : super(key: key);

  static const route = "/groups/chat";

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final id = ref.watch(activeGroupeProvider);
    final group = ref.watch(streamGroupsProvider(id));
    final model = ref.watch(chatViewModelProvider);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, GroupInfo.route);
                },
                icon: const Icon(Icons.info, color: Colors.white))
          ],
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: group.when(data: (data) {return Text(data.groupName, style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),);} , error: (error, _) {return Text(Error as String);}, loading: () => CircularProgressIndicator()),
        ),
      body: Stack(
        children: <Widget>[
          // chat messages here
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(children: [
                Expanded(
                    child: TextFormField(
                      controller: model.messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Envoyer un message...",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: () {
                    model.sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        )),
                  ),
                )
              ]),
            ),
          )
        ],
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
  );});
}