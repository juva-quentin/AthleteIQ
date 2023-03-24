import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/data/network/groupsRepository.dart';
import '../../../model/Groups.dart';

final GroupsProvider = StreamProvider.autoDispose<List<Groups>>(
    (ref) => ref.read(GroupsRepositoryProvider).groupsStream);
