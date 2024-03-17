import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/ui/auth/email_verify_page.dart';
import 'package:athlete_iq/ui/auth/login_screen.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/loading_provider.dart';
import 'components/custom_radio.dart';

class SignupScreen extends ConsumerWidget {
  SignupScreen({super.key});
  static const String route = "/register";
  final _formRegisterKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(authViewModelProvider);
    final isLoading = ref.watch(loadingProvider);

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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Form(
                  key: _formRegisterKey,
                  child: Column(
                    children: [
                      _buildTextFormField(
                        context: context,
                        label: "Pseudo",
                        icon: Icons.account_circle_outlined,
                        onChanged: (v) => model.pseudo = v,
                      ),
                      _buildTextFormField(
                        context: context,
                        label: "Email",
                        icon: Icons.email_outlined,
                        onChanged: (v) => model.email = v,
                        validator: (v) => model.emailValidate(v!),
                      ),
                      _buildPasswordField(
                        context: context,
                        label: "Mot de passe",
                        isObscure: model.obscurePassword,
                        onChanged: (v) => model.password = v,
                        toggleObscure: () =>
                            model.obscurePassword = !model.obscurePassword,
                      ),
                      _buildPasswordField(
                        context: context,
                        label: "Confirmer le mot de passe",
                        isObscure: model.obscureConfirmPassword,
                        onChanged: (v) => model.confirmPassword = v,
                        toggleObscure: () => model.obscureConfirmPassword =
                            !model.obscureConfirmPassword,
                        validator: (v) => v != model.password
                            ? "Les mots de passe ne correspondent pas"
                            : null,
                      ),
                      _buildGenderSelector(context, model),
                      SizedBox(height: 20.h),
                      _buildSignupButton(context, model, isLoading),
                      _buildLoginOption(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 0.3.sh,
          width: 1.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(35.r),
              bottomLeft: Radius.circular(35.r),
            ),
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, bottom: 20.h, right: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset("assets/images/logo.png", height: 0.15.sh),
                Text(
                  'Bienvenue,',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  'Créer un compte pour continuer,',
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7), fontSize: 17.sp),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFormField({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextFormField(
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
    required Function(String) onChanged,
    required VoidCallback toggleObscure,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: TextFormField(
        obscureText: isObscure,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_outline_rounded),
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
