import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import '../../model/User.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier un parcours"),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: _formUpdateKey,
              child: Column(
                children: [
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un titre';
                      }
                      return null;
                    },
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
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
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
                          Text(
                            "Visibilité : ${model.visibility == ParcourVisibility.Public ? 'Public' : model.visibility == ParcourVisibility.Protected ? 'Entre amis' : 'Privé'}",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          Icon(
                            model.visibility == ParcourVisibility.Public
                                ? UniconsLine.globe
                                : model.visibility == ParcourVisibility.Protected
                                ? Icons.shield
                                : UniconsLine.lock,
                            size: 20.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (model.visibility == ParcourVisibility.Protected)
                    FriendsShareList(model: model),
                  SizedBox(height: 20.h),
                  ElevatedButton.icon(
                    onPressed: () async {
                      if (_formUpdateKey.currentState!.validate()) {
                        try {
                          await model.updateParcour();
                          Navigator.of(context).pop();
                        } catch (e) {
                          Utils.flushBarErrorMessage(e.toString(), context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      elevation: 5,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                    icon: const Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
                      child: Icon(UniconsLine.edit, color: Colors.white),
                    ),
                    label: Padding(
                      padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
                      child: Text(
                        'Modifier',
                        style: TextStyle(fontSize: 15.sp, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  final ParcourDetailsViewModel model;

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