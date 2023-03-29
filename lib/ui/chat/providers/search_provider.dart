import 'package:athlete_iq/data/network/userRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/data/network/groupsRepository.dart';
import '../../../model/Groups.dart';

/*final SearchProvider = StreamProvider.autoDispose<QuerySnapshot<Map<String, dynamic>>>(
       (ref) {
          var groupsStream = ref.watch(groupsRepositoryProvider).groupsStream;
          var usersStream = ref.watch(userRepositoryProvider).usersStream;
        });

 */
