import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../providers/active_groups_provider.dart';
import 'components/message_tile.dart';
import 'components/group_info.dart';
import 'chat_view_model_provider.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage(this.args, {super.key});

  final Object args;

  static const route = "/groups/chat";

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    Future.delayed(Duration.zero, () async {
      final model = ref.read(chatViewModelProvider);
      model.groupeId = widget.args.toString();
      await model.init();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final group = ref.watch(streamGroupsProvider(widget.args.toString()));
    final model = ref.watch(chatViewModelProvider);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: group.when(
            data: (data) => Text(data.groupName),
            error: (_, __) => Text("Erreur"),
            loading: () => const CircularProgressIndicator(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => Navigator.pushNamed(context, GroupInfo.route, arguments: widget.args),
            ),
          ],
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 100.h), // Modifié
              child: chatMessages(),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 18.h), // Modifié
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                      controller: model.messageController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      textInputAction: TextInputAction.newline,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: "Envoyer un message...",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    )),
                    SizedBox(
                      width: 12.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        model.sendMessage();
                        FocusManager.instance.primaryFocus?.unfocus();
                        model.scrollController.animateTo(
                          model.scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                      },
                      child: Container(
                        height: 40.h,
                        width: 40.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1.r,
                              blurRadius: 5.r,
                              offset: Offset(0, 3.h),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.send,
                            size: 20.sp,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
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
                padding: EdgeInsets.symmetric(horizontal: 10.w), // Modifié
                itemBuilder: (context, index) {
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      date: model.formatMessageDateTime(
                          snapshot.data.docs[index]['time'].toDate()),
                      sentByMe: model.username ==
                          snapshot.data.docs[index]['sender'],
                    senderImage: snapshot.data.docs[index]['senderImageUrl'],);
                },
              )
            : Container();
      },
    );
  });
}
