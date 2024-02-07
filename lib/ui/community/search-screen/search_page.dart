import 'package:athlete_iq/ui/community/search-screen/search_page_view_model_provider.dart';
import '../../../model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  static const route = "/groups/search";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(searchPageViewModelProvider);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title: Card(
          child: TextField(
            decoration: InputDecoration(
              prefixIcon:
                  Icon(Icons.search, size: 24.r), // Ajusté pour la responsivité
              hintText: "Rechercher...",
              border: InputBorder.none,
            ),
            onChanged: (val) => model.name = val,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: model.combineStream(),
        builder: (context, AsyncSnapshot snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshots.data!.length,
              itemBuilder: (context, index) {
                var data = snapshots.data[index];
                var isUser = data.runtimeType == UserModel;
                return Padding(
                  padding: EdgeInsets.all(8.r), // Ajusté pour la responsivité
                  child: Material(
                    elevation: 3.0,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15.r), // Ajusté pour la responsivité
                    ),
                    child: ListTile(
                      title: Text(
                        isUser ? data.pseudo : data.groupName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.sp, // Ajusté pour la responsivité
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        isUser ? "Utilisateur" : "Groupe",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14.sp), // Ajusté pour la responsivité
                      ),
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(isUser ? data.image : data.groupIcon),
                        radius: 25.r, // Ajusté pour la responsivité
                      ),
                      trailing: buildTrailingIcon(isUser, data, _auth, model),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget buildTrailingIcon(
      bool isUser, data, FirebaseAuth _auth, SearchPageViewModel model) {
    return isUser && data.awaitFriends.contains(_auth.currentUser?.uid)
        ? Text('En attente',
            style: TextStyle(fontSize: 14.sp)) // Ajusté pour la responsivité
        : IconButton(
            onPressed: () {
              isUser
                  ? data.friends.contains(_auth.currentUser?.uid)
                      ? model.removeFriend(data)
                      : model.addFriend(data.id)
                  : data.members.contains(_auth.currentUser?.uid)
                      ? model.removeUserToGroup(data)
                      : model.addUserToGroup(data);
            },
            icon: Icon(
              isUser
                  ? data.friends.contains(_auth.currentUser?.uid)
                      ? UniconsLine.user_minus
                      : UniconsLine.user_plus
                  : data.members.contains(_auth.currentUser?.uid)
                      ? UniconsLine.exit
                      : UniconsLine.angle_right_b,
              color: isUser ? Colors.green : Colors.grey,
              size: 24.r,
            ),
          );
  }
}
