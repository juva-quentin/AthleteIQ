import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/riverpods/auth_pod.dart';
import '../resources/components/round_button.dart';
import '../utils/routes/routes_name.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(authProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Consumer(
            builder:((context, ref, child){
              final authNotifier = ref.watch(authProvider);
              return IconButton(
                icon: const Icon(Icons.login_outlined),
                onPressed: (){authNotifier.logoutUser();
                Navigator.pushNamed(context, RoutesName.login);
                  },
              );
            })
          )
        ]
      ),
        body: Column(
          children: [Text("Home"),
          ],

    ));
  }
}
