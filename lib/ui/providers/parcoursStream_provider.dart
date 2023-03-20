import 'package:athlete_iq/model/Parcour.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/network/parcoursRepository.dart';

final PublicParcourProvider = StreamProvider<List<Parcours>>((ref) {
  final stream = ref.read(parcourRepositoryProvider).parcoursPublicStream;
  return stream.map((snapshot) => snapshot.docs.map((e) => Parcours.fromFirestore(e)).toList());
});

final PrivateParcourProvider = StreamProvider<List<Parcours>>((ref) {
  final stream = ref.read(parcourRepositoryProvider).parcoursPrivateStream;
  return stream.map((snapshot) => snapshot.docs.map((e) => Parcours.fromFirestore(e)).toList());
});

final ProtectedParcourProvider = StreamProvider<List<Parcours>>((ref) {
  final stream = ref.read(parcourRepositoryProvider).parcoursProtectedStream;
  return stream.map((snapshot) => snapshot.docs.map((e) => Parcours.fromFirestore(e)).toList());
});