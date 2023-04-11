import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/data/network/userRepository.dart';
import '../../../model/User.dart';

final firestoreUserProvider = StreamProvider.autoDispose<UserModel>((ref) {
  return ref.watch(userRepositoryProvider).currentUserStream;
});

final firestoreUserFriendsProvider = StreamProvider.autoDispose.family<UserModel, String>((ref, userId) {
  final stream = ref.read(userRepositoryProvider).getUserStreamWithID(userId);
  return stream.map((snapshot) => UserModel.fromFirestore(snapshot));
});