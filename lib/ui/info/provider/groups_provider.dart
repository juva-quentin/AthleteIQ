import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/data/network/groupsRepository.dart';
import '../../../model/Groups.dart';

final firestoreGroupsProvider = StreamProvider<Groups>((ref) {
  final stream = ref.read(GroupsRepositoryProvider).groupsStream;
  return stream.map((snapshot) => Groups.fromFirestore(snapshot));
});