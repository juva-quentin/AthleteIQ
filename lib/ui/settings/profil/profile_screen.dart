import 'package:athlete_iq/ui/auth/login_screen.dart';
import 'package:athlete_iq/ui/components/loading_layer.dart';
import 'package:athlete_iq/ui/providers/loading_provider.dart';
import 'package:athlete_iq/ui/settings/profil/profile_view_model_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../../utils/utils.dart';
import '../../auth/providers/auth_view_model_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});
  static const route = "/profile";

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await ref.read(profileViewModelProvider).getUserInfo();
      } catch (e) {
        Utils.flushBarErrorMessage(e.toString(), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(profileViewModelProvider);
    final authModel = ref.watch(authViewModelProvider);
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading.loading
          ? const LoadingLayer(child: SizedBox.shrink())
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Form(
          key: model.formSettingKey,
          child: Column(
            children: [
              _buildTextFormField(model.pseudoController, "Pseudo", UniconsLine.user_circle),
              _buildTextFormField(model.emailController, "Email", UniconsLine.envelope_open),
              _buildPasswordField("Mot de passe", model.passwordController, _obscurePassword, () {
                setState(() { _obscurePassword = !_obscurePassword; });
              }),
              _buildPasswordField("Confirmer le mot de passe", model.confirmPasswordController, _obscureConfirmPassword, () {
                setState(() { _obscureConfirmPassword = !_obscureConfirmPassword; });
              }),
              _buildTextFormField(model.objectifController, "Objectif", UniconsLine.award),
              SizedBox(height: 10.h),
              _buildActionButton(
                text: "Modifier",
                icon: UniconsLine.edit,
                onPressed: () async {
                  await model.updateUser();
                },
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 40.h),
              _buildActionButton(text: "Déconnexion", icon: UniconsLine.exit, onPressed: () => _confirmLogout(authModel), color: Colors.red),
              SizedBox(height: 10.h),
              _buildActionButton(text: "Supprimer votre compte", icon: UniconsLine.user_minus, onPressed: () => _confirmAccountDeletion(model, authModel), color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscureText, VoidCallback toggleVisibility) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined ),
            onPressed: toggleVisibility,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      height: 35.h, // Hauteur fixe pour le bouton
      width: double.infinity, // Le bouton prend toute la largeur disponible
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: color, // Couleur du texte et de l'icône si présent
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r), // Bords arrondis
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h), // Padding vertical pour augmenter la hauteur du texte si nécessaire
        ),
        icon: Icon(icon, color: Colors.white), // Icône à gauche du texte
        label: Text(
          text,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500, // Texte en gras pour plus de présence
            color: Colors.white, // Assure que le texte est blanc pour tous les boutons
          ),
        ),
      ),
    );
  }

  void _confirmLogout(AuthViewModel authModel) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            color: Colors.white,
            child: IntrinsicHeight(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor, // Utiliser la couleur primaire pour l'en-tête
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    child: const Text(
                      "Déconnexion",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Êtes-vous sûr de vouloir vous déconnecter ?",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Annuler", style: TextStyle(color: Theme.of(context).primaryColor)),
                        ),
                        TextButton(
                          onPressed: () async {
                            await authModel.logout();
                            Navigator.pushNamedAndRemoveUntil(context, LoginScreen.route, (route) => false);
                          },
                          child: const Text("Se déconnecter", style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmAccountDeletion(ProfileViewModel model, AuthViewModel authModel) {
    showDialog(context: context,
        builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          color: Colors.white,
          child: IntrinsicHeight( // Assurez-vous que le widget prend la hauteur de son contenu
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).errorColor, // Couleur rouge pour l'en-tête
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Augmentation de l'espace vertical
                  child: const Text(
                    "Supprimer le compte",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(20), // Augmentation de l'espace autour du texte
                  child: Text(
                    "Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible.",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding( // Ajout de Padding pour créer plus d'espace
                  padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20), // Ajustez selon le besoin
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Annuler", style: TextStyle(color: Theme.of(context).primaryColor)), // Couleur bleue pour annuler
                      ),
                      TextButton(
                        onPressed: () async {
                          await model.deleteUser();
                          await authModel.logout();
                          FirebaseFirestore.instance.terminate();
                          Navigator.pushNamedAndRemoveUntil(context, LoginScreen.route, (_) => false);
                        },
                        child: const Text("Supprimer", style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
