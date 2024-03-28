import 'package:athlete_iq/model/User.dart';
import 'package:athlete_iq/ui/community/chat-page/chat_view_model_provider.dart';
import 'package:athlete_iq/ui/community/chat-page/components/update_group_screen.dart';
import 'package:athlete_iq/ui/community/providers/active_groups_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../../../app/app.dart';
import '../../../../data/network/userRepository.dart';
import '../../../../utils/routes/customPopupRoute.dart';
import '../../../../utils/utils.dart';

class GroupInfo extends ConsumerWidget {
  const GroupInfo(this.args, {super.key});
  final Object args;
  static const route = "/groups/group_info";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(streamGroupsProvider(args.toString()));
    final userRepo = ref.watch(userRepositoryProvider);
    final model = ref.watch(chatViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Information du groupe"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        elevation: 0,
        actions: [
          group.when(
            data: (data) => model.isAdmin(data.admin)
                ? IconButton(
              icon: const Icon(UniconsLine.edit),
              onPressed: () {
                Navigator.of(context).push(
                  CustomPopupRoute(
                    builder: (_) => UpdateGroupScreen(groupId: args.toString()),
                  ),
                );
              },
            )
                : IconButton(
              icon: const Icon(UniconsLine.exit),
              onPressed: () => _confirmExitGroupDialog(context, model),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Icon(UniconsLine.circle, color: Colors.red),
          ),
        ],
      ),
      body: group.when(
        data: (data) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(20.r),
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(data.groupIcon),
                        radius: 30.r,
                      ),
                      SizedBox(width: 20.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Groupe: ${data.groupName}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          FutureBuilder<UserModel>(
                            future: userRepo.getUserWithId(userId: data.admin),
                            builder:
                                (context, AsyncSnapshot<UserModel> snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                if (snapshot.hasError) {
                                  return const Text('Error');
                                } else if (snapshot.hasData) {
                                  return Text(
                                    "Administrateur: ${snapshot.data?.pseudo}",
                                    style: TextStyle(fontSize: 13.sp),
                                  );
                                } else {
                                  return const Text('Empty data');
                                }
                              } else {
                                return Text(
                                    'State: ${snapshot.connectionState}');
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                memberList(args.toString()),
              ],
            ),
          );
        },
        error: (error, _) => Text(error.toString()),
        loading: () => const CircularProgressIndicator(),
      ),
    );
  }

  memberList(String id) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final group = ref.watch(streamGroupsProvider(id));
        final userRepo = ref.watch(userRepositoryProvider);
        return group.when(
          data: (data) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Text(
                    "${data.members.length} Membres",
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  itemCount: data.members.length,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return FutureBuilder<UserModel>(
                      future: userRepo.getUserWithId(userId: data.members[index]),
                      builder: (context, AsyncSnapshot<UserModel> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasError) {
                            return const Text('Error');
                          } else if (snapshot.hasData) {
                            return ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(snapshot.data!.image),
                                radius: 24.r,
                              ),
                              title: Text(
                                snapshot.data!.pseudo,
                                style: TextStyle(fontSize: 16.sp),
                              ),
                              subtitle: Text(
                                "Objectif : ${snapshot.data!.objectif.toString()}Km",
                                style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                              ),
                            );
                          } else {
                            return const Text('Empty data');
                          }
                        } else {
                          return Text('State: ${snapshot.connectionState}');
                        }
                      },
                    );
                  },
                ),
              ],
            );
          },
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        );
      },
    );
  }
}

  void _confirmExitGroupDialog(BuildContext context, ChatViewModel model) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("Quitter le groupe"),
      content: Text("Êtes-vous sûr de vouloir quitter ce groupe ?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Annuler"),
        ),
        TextButton(
          onPressed: () async {
            await model.removeUserToGroup();
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
          child: Text("Quitter", style: TextStyle(color: Theme.of(context).errorColor)),
        ),
      ],
    ),
  );
}