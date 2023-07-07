import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final cacheProvider = FutureProvider((ref)=>SharedPreferences.getInstance());

final userIsConneted = FutureProvider((ref) => FirebaseAuth.instance.authStateChanges().first);