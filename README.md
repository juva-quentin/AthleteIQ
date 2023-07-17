# AthleteIQ

## Introduction
Bienvenue sur notre application AthleteIQ ! Cette application permet de retracer ses performances sportives et de les partager avec vos amis où que soyez. L'application est disponible sur IOS et Android.

## Installation et configuration

Avant de lancer l'application mobile AthleteIQ, assurez-vous de suivre ces étapes :

### Prérequis

1.  Installez Flutter en suivant les instructions officielles : [Guide d'installation de Flutter](https://flutter.dev/docs/get-started/install)

### Procédure

1.  Clonez le référentiel AthleteIQ :

```bash
git clone https://github.com/juva-quentin/AthleteIQ.git`
``` 

2.  Accédez au répertoire du projet :
```bash
cd AthleteIQ
```

3.  Installez les dépendances du projet :
```bash
flutter pub get
```

4.  Lancez l'application AthleteIQ sur votre émulateur ou votre appareil :
```bash
flutter run
```

Assurez-vous d'avoir un émulateur Android/iOS fonctionnel ou un appareil connecté à votre ordinateur avant de lancer la commande `flutter run`.

## Installation de git

 **ATTENTION** : Il est nécessaire d'avoir un compte [Github](https://github.com/) avant de réaliser ces commandes

Toujours dans un **Terminal** tapez :

```bash

brew install git

```
Afin d'installer Git sur votre machine.

1. Collez le texte ci-dessous en indiquant l’adresse e-mail de votre compte sur **GitHub**.

```shell

$ ssh-keygen -t ed25519-sk -C "YOUR_EMAIL"

```

**Remarque :** Si la commande échoue et que l’erreur `invalid format` ou `feature not supported,` se produit, vous utilisez peut-être une clé de sécurité matérielle qui ne prend pas en charge l’algorithme Ed25519. Entrez plutôt la commande suivante.

```shell

$ ssh-keygen -t ecdsa-sk -C "your_email@example.com"

```

2. Quand vous y êtes invité, appuyez sur le bouton de votre clé de sécurité matérielle.

3. Quand vous êtes invité à entrer un fichier dans lequel enregistrer la clé, appuyez sur Entrée pour accepter l’emplacement du fichier par défaut.

```shell

> Enter a file in which to save the key (/Users/YOU/.ssh/id_ed25519_sk): [Press enter]

```

4. Quand vous êtes invité à taper une phrase secrète, appuyez sur **Entrée**.

```shell

> Enter passphrase (empty for  no  passphrase): [Type a passphrase]

> Enter same passphrase again: [Type passphrase again]

```

5. Build ios et android

```shell
flutter build ios --release # for iOS
```

```shell
flutter build apk --split-per-abi  # for Android
```

5. Ajoutez la clé SSH à votre compte sur GitHub. Pour plus d’informations, consultez « [Ajout d’une nouvelle clé SSH à votre compte GitHub](https://docs.github.com/fr/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) ».

## Contact

Si vous avez des questions, des commentaires ou des préoccupations, n'hésitez pas à contacter l'équipe de développement à l'adresse suivante : celian.frasca@ynov.com
quentin.juvet@ynov.com
