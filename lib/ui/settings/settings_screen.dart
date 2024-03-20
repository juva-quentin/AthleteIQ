import 'package:athlete_iq/ui/auth/login_screen.dart';
import 'package:athlete_iq/ui/components/loading_layer.dart';
import 'package:athlete_iq/ui/providers/loading_provider.dart';
import 'package:athlete_iq/ui/settings/settings_view_model_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../app/app.dart';
import '../../utils/utils.dart';
import '../auth/providers/auth_view_model_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const route = "/settings";

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await ref.read(settingsViewModelProvider).getUserInfo();
      } catch (e) {
        Utils.flushBarErrorMessage(e.toString(), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(360, 690));
    final model = ref.watch(settingsViewModelProvider);
    final authModel = ref.watch(authViewModelProvider);
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Paramètres",
          style: TextStyle(fontSize: 20.sp),
        ),
        leading: IconButton(
          icon: Icon(UniconsLine.arrow_left, size: 24.w),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(UniconsLine.exit, size: 24.w),
            onPressed: () async {
              await authModel.logout();
              FirebaseFirestore.instance.terminate();
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginScreen.route, (route) => false);
            },
          ),
        ],
      ),
      body: isLoading.loading
          ? LoadingLayer(child: SizedBox.shrink())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Form(
                key: model.formSettingKey,
                child: Column(
                  children: [
                    _buildTextFormField(model.pseudoController, "Pseudo",
                        UniconsLine.user_circle),
                    _buildTextFormField(model.emailController, "Email",
                        UniconsLine.envelope_open),
                    _buildPasswordField("Mot de passe",
                        model.passwordController, _obscurePassword, () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    }),
                    _buildPasswordField(
                        "Confirmer le mot de passe",
                        model.confirmPasswordController,
                        _obscureConfirmPassword, () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    }),
                    _buildTextFormField(model.objectifController, "Objectif",
                        UniconsLine.award),
                    SizedBox(height: 30.h),
                    _buildActionButton(
                      text: "Modifier",
                      onPressed: () {
                        if (model.valideForm()) {
                          model.updateUser();
                        }
                      },
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(height: 10.h),
                    _buildActionButton(
                      text: "Supprimer votre compte",
                      onPressed: () {
                        _showConfirmationDialog(context);
                      },
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextFormField(
      TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller,
      bool obscureText, VoidCallback toggleVisibility) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(UniconsLine.lock),
        suffixIcon: IconButton(
          icon: Icon(obscureText ? UniconsLine.eye_slash : UniconsLine.eye),
          onPressed: toggleVisibility,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Container(
      height: 48.h, // Hauteur du bouton
      width: double.infinity, // Largeur du bouton
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r), // Arrondi des angles
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16.sp, color: Colors.white // Taille du texte adaptée
              ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirmation"),
        content: Text(
            "Êtes-vous sûr de vouloir supprimer votre compte ? Cette action est irréversible."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Annuler", style: TextStyle(fontSize: 14.sp)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fermez le dialogue de confirmation
              ref
                  .read(settingsViewModelProvider)
                  .deleteUser(); // Appeler la méthode deleteUser
            },
            child: Text("Supprimer",
                style: TextStyle(fontSize: 14.sp, color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
