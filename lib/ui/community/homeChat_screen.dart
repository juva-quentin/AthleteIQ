import 'package:athlete_iq/ui/community/create-group-screen/create_group_view_model_provider.dart';
import 'package:athlete_iq/ui/community/providers/groups_provider.dart';
import 'package:athlete_iq/ui/community/search-screen/search_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Assurez-vous d'importer ceci

import '../../model/Groups.dart';
import '../../utils/routes/customPopupRoute.dart';
import 'components/no_group_component.dart';
import 'create-group-screen/createGroup_screen.dart';
import 'components/group_tile.dart';

class HomeChatScreen extends ConsumerWidget {
  const HomeChatScreen({Key, key}) : super(key: key);

  static const route = "/groups";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(GroupsProvider);
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
        title: Text(
          "Communauté",
          style: TextStyle(
              fontSize: 24.sp, // Modifié
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(5.w, 0, 5.w, 10.h), // Modifié
        child: groups.when(data: (List<Groups> groups) {
          if (groups.isEmpty) {
            return noGroupWidget(ref, context);
          } else {
            return ListView.builder(
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  return groupTile(groups[index], context, ref);
                });
          }
        }, error: (Object error, StackTrace? stackTrace) {
          if (kDebugMode) {
            print(error.toString());
          }
          return Text(error.toString());
        }, loading: () {
          return const Center(child: CircularProgressIndicator());
        }),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 90.h), // Modifié
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
            child: Icon(Icons.add, color: Colors.white, size: 30.sp)),
      ),
    );
  }
}
