import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({Key, key}) : super(key: key);

  static const route = "/groups/search";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: Center(child: Text("Search"),)
    );
  }

}