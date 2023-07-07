import 'package:athlete_iq/ui/info/components/parcourTileComponent.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'fav_view_model_provider.dart';

class FavListScreen extends ConsumerStatefulWidget {
  const FavListScreen({Key? key}) : super(key: key);

  @override
  FavListState createState() => FavListState();
}

class FavListState extends ConsumerState<FavListScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(favListViewModelProvider).init();
  }
  @override
  Widget build(BuildContext context) {
    final model = ref.watch(favListViewModelProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      backgroundColor: Theme.of(context).primaryColor,
      color: Theme.of(context).indicatorColor,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      onRefresh: () async {
        try {
          await model.loadFavs();
        } catch (e) {
          Utils.flushBarErrorMessage(e.toString(), context);
        }
      },
      child: model.favParcour.isEmpty
          ? const Center(child: Text("Vous n'avez pas encore de favoris !"))
          : CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
                vertical: height * .02, horizontal: width * .02),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return parcourTile(
                      model.favParcour[index], context, ref);
                },
                childCount: model.favParcour.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
