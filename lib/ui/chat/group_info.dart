import 'package:athlete_iq/model/User.dart';
import 'package:athlete_iq/ui/chat/providers/active_groups_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/network/userRepository.dart';
import '../../model/Groups.dart';

class GroupInfo extends ConsumerWidget {
  const GroupInfo({Key, key}) : super(key: key);

  static const route = "/groups/group_info";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = ref.watch(activeGroupeProvider);
    final group = ref.watch(streamGroupsProvider(id));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Group Info"),
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Quitter le groupe"),
                        content:
                        const Text("Êtes-vous sur de vouloir quitter le groupe ?"),
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
                            ), onPressed: () {  },
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: group.when(data: (data) {return Container(
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
                          fontWeight: FontWeight.w500, color: Colors.white),
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
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("Admin: id")
                    ],
                  )
                ],
              ),
            ),
            memberList(id),
          ],
        ),
      );} , error: (error, _) {return Text(Error as String);}, loading: () => CircularProgressIndicator()),
    );
  }

  memberList(String id) {
    return Consumer(
    builder: (BuildContext context, WidgetRef ref, Widget? child) {
      final group = ref.watch(streamGroupsProvider(id));
      final userRepo = UserRepository();
      return group.when(data: (data) {
        return ListView.builder(
          itemCount: data.members.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return FutureBuilder<User>(
              future: userRepo.getUserWithId(userId: data.members[index]),
              builder: (context,AsyncSnapshot<User> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (snapshot.hasData) {
                    return Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme
                              .of(context)
                              .primaryColor,
                          child: Text(
                            snapshot.data!.pseudo.substring(0, 1)
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
              }
            );
          },
        );
        } , error: (error, _) {return Text(Error as String);}, loading: () => CircularProgressIndicator());
      },
    );
  }
}
