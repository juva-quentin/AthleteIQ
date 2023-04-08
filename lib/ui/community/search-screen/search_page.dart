import 'package:athlete_iq/ui/community/search-screen/search_page_view_model_provider.dart';
import '../../../model/User.dart' as userModel;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({Key, key}) : super(key: key);

  static const route = "/groups/search";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(searchPageViewModelProvider);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Card(
            child: TextField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Rechercher...",
                    border: InputBorder.none),
                onChanged: (val) => model.name = val)),
      ),
      body: StreamBuilder(
        stream: model.combineStream(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
                itemCount: snapshots.data.length,
                itemBuilder: (context, index) {
                  var data = snapshots.data[index];
                  var isUser = data.runtimeType == userModel.User;
                  if (model.name.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 3.0,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            isUser ? data.pseudo : data.groupName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(isUser ? "Utilisateur" : "Groupe",
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                isUser ? data.image : data.groupIcon),
                          ),
                          trailing: isUser &&
                                  data.awaitFriends
                                      .contains(_auth.currentUser?.uid)
                              ? const Text('En attente')
                              : IconButton(
                                  onPressed: () {
                                    isUser
                                        ? data.friends.contains(
                                                _auth.currentUser?.uid)
                                            ? model.removeFriend(data)
                                            : model.addFriend(data.id)
                                        : data.members.contains(
                                                _auth.currentUser?.uid)
                                            ? model.removeUserToGroup(data)
                                            : model.addUserToGroup(data);
                                  },
                                  icon: Icon(
                                    isUser
                                        ? data.friends.contains(
                                        _auth.currentUser?.uid)
                                        ? UniconsLine.user_minus : UniconsLine.user_plus
                                        : data.members.contains(
                                                _auth.currentUser?.uid)
                                            ? UniconsLine.exit
                                            : UniconsLine.angle_right_b,
                                    color: isUser ? Colors.green : Colors.grey,
                                  )),
                        ),
                      ),
                    );
                  }
                  if (isUser
                      ? data.pseudo
                          .toString()
                          .toLowerCase()
                          .startsWith(model.name.toLowerCase())
                      : data.groupName
                          .toString()
                          .toLowerCase()
                          .startsWith(model.name.toLowerCase())) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 3.0,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            isUser ? data.pseudo : data.groupName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(isUser ? "Utilisateur" : "Groupe",
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                isUser ? data.image : data.groupIcon),
                          ),
                          trailing: isUser &&
                                  data.awaitFriends
                                      .contains(_auth.currentUser?.uid)
                              ? const Text('En attente')
                              : IconButton(
                                  onPressed: () {
                                    isUser
                                        ? model.addFriend(data.id)
                                        : data.members.contains(
                                                _auth.currentUser?.uid)
                                            ? model.removeUserToGroup(data)
                                            : model.addUserToGroup(data);
                                  },
                                  icon: Icon(
                                    isUser
                                        ? UniconsLine.user_plus
                                        : data.members.contains(
                                                _auth.currentUser?.uid)
                                            ? UniconsLine.exit
                                            : UniconsLine.angle_right_b,
                                    color: isUser ? Colors.green : Colors.grey,
                                  )),
                        ),
                      ),
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
