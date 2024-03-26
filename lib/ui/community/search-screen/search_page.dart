import 'package:athlete_iq/ui/community/search-screen/search_page_view_model_provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../model/Groups.dart';
import '../../../model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../../resources/components/middleAnimatedBar.dart';

enum SearchTab { Groupes, Utilisateurs }

class SearchPage extends ConsumerWidget {
  const SearchPage({super.key});

  static const route = "/groups/search";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(searchPageViewModelProvider);
    final selectedTab = ValueNotifier<SearchTab>(SearchTab.Utilisateurs);
    final TextEditingController searchController = TextEditingController();
    print(selectedTab.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recherche"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, size: 24.r),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    model.clearName();
                  },
                ),
                hintText: "Rechercher...",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r)),
                fillColor: Colors.white,
                filled: true,
              ),
              onChanged: (value) {
                searchController.value = TextEditingValue(
                  text: value,
                  selection: TextSelection.collapsed(offset: value.length),
                );
              },
            ),
          ),
          ValueListenableBuilder(
            valueListenable: selectedTab,
            builder: (context, SearchTab value, _) {
              return Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2,
                      color: Colors.blue, // La couleur de la barre
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    buildTabButton(context, SearchTab.Utilisateurs,
                        value == SearchTab.Utilisateurs, selectedTab),
                    buildTabButton(context, SearchTab.Groupes,
                        value == SearchTab.Groupes, selectedTab),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: ValueListenableBuilder<SearchTab>(
              valueListenable: selectedTab,
              builder: (_, value, __) {
                return StreamBuilder(
                  stream: model.combineStream(),
                  builder: (context, AsyncSnapshot snapshots) {
                    if (snapshots.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      List<UserModel> usersList =
                          snapshots.data!.whereType<UserModel>().toList();
                      List<Groups> groupsList =
                          snapshots.data!.whereType<Groups>().toList();

                      switch (value) {
                        case SearchTab.Utilisateurs:
                          return SizedBox(
                            child: buildUsersList(usersList, model, context),
                          );
                        case SearchTab.Groupes:
                          return SizedBox(
                            child: buildGroupsList(groupsList, model, context),
                          );
                        default:
                          return Container();
                      }
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildGroupsList(
      List<Groups> groups, SearchPageViewModel model, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return buildGroupTile(groups[index], model, context);
      },
    );
  }

  Widget buildUsersList(
      List<UserModel> users, SearchPageViewModel model, BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        return buildUserTile(users[index], model, context);
      },
    );
  }

  Widget buildUserTile(
      UserModel user, SearchPageViewModel model, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(user.image),
        radius: 25.r,
      ),
      title: Text(
        user.pseudo,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "Utilisateur",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 14.sp),
      ),
      trailing: buildTrailingIcon(true, user, FirebaseAuth.instance, model),
    );
  }

  Widget buildGroupTile(
      Groups group, SearchPageViewModel model, BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(group.groupIcon),
        radius: 25.r,
      ),
      title: Text(
        group.groupName,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "Groupe",
        style: TextStyle(fontSize: 14.sp),
      ),
      trailing: buildTrailingIcon(false, group, FirebaseAuth.instance, model),
    );
  }

  Widget buildTabButton(BuildContext context, SearchTab tab, bool isSelected,
      ValueNotifier<SearchTab> selectedTab) {
    String text = tab == SearchTab.Utilisateurs ? "Utilisateurs" : "Groupes";
    return Expanded(
      child: InkWell(
        onTap: () => selectedTab.value = tab,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: TextStyle(
                  color: isSelected ? Colors.black : Colors.grey,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (isSelected) SizedBox(height: 3.h),
              MiddleAnimatedBar(
                isActive: isSelected,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTrailingIcon(
      bool isUser, data, FirebaseAuth auth, SearchPageViewModel model) {
    return isUser && data.awaitFriends.contains(auth.currentUser?.uid)
        ? Text('En attente', style: TextStyle(fontSize: 14.sp))
        : IconButton(
            onPressed: () {
              isUser
                  ? data.friends.contains(auth.currentUser?.uid)
                      ? model.removeFriend(data)
                      : model.addFriend(data.id)
                  : data.members.contains(auth.currentUser?.uid)
                      ? model.removeUserToGroup(data)
                      : model.addUserToGroup(data);
            },
            icon: Icon(
              isUser
                  ? data.friends.contains(auth.currentUser?.uid)
                      ? MdiIcons.accountCancel
                      : MdiIcons.accountPlus
                  : data.members.contains(auth.currentUser?.uid)
                      ? MdiIcons.accountMultipleRemove
                      : MdiIcons.accountMultiplePlus,
              size: 24.r,
            ),
          );
  }
}
