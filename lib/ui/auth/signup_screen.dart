import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/ui/auth/email_verify_page.dart';
import 'package:athlete_iq/ui/auth/login_screen.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/loading_provider.dart';
import 'components/custom_radio.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({Key? key}) : super(key: key);
  static const String route = "/register";
  final _formRegisterKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(authViewModelProvider);
    final isLoading = ref.watch(loadingProvider);

    ScreenUtil.init(context, designSize: const Size(360, 690));

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildHeader(context),
              Form(
                key: _formRegisterKey,
                child: Column(
                  children: [
                    _buildTextFormField(
                      context: context,
                      controller: TextEditingController(text: model.pseudo),
                      label: "Pseudo",
                      icon: Icons.account_circle_outlined,
                      onChanged: (v) => model.pseudo = v,
                    ),
                    _buildTextFormField(
                      context: context,
                      controller: TextEditingController(text: model.email),
                      label: "Email",
                      icon: Icons.email_outlined,
                      onChanged: (v) => model.email = v,
                      validator: (v) => model.emailValidate(v!),
                    ),
                    _buildPasswordField(
                      context: context,
                      label: "Mot de passe",
                      isObscure: model.obscurePassword,
                      controller: TextEditingController(text: model.password),
                      onChanged: (v) => model.password = v,
                      toggleObscure: () =>
                          model.obscurePassword = !model.obscurePassword,
                    ),
                    _buildPasswordField(
                      context: context,
                      label: "Confirmer le mot de passe",
                      isObscure: model.obscureConfirmPassword,
                      controller:
                          TextEditingController(text: model.confirmPassword),
                      onChanged: (v) => model.confirmPassword = v,
                      toggleObscure: () => model.obscureConfirmPassword =
                          !model.obscureConfirmPassword,
                      validator: (v) => v != model.password
                          ? "Les mots de passe ne correspondent pas"
                          : null,
                    ),
                    _buildGenderSelector(context, model),
                    _buildSignupButton(context, model, isLoading),
                    _buildLoginOption(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 120.h, // Ajustez selon la hauteur désirée pour l'en-tête
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text('Bienvenue,',
                style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            Text('Inscrivez-vous pour continuer',
                style: TextStyle(
                    fontSize: 16.sp, color: Colors.white.withOpacity(0.7))),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildPasswordField({
    required BuildContext context,
    required String label,
    required bool isObscure,
    required TextEditingController controller,
    required Function(String) onChanged,
    required VoidCallback toggleObscure,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(Icons.lock_outline_rounded),
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggleObscure,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildGenderSelector(BuildContext context, AuthViewModel model) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.h),
      height: 0.1.sh,
      alignment: Alignment.center,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: model.genders.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: InkWell(
              onTap: () {
                for (var gender in model.genders) {
                  gender.isSelected = false;
                }
                model.genders[index].isSelected = true;
                model.notifyListeners();
              },
              child: CustomRadio(model.genders[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSignupButton(
      BuildContext context, AuthViewModel model, Loading loading) {
    return InkWell(
      onTap: model.email.isNotEmpty &&
              model.password.isNotEmpty &&
              model.confirmPassword.isNotEmpty &&
              model.sex.isNotEmpty
          ? () async {
              if (_formRegisterKey.currentState!.validate()) {
                try {
                  await model.register();
                  Navigator.pushReplacementNamed(
                      context, EmailVerifyScreen.route);
                } catch (e) {
                  Utils.flushBarErrorMessage(e.toString(), context);
                }
              }
            }
          : null,
      child: Container(
        height: 40.h,
        width: 200.w,
        decoration: BoxDecoration(
          color: model.email.isNotEmpty &&
                  model.password.isNotEmpty &&
                  model.confirmPassword.isNotEmpty &&
                  model.sex.isNotEmpty
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: loading.loading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text("Créer un compte",
                  style: TextStyle(color: Colors.white, fontSize: 16.sp)),
        ),
      ),
    );
  }

  Widget _buildLoginOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Vous avez un compte ?", style: TextStyle(fontSize: 14.sp)),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, LoginScreen.route);
          },
          child: Text("Connexion",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 14.sp)),
        ),
      ],
    );
  }
}
