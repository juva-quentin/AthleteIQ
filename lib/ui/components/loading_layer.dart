import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/loading_provider.dart';

class LoadingLayer extends StatelessWidget {
  const LoadingLayer({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Stack(
      children: [
        child,
        Consumer(
          builder: (context, ref, child) {
            final model = ref.watch(loadingProvider);
            return model.loading? Material(
              color: scheme.surfaceVariant.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ):const SizedBox();
          },
        ),
      ],
    );
  }
}
