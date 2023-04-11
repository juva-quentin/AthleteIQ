import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/data/network/groupsRepository.dart';
import '../../../model/Groups.dart';

final streamGroupsProvider = StreamProvider.autoDispose.family<Groups, String>((ref, id) {
  final stream = ref.read(groupsRepositoryProvider).getmyGroupsStreamById(id);
  return stream.map((snapshot) => Groups.fromFirestore(snapshot));
});