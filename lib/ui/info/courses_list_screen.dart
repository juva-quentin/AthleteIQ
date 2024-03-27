import 'package:athlete_iq/ui/info/components/parcourTileComponent.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/Parcour.dart';
import 'info_view_model_provider.dart';

class CoursesListScreen extends ConsumerWidget {
  const CoursesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(infoViewModelProvider);

    return StreamBuilder(
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
            return const Center(child: Text("Une erreur s'est produite ⚠️"));
          } else if (snapshot.hasData && snapshot.data.length > 0) {
            List<Parcours> parcours = snapshot.data;
            return ListView.builder(
                itemCount: parcours.length,
                padding: EdgeInsets.only(bottom: 70.h, top: 10.h),
                itemBuilder: (context, index) {
                  return Padding(
                    padding:  EdgeInsets.symmetric(
                        vertical: 0.00.sh, horizontal: 0.02.sw),
                    child: parcourTile(parcours[index], context, ref),
                  );
                });
          } else {
            return const Center(
                child: Text("Vous n'avez pas de parcours enregistré"));
          }
        } else {
          return Center(child: Text('Avancement: ${snapshot.connectionState}'));
        }
      },
    );
  }
}
