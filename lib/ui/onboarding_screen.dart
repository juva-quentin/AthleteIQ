import 'package:athlete_iq/app/app.dart';
import 'package:athlete_iq/ui/providers/cache_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/utils.dart';
import 'auth/login_screen.dart';
import 'auth/providers/auth_view_model_provider.dart';

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  const OnboardingItem(
      {required this.image, required this.title, required this.description});
}

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({super.key});

  static const List<OnboardingItem> _items = [
    OnboardingItem(
        image: "assets/images/photo_nous.png",
        title: "Notre projet",
        description:
            "Bienvenue sur AthleteIQ ! Ce projet à été réalisé par Quentin Juvet et Célian Frasca pour le "
            "compte du projet développement de notre année de B3 Informatique spécialité Développement. "
            "Notre application consiste à retracer la performance de chaque athlète utilisant l’application, "
            "Les athlètes peuvent donc partager leur performance et interagir avec la performance des autres."
            " Un site est aussi disponible avec les mêmes identifiant de connection pour lister vos parcours. Vous pouvez le retrouver "),
    OnboardingItem(
        image: "assets/images/presentation-parcours.png",
        title: "Les parcours et la visibilité",
        description: ""),
    OnboardingItem(
        image: "assets/images/page-principale.png",
        title: "La page principale",
        description: ""),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final style = theme.textTheme;
    final controller = useTabController(initialLength: _items.length);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final index = useState(0);

    controller.addListener(() {
      if (index.value != controller.index) {
        index.value = controller.index;
      }
    });

    void done() async {
      await ref.read(cacheProvider).value!.setBool("seen", true);
      final firebaseAuth = ref.watch(firebaseAuthProvider);
      final bool isLoggedIn = firebaseAuth.currentUser != null;
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(
          context, isLoggedIn ? App.route : LoginScreen.route);
    }

    return Scaffold(
      backgroundColor: theme.cardColor,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.025, horizontal: width * 0.02),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: done,
              child: const Text("Passer"),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: scheme.primary,
              onPressed: () {
                if (controller.index < 2) {
                  index.value = index.value + 1;
                  controller.animateTo(controller.index + 1);
                } else {
                  done();
                }
              },
              child: Text(index.value == 2 ? "Fini" : "Suivant"),
            ),
          ],
        ),
      ),
      bottomSheet: Material(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: height * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _items.length,
              (i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: index.value == i ? scheme.primary : scheme.secondary,
                  ),
                  height: 16,
                  width: index.value == i ? 32 : 16,
                ),
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: _items
            .map((e) => Column(
                  children: [
                    Flexible(
                      flex: e.description != "" ? 5 : 10,
                      child: SafeArea(
                        child: Image.asset(
                          e.image,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: width * 0.1),
                          child: Column(
                            children: [
                              Text(
                                e.title,
                                style: style.headlineLarge,
                                textAlign: TextAlign.center,
                              ),
                              if (e.description.isNotEmpty)
                                SizedBox(height: height * 0.002),
                              if (e.description.isNotEmpty)
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    text: e.description,
                                    style: style.titleLarge,
                                    children: [
                                      TextSpan(
                                        text: 'ici',
                                        style: const TextStyle(
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                            Uri url = Uri.parse(
                                                'https://athleteiq-2f163.web.app');
                                            if (await canLaunchUrl(url)) {
                                              await launchUrl(url);
                                            } else {
                                              Utils.toastMessage(
                                                  'Impossible d\'ouvrir l\'URL : $url');
                                            }
                                          },
                                      ),
                                    ],
                                  ),
                                ),
                              if (e.description.isNotEmpty)
                                SizedBox(height: height * 0.05)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
