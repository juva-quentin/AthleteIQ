import 'package:athlete_iq/ui/info/components/userTileComponent.dart';
import 'package:athlete_iq/ui/info/friend-list/friends_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/utils.dart';

class FriendsListScreen extends ConsumerStatefulWidget {
  const FriendsListScreen({Key? key}) : super(key: key);

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
    print(model.awaitFriends);
    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      backgroundColor: Theme.of(context).primaryColor,
      color: Theme.of(context).indicatorColor,
      strokeWidth: 3,
      onRefresh: () async {
        try {
          await model.loadFriends();
        } catch (e) {
          Utils.flushBarErrorMessage(e.toString(), context);
        }
      },
      child: model.awaitFriends.isEmpty && model.friends.isEmpty
          ? const Center(child: Text("Vous n'avez pas encore d'amis !"))
          : CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: width * .02),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (model.awaitFriends.isNotEmpty)
                        const Center(child: Text("Demandes d'amis")),
                    ]),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < model.awaitFriends.length) {
                        final data = model.awaitFriends[index];
                        return userTile(data, context, ref, true);
                      } else if (model.awaitFriends.isEmpty && index == 0) {
                        return null;
                      }
                      return null;
                    },
                    childCount: model.awaitFriends.length +
                        (model.awaitFriends.isEmpty ? 1 : 0),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: width * .02),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      if (model.friends.isNotEmpty)
                        const Center(child: Text("Amis")),
                    ]),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < model.friends.length) {
                        final data = model.friends[index];
                        return userTile(data, context, ref, false);
                      } else if (model.friends.isEmpty && index == 0) {
                        return const SizedBox(
                          height: 500,
                        );
                      }
                      return null;
                    },
                    childCount:
                        model.friends.length + (model.friends.isEmpty ? 1 : 0),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height:
                        (model.awaitFriends.isEmpty && model.friends.isNotEmpty)
                            ? 500
                            : 0,
                  ),
                ),
              ],
            ),
    );
  }
}
