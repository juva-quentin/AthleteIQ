import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/ui/auth/login_screen.dart';
import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/utils/utils.dart';
import '../providers/loading_provider.dart';

class ForgotPasswordScreen extends ConsumerWidget {
  ForgotPasswordScreen({Key? key}) : super(key: key);
  static const route = "/forgot_password";

  final _formForgotPasswordKey = GlobalKey<FormState>();

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
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
                child: Form(
                  key: _formForgotPasswordKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined, size: 24.w),
                          labelText: "Email",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r)),
                        ),
                        onChanged: (v) => model.email = v,
                        validator: (v) => model.emailValidate(v!),
                      ),
                      SizedBox(height: 30.h),
                      isLoading.loading
                          ? CircularProgressIndicator()
                          : _buildSendButton(context, model),
                      SizedBox(height: 20.h),
                      _buildBackButton(context),
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
    return Container(
      width: double.infinity,
      height: 0.3.sh,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(35.r)),
      ),
      child: Padding(
        padding:
            EdgeInsets.only(left: 20.w, bottom: 20.h, right: 20.w, top: 40.h),
        child: Row(
          children: [
            Image.asset("assets/images/logo.png", height: 100.h),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Mot de passe oublié?',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold)),
                  Text('Taper votre email pour continuer',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 17.sp)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton(BuildContext context, AuthViewModel model) {
    return ElevatedButton(
      onPressed: () async {
        if (_formForgotPasswordKey.currentState!.validate()) {
          try {
            await model.forgotPassword();
            Utils.toastMessage("Un mail vous a été envoyé");
            Navigator.pushReplacementNamed(context, LoginScreen.route);
          } catch (e) {
            Utils.flushBarErrorMessage(e.toString(), context);
          }
        }
      },
      child: Text(
        'Envoyer',
        style: TextStyle(fontSize: 16.sp, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        minimumSize: Size(160.w, 40.h),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return TextButton(
      onPressed: () =>
          Navigator.pushReplacementNamed(context, LoginScreen.route),
      child: Text(
        'Retour',
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
