import 'package:athlete_iq/ui/info/components/parcourTileComponent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/Parcour.dart';
import '../chat/components/group_tile.dart';
import 'info_view_model_provider.dart';

class CoursesListScreen extends ConsumerWidget {
  const CoursesListScreen({Key, key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(infoViewModelProvider);
    return Scaffold(
      body: StreamBuilder(
        stream: model.parcourRepository.parcoursStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              List<Parcours> parcours = snapshot.data;
              return ListView.builder( itemCount: parcours.length,
                  itemBuilder: (context, index) {
                    return parcourTile(
                        parcours[index], context, ref);
                  });
            } else {
              return const Text('Empty data');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }
}
