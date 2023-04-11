import 'package:athlete_iq/model/User.dart';
import 'package:athlete_iq/ui/community/chat-page/chat_view_model_provider.dart';
import 'package:athlete_iq/ui/community/providers/active_groups_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../../../app/app.dart';
import '../../../../data/network/userRepository.dart';
import '../../../../utils/utils.dart';

class GroupInfo extends ConsumerWidget {
  GroupInfo(this.args, {Key, key}) : super(key: key);
  Object args;
  static const route = "/groups/group_info";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
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
            size: width * .1,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Information",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w600,
                color: Colors.white)),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Quitter le groupe"),
                        content: const Text(
                            "Êtes-vous sur de vouloir quitter le groupe ?"),
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
                              Navigator.pushNamed(context, App.route);
                            },
                          ),
                        ],
                      );
                    });
              },
              icon: Icon(Icons.exit_to_app,
                  size: width * .1, color: Colors.white))
        ],
      ),
      body: group.when(
          data: (data) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Theme.of(context).primaryColor.withOpacity(0.2)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            data.groupName.substring(0, 1).toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Group: ${data.groupName}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            FutureBuilder<User>(
                                future:
                                    userRepo.getUserWithId(userId: data.admin),
                                builder:
                                    (context, AsyncSnapshot<User> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasError) {
                                      return const Text('Error');
                                    } else if (snapshot.hasData) {
                                      return Text(
                                          "Admin: ${snapshot.data?.pseudo}");
                                    } else {
                                      return const Text('Empty data');
                                    }
                                  } else {
                                    return Text(
                                        'State: ${snapshot.connectionState}');
                                  }
                                }),
                          ],
                        )
                      ],
                    ),
                  ),
                  memberList(args.toString()),
                ],
              ),
            );
          },
          error: (error, _) {
            return Text(Error as String);
          },
          loading: () => const CircularProgressIndicator()),
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
                  return FutureBuilder<User>(
                      future:
                          userRepo.getUserWithId(userId: data.members[index]),
                      builder: (context, AsyncSnapshot<User> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.connectionState ==
                            ConnectionState.done) {
                          if (snapshot.hasError) {
                            return const Text('Error');
                          } else if (snapshot.hasData) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  child: Text(
                                    snapshot.data!.pseudo
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                title: Text(snapshot.data!.pseudo),
                                subtitle: const Text('Utilisateur'),
                              ),
                            );
                          } else {
                            return const Text('Empty data');
                          }
                        } else {
                          return Text('State: ${snapshot.connectionState}');
                        }
                      });
                },
              );
            },
            error: (error, _) {
              return Text(Error as String);
            },
            loading: () => const CircularProgressIndicator());
      },
    );
  }
}
