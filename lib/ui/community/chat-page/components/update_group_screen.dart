import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/ui/community/providers/groups_view_model_provider.dart';
import 'package:athlete_iq/utils/visibility.dart';
import '../../../../model/User.dart';
import '../../../../utils/utils.dart';
import '../../../info/provider/user_provider.dart';
import '../../../providers/loading_provider.dart';

class UpdateGroupScreen extends ConsumerWidget {
  const UpdateGroupScreen({super.key, required this.groupId});
  final String groupId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(groupsViewModelProvider);
    final user = ref.watch(firestoreUserProvider);
    final isLoading = ref.watch(loadingProvider);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context, ref, model, user, isLoading),
    );
  }

  Widget contentBox(BuildContext context, WidgetRef ref, GroupsViewModel model,
      AsyncValue<UserModel> user, Loading isLoading) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black, offset: Offset(0, 10.h), blurRadius: 10.r),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: 15.h),
            Text(
              'Modification du groupe',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15.h),
            const Divider(),
            TextFormField(
              controller: model.titleController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Titre",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              onChanged: (v) => model.actu(),
            ),
            SizedBox(height: 20.h),
            VisibilityOptionButton(model: model),
            SizedBox(height: 20.h),
            model.visibility == GroupType.Private
                ? FriendsList(user: user, model: model)
                : const SizedBox(),
            SizedBox(height: 20.h),
            const Divider(),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  // Utilisation de Expanded pour un meilleur contrôle de la largeur
                  child: Padding(
                    padding: EdgeInsets.only(
                        right:
                            8.w), // Ajout d'un peu d'espace entre les boutons
                    child: ActionButton(
                      text: 'Annuler',
                      color: Colors.grey.shade400,
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
                Expanded(
                  // Utilisation de Expanded pour un meilleur contrôle de la largeur
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 8.w), // Ajout d'un peu d'espace entre les boutons
                    child: ActionButton(
                      text: 'Modifier',
                      color: isLoading.loading ? Colors.grey : Colors.blue,
                      onTap: isLoading.loading
                          ? null
                          : () async {
                              ref
                                  .read(loadingProvider.notifier)
                                  .start(); // Assurez-vous que cette méthode existe dans votre provider
                              try {
                                await model.updateUser().then(
                                      (value) => Utils.toastMessage(
                                          "Le groupe à été mis à jour"),
                                    );
                                Navigator.of(context).pop();
                              } catch (e) {
                                Utils.flushBarErrorMessage(
                                    e.toString(), context);
                              } finally {
                                ref
                                    .read(loadingProvider.notifier)
                                    .stop(); // Assurez-vous que cette méthode existe dans votre provider
                              }
                            },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15.h),
          ],
        ),
      ),
    );
  }
}

class VisibilityOptionButton extends StatelessWidget {
  const VisibilityOptionButton({
    super.key,
    required this.model,
  });

  final GroupsViewModel model;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: model.changeVisibility,
      child: Container(
        alignment: Alignment.center,
        width: 0.5.sw, // 50% of screen width
        height: 60.h,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColorLight,
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              model.switchCaseVisibility(),
              style: TextStyle(fontSize: 16.sp),
            ),
            Icon(
              model.switchCaseIconVisibility(),
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}

class FriendsList extends ConsumerWidget {
  const FriendsList({
    super.key,
    required this.user,
    required this.model,
  });

  final AsyncValue<UserModel> user;
  final GroupsViewModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return user.when(
      data: (user) {
        if (user.friends.isEmpty) {
          return Text(
            'Vous n\'avez pas encore d\'amis',
            style: TextStyle(fontSize: 14.sp),
          );
        }

        return Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15.r),
          ),
          height: 200.h,
          child: ListView.builder(
            itemCount: user.friends.length,
            itemBuilder: (BuildContext context, int index) {
              final friendId = user.friends[index];
              return FriendItem(friendId: friendId, model: model);
            },
          ),
        );
      },
      error: (error, stackTrace) =>
          Text(error.toString(), style: TextStyle(fontSize: 14.sp)),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class FriendItem extends ConsumerWidget {
  const FriendItem({
    super.key,
    required this.friendId,
    required this.model,
  });

  final String friendId;
  final GroupsViewModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friend = ref.watch(firestoreUserFriendsProvider(friendId));

    return friend.when(
      data: (data) {
        return CheckboxListTile(
          title: Text(data.pseudo, style: TextStyle(fontSize: 14.sp)),
          value: model.share.contains(data.id),
          onChanged: (bool? value) {
            model.addRemoveFriend(value, data.id);
          },
        );
      },
      error: (error, stackTrace) =>
          Text(error.toString(), style: TextStyle(fontSize: 14.sp)),
      loading: () => const CircularProgressIndicator(),
    );
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.color,
    required this.text,
    required this.onTap,
  });

  final Color color;
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: 0.4.sw,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(15.r)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}
