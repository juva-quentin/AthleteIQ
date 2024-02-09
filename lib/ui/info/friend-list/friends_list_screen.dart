import 'package:athlete_iq/ui/info/components/userTileComponent.dart';
import 'package:athlete_iq/ui/info/friend-list/friends_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      backgroundColor: Theme.of(context).primaryColor,
      color: Theme.of(context).indicatorColor,
      strokeWidth: 3.w, // Adjusted for responsiveness
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
                if (model.awaitFriends.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 0.02.sw), // Adjusted for responsiveness
                      child: const Center(child: Text("Demandes d'amis")),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        userTile(model.awaitFriends[index], context, ref, true),
                    childCount: model.awaitFriends.length,
                  ),
                ),
                if (model.friends.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
                      child: const Center(child: Text("Amis")),
                    ),
                  ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) =>
                        userTile(model.friends[index], context, ref, false),
                    childCount: model.friends.length,
                  ),
                ),
              ],
            ),
    );
  }
}
