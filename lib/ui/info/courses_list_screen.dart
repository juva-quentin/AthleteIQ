import 'package:athlete_iq/ui/info/components/parcourTileComponent.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder(
        stream: model.parcourRepository.parcoursStream,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.active ||
              snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              if (kDebugMode) {
                print(snapshot.error.toString());
              }
              Utils.flushBarErrorMessage(snapshot.error.toString(), context);
              return const Center(child:Text("Une érreure c'est produite ⚠️"));
            } else if (snapshot.hasData) {
              List<Parcours> parcours = snapshot.data;
              return ListView.builder( itemCount: parcours.length,
                  padding: EdgeInsets.symmetric(vertical: height *.02, horizontal: width*.02),
                  itemBuilder: (context, index) {
                    return parcourTile(
                        parcours[index], context, ref);
                  });
            } else {
              return const Center(child: Text("Vous n'avez pas de parcours enregistré"));
            }
          } else {
            return Center(child: Text('Avancement: ${snapshot.connectionState}'));
          }
        },
      ),
    );
  }
}
