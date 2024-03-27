import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../ui/home/home_view_model_provider.dart';
import '../../utils/routes/customPopupRoute.dart';
import '../../utils/utils.dart';
import '../../ui/register/register_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GoBtn extends ConsumerWidget {
  const GoBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(homeViewModelProvider);

    return GestureDetector(
      onTap: () async {
        if (!model.courseStart) {
          try {
            await model.register();
          } catch (e) {
            Utils.flushBarErrorMessage(e.toString(), context);
          }
        } else {
          try {
            await model.register().then(
                  (value) => Navigator.of(context).push(
                CustomPopupRoute(
                  builder: (BuildContext context) {
                    return RegisterScreen();
                  },
                ),
              ),
            );
          } catch (e) {
            Utils.flushBarErrorMessage(e.toString(), context);
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 50.h,
        width: model.courseStart ? 120.w : 60.w,
        decoration: BoxDecoration(
          color: model.courseStart ? Colors.red : Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Center(
          child: Text(
            model.courseStart ? 'STOP' : 'GO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
