import 'package:athlete_iq/ui/register/register_view_model_provider.dart';
import 'package:athlete_iq/utils/visibility.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../model/User.dart';
import '../../utils/utils.dart';
import '../home/providers/timer_provider.dart';
import '../info/provider/user_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formRegisterKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(registerViewModelProvider);

    final modelChrono = ref.watch(timerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Enregistrement de parcours"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formRegisterKey,
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      height: 250.h,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: GoogleMap(
                        polylines: model.polylines,
                        indoorViewEnabled: true,
                        myLocationButtonEnabled: false,
                        mapType: MapType.normal,
                        onMapCreated: model.onMapCreated,
                        initialCameraPosition: model.initialPosition,
                        scrollGesturesEnabled: false,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Temps:',
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${modelChrono.hour.toString().padLeft(2, '0')}:${modelChrono.minute.toString().padLeft(2, '0')}:${modelChrono.seconds.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Distance:',
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${model.totalDistance.toStringAsFixed(2)} KM',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Vitesse Moyenne:',
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${model.VM.toStringAsFixed(1)} Km/h',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Titre',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onChanged: (v) => model.title = v,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un titre';
                      }
                      return null; // Si le champ est valide
                    },
                  ),
                  SizedBox(height: 20.h),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onChanged: (v) => model.description = v,
                    maxLines: 3,
                    validator: (value) {
                      // Ajoutez une validation si nécessaire pour la description
                      return null; // Si le champ est valide ou non requis
                    },
                  ),
                  SizedBox(height: 20.h),
                  VisibilitySwitch(model: model),
                  SizedBox(height: 20.h),
                  if (model.visibility == ParcourVisibility.Protected)
                    FriendsShareList(model: model),
                  SizedBox(height: 60.h),
                ],
              ),
            ),
          ),

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formRegisterKey.currentState!.validate()) {
            try {
              model.register();
              Navigator.of(context).pop();
            } catch (e) {
              Utils.flushBarErrorMessage(e.toString(), context);
            }
          }
        },
        backgroundColor: Colors.blue, // Couleur du bouton changée en bleu
        child: Icon(Icons.check, color: Colors.white), // Icône du bouton "Valider"
      ),
    );
  }
}

class VisibilitySwitch extends StatelessWidget {
  const VisibilitySwitch({Key? key, required this.model}) : super(key: key);

  final RegisterViewModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: model.changeVisibility,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(model.switchCaseVisibility(),
                style: TextStyle(fontSize: 16.sp)),
            Icon(model.switchCaseIconVisibility(), size: 24.w),
          ],
        ),
      ),
    );
  }
}

class FriendsShareList extends ConsumerWidget {
  const FriendsShareList({
    Key? key,
    required this.model,
  }) : super(key: key);

  final RegisterViewModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<UserModel> user = ref.watch(firestoreUserProvider);

    return user.when(
      data: (userData) {
        if (userData.friends.isNotEmpty) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
            margin: EdgeInsets.only(top: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "Partager avec des amis",
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: userData.friends.length,
                  itemBuilder: (BuildContext context, int index) {
                    final friendId = userData.friends[index];
                    return ref
                        .watch(firestoreUserFriendsProvider(friendId))
                        .when(
                          data: (friendDetails) => CheckboxListTile(
                            title: Text(
                              friendDetails.pseudo,
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            value: model.share.contains(friendId),
                            onChanged: (bool? value) {
                              model.addRemoveFriend(value, friendId);
                            },
                            secondary: CircleAvatar(
                              // Ajoutez ici l'image de l'ami si disponible
                              backgroundImage:
                                  NetworkImage(friendDetails.image),
                            ),
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                          loading: () => SizedBox(
                              width: 20.w,
                              height: 20.h,
                              child: CircularProgressIndicator()),
                          error: (error, stack) => ListTile(
                            title: Text('Impossible de charger les détails',
                                style: TextStyle(fontSize: 14.sp)),
                          ),
                        );
                  },
                ),
              ],
            ),
          );
        } else {
          return Padding(
            padding: EdgeInsets.all(8.w),
            child: Text(
              'Vous n\'avez pas encore d\'amis à partager',
              style: TextStyle(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
          );
        }
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Erreur lors du chargement des données',
          style: TextStyle(fontSize: 14.sp)),
    );
  }
}
