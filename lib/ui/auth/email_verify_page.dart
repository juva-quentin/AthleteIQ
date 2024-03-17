import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import '../../app/app.dart';
import '../../utils/utils.dart';

class EmailVerifyScreen extends ConsumerStatefulWidget {
  const EmailVerifyScreen({super.key});
  static const String route = "/verifyEmail";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends ConsumerState<EmailVerifyScreen> {
  void onDone() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, App.route);
  }

  @override
  void initState() {
    super.initState();
    ref.read(authViewModelProvider.notifier).streamCheck(onDone: onDone);
  }

  @override
  Widget build(BuildContext context) {
    final model = ref.watch(authViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout_outlined, size: 24.w),
            onPressed: () async {
              await model.logout();
              onDone();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              "Veuillez vérifier votre email",
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            Text(
              "Un email de vérification a été envoyé à ${model.user!.email!}",
              style: TextStyle(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await model.reload();
                if (model.user!.emailVerified) {
                  onDone();
                } else {
                  Utils.flushBarErrorMessage(
                      "Votre email n'est pas vérifié", context);
                }
              },
              style: ElevatedButton.styleFrom(minimumSize: Size(160.w, 40.h)),
              child: Text("OK", style: TextStyle(fontSize: 16.sp)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await model.sendEmail();
                  Utils.flushBarErrorMessage(
                      "Email de vérification réenvoyé", context);
                } catch (e) {
                  Utils.flushBarErrorMessage(
                      "Erreur lors de l'envoi de l'email", context);
                }
              },
              child: Text("Renvoyer", style: TextStyle(fontSize: 14.sp)),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
