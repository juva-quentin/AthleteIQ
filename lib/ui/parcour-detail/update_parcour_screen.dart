import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../ui/parcour-detail/parcour_details_view_model.dart';
import '../../utils/utils.dart';
import '../../utils/visibility.dart';
import '../info/provider/user_provider.dart';

class UpdateParcourScreen extends ConsumerWidget {
  UpdateParcourScreen({super.key});
  final _formUpdateKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(parcourDetailsViewModel);
    final userAsyncValue = ref.watch(firestoreUserProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Form(
              key: _formUpdateKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Modification',
                      style: TextStyle(fontSize: 24.sp),
                    ),
                    SizedBox(height: 20.h),
                    TextFormField(
                      initialValue: model.title,
                      decoration: InputDecoration(
                        labelText: 'Titre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      onChanged: (value) => model.title = value,
                    ),
                    SizedBox(height: 20.h),
                    TextFormField(
                      initialValue: model.description,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      maxLines: 3,
                      onChanged: (value) => model.description = value,
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      onTap: () => model.changeVisibility(),
                      child: Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorLight,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(model.switchCaseIconVisibility(), size: 24.w),
                            SizedBox(width: 10.w),
                            Text(
                              model.switchCaseVisibility(),
                              style: TextStyle(fontSize: 20.sp),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (model.visibility == ParcourVisibility.Protected)
                      userAsyncValue.when(
                        data: (user) => Column(
                          children: user.friends.map((friendId) {
                            final friend = ref
                                .watch(firestoreUserFriendsProvider(friendId));
                            return friend.when(
                              data: (friendData) => CheckboxListTile(
                                title: Text(friendData.pseudo),
                                value: model.share.contains(friendId),
                                onChanged: (bool? value) {
                                  model.addRemoveFriend(value, friendId);
                                },
                              ),
                              loading: () => const CircularProgressIndicator(),
                              error: (_, __) =>
                                  const Text('Impossible de charger les données'),
                            );
                          }).toList(),
                        ),
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) =>
                            const Text('Erreur lors du chargement des amis'),
                      ),
                    SizedBox(height: 20.h),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formUpdateKey.currentState!.validate()) {
                          try {
                            await model.updateParcour();
                            Navigator.pop(context);
                          } catch (e) {
                            Utils.flushBarErrorMessage(e.toString(), context);
                          }
                        }
                      },
                      child: Text(
                        'Sauvegarder',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      child: Text(
                        'Annuler',
                        style: TextStyle(fontSize: 20.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
