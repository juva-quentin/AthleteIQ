import 'package:athlete_iq/ui/info/components/userTileComponent.dart';
import 'package:athlete_iq/ui/info/provider/friends_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/utils.dart';

class FriendsListScreen extends ConsumerStatefulWidget {
  const FriendsListScreen({Key, key}) : super(key: key);

  @override
  FriendsListState createState() => FriendsListState();
}

class FriendsListState extends ConsumerState<FriendsListScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(friendsViewModelProvider).init();
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(friendsViewModelProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: RefreshIndicator(
          displacement: 20,
          backgroundColor: Theme.of(context).primaryColor,
          color: Theme.of(context).indicatorColor,
          strokeWidth: 3,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            try {
              await model.loadFriends();
            } catch (e) {
              Utils.flushBarErrorMessage(e.toString(), context);
            }
          },
          child: model.awaitFriends.isEmpty && model.friends.isEmpty
              ? const Center(child: Text("Vous n'avez pas encore d'amis !"))
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: width * .02),
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      model.awaitFriends.isNotEmpty
                          ? const Text("Demandes d'amis")
                          : SizedBox(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: model.awaitFriends.length +
                            (model.awaitFriends.isEmpty ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < model.awaitFriends.length) {
                            final data = model.awaitFriends[index];
                            return userTile(data, context, ref, true);
                          } else if (model.awaitFriends.isEmpty) {
                            return null;
                          }
                          return null;
                        },
                      ),
                      model.friends.isNotEmpty
                          ? const Text("Amis")
                          : const SizedBox(),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: model.friends.length +
                            (model.friends.isEmpty ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < model.friends.length) {
                            final data = model.friends[index];
                            return userTile(data, context, ref, false);
                          } else if (model.friends.isEmpty) {
                            return const SizedBox(
                              height: 500,
                            );
                          }
                          return null;
                        },
                      ),
                      model.awaitFriends.isEmpty && model.friends.isNotEmpty
                          ? const SizedBox(
                              height: 500,
                            )
                          : const SizedBox(),
                    ],
                  ),
                )),
    );
  }
}
