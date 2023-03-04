import 'package:athlete_iq/data/network/userRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../model/User.dart' as userModel;
import '../../providers/loading_provider.dart';

final authViewModelProvider = ChangeNotifierProvider(
  (ref) => AuthViewModel(ref.read),
);

final userProvider = StreamProvider<User?>(
  (ref) => ref.read(authViewModelProvider).userStream,
);

class AuthViewModel extends ChangeNotifier {
  final Reader _reader;
  AuthViewModel(this._reader);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get user => _auth.currentUser;

  Stream<User?> get userStream => _auth.authStateChanges();

  final UserRepository _userRepo = UserRepository();


  String _pseudo = '';
  String get pseudo => _pseudo;
  set pseudo(String pseudo) {
    _pseudo = pseudo;
    notifyListeners();
  }

  String _email = '';
  String get email => _email;
  set email(String email) {
    _email = email;
    notifyListeners();
  }

  String _password = '';
  String get password => _password;
  set password(String password) {
    _password = password;
    notifyListeners();
  }

  String _confirmPassord = '';
  String get confirmPassord => _confirmPassord;
  set confirmPassord(String confirmPassord) {
    _confirmPassord = confirmPassord;
    notifyListeners();
  }

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

  String _sex = '';
  String get sex => _sex;
  set sex(String sex) {
    _sex = sex;
    notifyListeners();
  }

  String? emailValidate(String value) {
    const String format =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    return !RegExp(format).hasMatch(value) ? "Entrer un email valide" : null;
  }

  Future<void> login() async {
    _loading.start();
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _loading.end();
    } on FirebaseAuthException catch (e) {
      print(e.code);
      _loading.stop();

      if (e.code == "wrong-password") {
        return Future.error("Mauvais mot de passe! Veuiller entre un mot de passe valide");
      } else if (e.code == "user-not-found") {
        return Future.error("Utilisateur non trouvé");
      } else {
        return Future.error(e.message ?? "");
      }
    } catch (e) {
      _loading.stop();

      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> register() async {
    _loading.start();
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      _loading.stop();

      if (e.code == "weak-password") {
        return Future.error("Mot de passe trop faible");
      } else {
        return Future.error(e.message ?? "");
      }
    } catch (e) {
      _loading.stop();
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      userModel.User _user = userModel.User(
        id: _auth.currentUser!.uid,
        pseudo: pseudo,
        image: sex == 'Homme'? "https://cdn-icons-png.flaticon.com/512/4139/4139981.png" : "https://cdn-icons-png.flaticon.com/512/219/219969.png",
        email: email,
        friends:[],
        sex: sex,
        objectif: 0,
        createdAt: DateTime.now(),
        totalDist: 0,
      );
      await _userRepo.writeUser(_user);
      sendEmail();
      _loading.end();
    } catch (e) {
      _loading.stop();
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> reload() async {
    await _auth.currentUser!.reload();
    notifyListeners();
  }

  Future<void> sendEmail() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void streamCheck({required VoidCallback onDone}) {
    final stream = Stream.periodic(const Duration(seconds: 2), (t) => t);
    stream.listen((_) async {
      await reload();
      if (_auth.currentUser!.emailVerified) {
        onDone();
      }
    });
  }


  String? verficationId;

  int? resendToken;

  Loading get _loading => _reader(loadingProvider);

  final formatter = MaskTextInputFormatter(
      mask: '# - # - # - # - # - #', filter: {"#": RegExp(r'[0-9]')});

}