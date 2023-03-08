import 'package:athlete_iq/ui/chat/search_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../model/User.dart';
import '../../utils/routes/customPopupRoute.dart';
import '../auth/login_screen.dart';
import '../auth/providers/auth_view_model_provider.dart';
import '../info/provider/user_provider.dart';
import '../register/register_screen.dart';
import 'createGroup_screen.dart';

class HomeChatScreen extends ConsumerWidget {
  const HomeChatScreen({Key, key}) : super(key: key);

  static const route = "/groups";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authViewModelProvider);
    final height = MediaQuery.of(context).size.height;
    final user = ref.watch(firestoreUserProvider);


    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {
              Navigator.pushNamed(context, SearchPage.route);
            }, icon: const Icon(Icons.search, color: Colors.white))
          ],
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Communauté", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600, color: Colors.white),),
        ),
       body: Column( children: [user.when(data: (User user) {
         if(user.groups.isEmpty) {
            return noGroupWidget();
          } else {
           return Text(
             user.groups.toString(),
             style: const TextStyle(
                 fontWeight: FontWeight.bold,
                 fontSize: 26),
           );
          }
         }, error: (Object error, StackTrace? stackTrace) { return Text(error.toString()); }, loading: () { return const Text('Loading'); })]),
      floatingActionButton: Padding(padding: const EdgeInsets.only(bottom: 100.0), child: FloatingActionButton(onPressed: () {
        Navigator.of(context).push(
            CustomPopupRoute(builder: (BuildContext context) { return CreateGroupScreen();})
        );
      },
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add, color: Colors.white, size: 30)
      ),),
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
                  CustomPopupRoute(builder: (BuildContext context) { return RegisterScreen();});
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Vous n'avez rejoint aucun groupe, tapez sur l'icône pour créer un groupe. Vous pouvez aussi en chercher un depuis le boutton de recherche en haut.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
