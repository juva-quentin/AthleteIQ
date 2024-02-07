import 'package:athlete_iq/app/app.dart';
import 'package:athlete_iq/ui/auth/forgot_password_screen.dart';
import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/ui/auth/signup_screen.dart';
import 'package:athlete_iq/ui/components/loading_layer.dart';
import 'package:athlete_iq/ui/providers/loading_provider.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({Key? key}) : super(key: key);
  final _formLoginKey = GlobalKey<FormState>();
  static const route = "/login";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(authViewModelProvider);
    final isLoading = ref.watch(loadingProvider);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: LoadingLayer(
          child: Form(
            key: _formLoginKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(context),
                  SizedBox(height: 30.h),
                  _buildEmailFormField(model),
                  SizedBox(height: 20.h),
                  _buildPasswordFormField(model),
                  _buildForgotPasswordButton(context),
                  SizedBox(height: 50.h),
                  _buildLoginButton(context, model, ref),
                  SizedBox(height: 20.h),
                  _buildSignUpOption(context),
                ],
              ),
            ),
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
                  'Connectez-vous pour continuer,',
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

  Widget _buildEmailFormField(AuthViewModel model) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      initialValue: model.email,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email_outlined),
        labelText: "Email",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      onChanged: (v) => model.email = v,
      validator: (v) => model.emailValidate(v!),
    );
  }

  Widget _buildPasswordFormField(AuthViewModel model) {
    return TextFormField(
      obscureText: model.obscurePassword,
      keyboardType: TextInputType.visiblePassword,
      initialValue: model.password,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline_rounded),
        labelText: "Mot de passe",
        suffixIcon: IconButton(
          onPressed: () {
            model.obscurePassword = !model.obscurePassword;
          },
          icon: Icon(model.obscurePassword
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      onChanged: (v) => model.password = v,
      textInputAction: TextInputAction.done,
    );
  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, ForgotPasswordScreen.route);
        },
        child: Text(
          "Mot de passe oublié ?",
          style: TextStyle(fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget _buildLoginButton(
      BuildContext context, AuthViewModel model, WidgetRef ref) {
    return ElevatedButton(
      onPressed: model.email.isNotEmpty && model.password.isNotEmpty
          ? () async {
              if (_formLoginKey.currentState!.validate()) {
                try {
                  await model.login();
                  Navigator.pushReplacementNamed(context, App.route);
                } catch (e) {
                  Utils.flushBarErrorMessage(e.toString(), context);
                }
              }
            }
          : null,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(160.w, 40.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: Text(
        "Connexion",
        style: TextStyle(fontSize: 16.sp),
      ),
    );
  }

  Widget _buildSignUpOption(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Vous n'avez pas de compte ?", style: TextStyle(fontSize: 14.sp)),
        TextButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, SignupScreen.route);
          },
          child: Text(
            "Créer un compte",
            style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
      ],
    );
  }
}
