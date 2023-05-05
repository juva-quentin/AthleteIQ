import 'package:athlete_iq/app/app.dart';
import 'package:athlete_iq/ui/providers/cache_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnboardingItem {
  final String image;
  final String title;
  final String description;

  const OnboardingItem(
      {required this.image, required this.title, required this.description});
}

class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  static const List<OnboardingItem> _items = [
    OnboardingItem(
        image: "assets/images/photo_nous.png",
        title: "Notre projet",
        description: "Bienvenue sur AthleteIQ ! Ce projet à été réalisé par Quentin Juvet et Célian Frasca pour le compte du projet développement de notre année de B3 Informatique spécialité Développement. Notre application consiste à retracer la performance de chaque athlète utilisant l’application, Les athlètes peuvent donc partager leur performance et interagir avec la performance des autres. Un boitier est aussi disponible afin d’utiliser l’application sans utiliser son téléphone."),
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

    final index = useState(0);

    controller.addListener(() {
      if(index.value!= controller.index){
        index.value = controller.index;
      }
    });

    void done() async{
      await ref.read(cacheProvider).value!.setBool("seen", true);
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, App.route);
    }

    return Scaffold(
      backgroundColor: theme.cardColor,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: done,
              child: Text("Passer"),
            ),
            MaterialButton(
              color: scheme.primary,
              onPressed: () {
                if (controller.index < 2) {
                  index.value = index.value + 1;
                  controller.animateTo(controller.index + 1);
                } else {
                  done();
                }
              },
              child: Text(index.value == 2?"Fini":"Suivant"),
            ),
          ],
        ),
      ),
      bottomSheet: Material(
        color: theme.cardColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _items.length,
                  (i) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: const StadiumBorder(),
                    color: index.value == i
                        ? scheme.tertiary
                        : scheme.tertiaryContainer,
                  ),
                  child: AnimatedSize(
                    duration: Duration(milliseconds: 500),
                    reverseDuration: Duration(milliseconds: 500),
                    child: SizedBox(
                      height: 16,
                      width: index.value == i ? 32 : 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: _items
            .map(
              (e) => Padding(
            padding: const EdgeInsets.all(24),
            child: ListView(
              children: [
                Expanded(
                  flex: 32,
                  child: Image.asset(e.image),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 40.0),
                  child: Text(
                    e.title,
                    style: style.headlineLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 55.0),
                  child: Text(
                    e.description,
                    style: style.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}
