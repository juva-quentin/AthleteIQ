import 'dart:ffi';

import 'package:athlete_iq/data/network/groupsRepository.dart';
import 'package:athlete_iq/data/network/userRepository.dart';
import 'package:athlete_iq/ui/chat/search_page_view_model_provider.dart';
import 'package:athlete_iq/ui/info/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'package:unicons/unicons.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({Key, key}) : super(key: key);

  static const route = "/groups/search";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(searchPageViewModelProvider);
    final usersFirestore = ref.watch(userRepositoryProvider);
    final groupsFirestore = ref.watch(groupsRepositoryProvider);
    var streams = CombineLatestStream.list(
        [usersFirestore.usersStream, groupsFirestore.groupsStream]);
    return Scaffold(
      appBar: AppBar(
        title: Card(
            child: TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search), hintText: "Rechercher...", border: InputBorder.none),
                onChanged: (val) => model.name = val)),
      ),
      body: StreamBuilder(
        stream: streams,
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            List<QuerySnapshot> querySnapshot = snapshots.data!.toList();

            List<QueryDocumentSnapshot> documentSnapshot = [];

            querySnapshot.forEach((query) {
              documentSnapshot.addAll(query.docs);
            });

            List<Map<String, dynamic>> mappedData = [];

            for (QueryDocumentSnapshot doc in documentSnapshot) {
              mappedData.add(doc.data()! as Map<String, dynamic>);
            }
            return ListView.builder(
                itemCount: mappedData.length,
                itemBuilder: (context, index) {
                  var data = mappedData[index];
                  var isUser = data.keys.contains('pseudo');
                  if (model.name.isEmpty) {
                    return ListTile(
                      title: Text(
                        isUser ? data['pseudo'] : data['groupName'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(isUser ? "Utilisateur" : "Groupe",
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            isUser ? data['image'] : data['groupIcon']),
                      ),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            isUser
                                ? UniconsLine.user_plus
                                : UniconsLine.angle_right_b,
                            color: isUser ? Colors.green : Colors.grey,
                          )),
                    );
                  }
                  if (data['pseudo']
                          .toString()
                          .toLowerCase()
                          .startsWith(model.name.toLowerCase()) ||
                      data['groupName']
                          .toString()
                          .toLowerCase()
                          .startsWith(model.name.toLowerCase())) {
                    return ListTile(
                      title: Text(
                        isUser ? data['pseudo'] : data['groupName'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(isUser ? "Utilisateur" : "Groupe",
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            isUser ? data['image'] : data['groupIcon']),
                      ),
                      trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            isUser
                                ? UniconsLine.user_plus
                                : UniconsLine.angle_right_b,
                            color: isUser ? Colors.green : Colors.grey,
                          )),
                    );
                  }
                  return Container();
                });
          }
        },
      ),
    );
  }
}
