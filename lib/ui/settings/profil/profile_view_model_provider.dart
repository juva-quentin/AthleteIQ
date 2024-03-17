import 'package:athlete_iq/data/network/groupsRepository.dart';
import 'package:athlete_iq/data/network/parcoursRepository.dart';
import 'package:athlete_iq/model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/network/userRepository.dart';
import '../../providers/loading_provider.dart';

final profileViewModelProvider =
    ChangeNotifierProvider.autoDispose<ProfileViewModel>(
  (ref) => ProfileViewModel(ref),
);

class ProfileViewModel extends ChangeNotifier {
  final Ref _reader;

  ProfileViewModel(this._reader);

  Loading get _loading => _reader.read(loadingProvider);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserRepository get _userRepo => _reader.read(userRepositoryProvider);

  ParcourRepository get _parcourRepo => _reader.read(parcourRepositoryProvider);

  GroupsRepository get _groupsRepo => _reader.read(groupsRepositoryProvider);

  final formSettingKey = GlobalKey<FormState>();

  final pseudoController = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  final confirmPasswordController = TextEditingController();

  final objectifController = TextEditingController();

  String get pseudo => pseudoController.text;

  String get email => emailController.text;

  String get password => passwordController.text;

  String get confirmPassword => confirmPasswordController.text;

  String get objectif => objectifController.text;

  String _holdPseudo = '';

  String _holdEmail = '';

  String _holdObjectif = '';

  UserModel? _currentUserInfo;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  set obscurePassword(bool obscureText) {
    _obscurePassword = obscureText;
    notifyListeners();
  }

  bool _obscureConfirmPassword = true;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  set obscureConfirmPassword(bool obscureConfirmPassword) {
    _obscureConfirmPassword = obscureConfirmPassword;
    notifyListeners();
  }

  void actu() {
    notifyListeners();
  }

  String? emailValidate(String value) {
    const String format =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    return !RegExp(format).hasMatch(value) ? "Entrer un email valide" : null;
  }

  Future<void> getUserInfo() async {
    _loading.start();
    try {
      _currentUserInfo =
          await _userRepo.getUserWithId(userId: _auth.currentUser!.uid);
      pseudoController.text = _currentUserInfo!.pseudo;
      objectifController.text = _currentUserInfo!.objectif.toString();
      _holdObjectif = _currentUserInfo!.objectif.toString();
      _holdPseudo = _currentUserInfo!.pseudo;
      emailController.text = _currentUserInfo!.email;
      _holdEmail = _currentUserInfo!.email;
      _loading.stop();
    } catch (e) {
      Future.error(e);
    }
  }

  bool valideForm() {
    if ((pseudo != _holdPseudo ||
            email != _holdEmail ||
            objectif != _holdObjectif && password == '') ||
        (password != '' && (password == confirmPassword))) {
      return true;
    }
    return false;
  }

  Future<void> updateUser() async {
    _loading.start();
    if (password == '') {
      try {
        await _userRepo.updateUser(_currentUserInfo!.copyWith(
            pseudo: pseudo != _holdPseudo ? pseudo : _holdPseudo,
            objectif: objectif != _holdPseudo
                ? double.parse(objectif)
                : double.parse(_holdPseudo),
            email: email != _holdEmail ? email : _holdEmail));
        if (email != _holdEmail) {
          await _auth.currentUser?.updateEmail(email);
        }
      } catch (e) {
        _loading.stop();
        return Future.error(e);
      }
    } else if (password != '' &&
        (pseudo != _holdPseudo || email != _holdEmail)) {
      try {
        await _userRepo.updateUser(_currentUserInfo!.copyWith(
            pseudo: pseudo != _holdPseudo ? pseudo : _holdPseudo,
            email: email != _holdEmail ? email : _holdEmail));
        await _auth.currentUser?.updatePassword(password);
        if (email != _holdEmail) {
          await _auth.currentUser?.updateEmail(email);
        }
      } on FirebaseAuthException catch (e) {
        _loading.stop();
        return Future.error(e);
      }
    } else if (password != '') {
      try {
        await _auth.currentUser?.updatePassword(password);
      } on FirebaseAuthException catch (e) {
        _loading.stop();
        return Future.error(e);
      }
    }
    try {
      await getUserInfo();
    } catch (e) {
      _loading.stop();
      return Future.error(e);
    }
    _loading.stop();
  }

  Future<void> deleteUser() async {
    try {
      final user = _auth.currentUser;
      final metadata = user?.metadata;
      final lastSignInTime = metadata?.lastSignInTime;
      final currentTime = DateTime.now();
      final difference = currentTime.difference(lastSignInTime!).inHours;

      // Vérifier si l'utilisateur s'est connecté il y a moins de 24 heures (ou selon votre critère)
      if (difference < 24) {
        final userInfo =
            await _userRepo.getUserWithId(userId: _auth.currentUser!.uid);

        await _parcourRepo.deleteParcoursOfUser(userInfo.id);

        await _userRepo.removeFromFriendsLists(userInfo.id);

        await _groupsRepo.removeUserFromGroupMembers(userInfo.id);

        await _userRepo.delete(userInfo.id);

        if (user != null) {
          await user.delete();
        }
      } else {
        throw Exception(
            'Vous devez vous connecter au moins une fois dans les 24h avant de supprimer votre compte');
      }
    } catch (e) {
      rethrow;
    }
  }
}
