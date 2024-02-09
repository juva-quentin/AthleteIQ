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
  const GroupInfo(this.args, {Key? key}) : super(key: key);
  final Object args;
  static const route = "/groups/group_info";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(streamGroupsProvider(args.toString()));
    final userRepo = ref.watch(userRepositoryProvider);
    final model = ref.watch(chatViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(
            UniconsLine.arrow_left,
            size: 35.w,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Information",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        actions: [
          group.when(
            data: (data) {
              return FutureBuilder<UserModel>(
                future: userRepo.getUserWithId(userId: data.admin),
                builder: (context, AsyncSnapshot<UserModel> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      return model.isAdmin(data.admin)
                          ? IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  CustomPopupRoute(
                                    builder: (BuildContext context) {
                                      return UpdateGroupScreen(
                                        groupId: args.toString(),
                                      );
                                    },
                                  ),
                                );
                              },
                              icon: Icon(Icons.edit,
                                  size: 28.w, color: Colors.white),
                            )
                          : IconButton(
                              onPressed: () {
                                showDialog(
                                  barrierDismissible: false,
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Quitter le groupe"),
                                      content: const Text(
                                          "Êtes-vous sûr de vouloir quitter le groupe ?"),
                                      actions: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.done,
                                            color: Colors.green,
                                          ),
                                          onPressed: () async {
                                            try {
                                              await model.removeUserToGroup();
                                            } catch (e) {
                                              Utils.flushBarErrorMessage(
                                                  e.toString(), context);
                                            }
                                            Navigator.pushNamed(
                                                context, App.route);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(Icons.exit_to_app,
                                  size: 35.w, color: Colors.white),
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
            error: (error, _) => Text(error.toString()),
            loading: () => const CircularProgressIndicator(),
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
                    borderRadius: BorderRadius.circular(30.r),
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          data.groupName.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 18.sp,
                          ),
                        ),
                      ),
                      SizedBox(width: 20.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Group: ${data.groupName}",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18.sp,
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
                                    "Admin: ${snapshot.data?.pseudo}",
                                    style: TextStyle(fontSize: 16.sp),
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
            return ListView.builder(
              itemCount: data.members.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return FutureBuilder<UserModel>(
                  future: userRepo.getUserWithId(userId: data.members[index]),
                  builder: (context, AsyncSnapshot<UserModel> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text('Error');
                      } else if (snapshot.hasData) {
                        return Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 10.h),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30.r,
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text(
                                snapshot.data!.pseudo
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              snapshot.data!.pseudo,
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            subtitle: Text(
                              'Utilisateur',
                              style: TextStyle(fontSize: 14.sp),
                            ),
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
            );
          },
          error: (error, _) => Text(error.toString()),
          loading: () => const CircularProgressIndicator(),
        );
      },
    );
  }
}
