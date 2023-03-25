import 'package:athlete_iq/ui/chat/providers/create_group_view_model_provider.dart';
import 'package:athlete_iq/ui/chat/providers/groups_provider.dart';
import 'package:athlete_iq/ui/chat/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/Groups.dart';
import '../../utils/routes/customPopupRoute.dart';
import 'components/no_group_component.dart';
import 'createGroup_screen.dart';
import 'components/group_tile.dart';

class HomeChatScreen extends ConsumerWidget {
  const HomeChatScreen({Key, key}) : super(key: key);

  static const route = "/groups";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(GroupsProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchPage.route);
              },
              icon: const Icon(Icons.search, color: Colors.white))
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Communauté",
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(width*.01, 0, width*.01, height*.01),
        child: groups.when(data: (List<Groups> groups) {
          if (groups.isEmpty) {
            return noGroupWidget(ref, context);
          } else {
            return ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return groupTile(
                      groups[index], context, ref);
                });
          }
        }, error: (Object error, StackTrace? stackTrace) {
          if (kDebugMode) {
            print(error.toString());
          }
          return Text(error.toString());
        }, loading: () {
          return const Text('Loading');
        }),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: FloatingActionButton(
            onPressed: () async {
              await Navigator.of(context).push(
                CustomPopupRoute(
                  builder: (BuildContext context) {
                    return CreateGroupScreen();
                  },
                ),
              );
              ref.read(creatGroupViewModelProvider).clear();
            },
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColor,
            child: const Icon(Icons.add, color: Colors.white, size: 30)),
      ),
    );
  }
}
