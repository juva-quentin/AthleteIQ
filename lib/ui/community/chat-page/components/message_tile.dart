import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour le presse-papier
import 'package:url_launcher/url_launcher.dart'; // Pour ouvrir les liens

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final String senderImage;
  final String date;
  final bool sentByMe;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.senderImage,
    required this.date,
    required this.sentByMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end, // Alignement vertical au bas
      children: [
        if (!sentByMe)
          CircleAvatar(
            backgroundImage: NetworkImage(senderImage),
            radius: 16,
          ),
        Padding(
          padding: sentByMe ? const EdgeInsets.symmetric(horizontal: 1.0) : const EdgeInsets.symmetric(horizontal: 8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.6, // Limitation de la largeur à 60%
            ),
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: message));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Message copié')),
                );
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                decoration: BoxDecoration(
                  color: sentByMe ? Colors.blue : Colors.white,
                  borderRadius: sentByMe
                      ? const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),

                  )
                      : const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(sender,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: sentByMe ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    _buildMessageText(context, message),
                    const SizedBox(height: 3),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: sentByMe ? Colors.white70 : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMessageText(BuildContext context, String text) {
    final RegExp linkRegExp = RegExp(
        r'athleteiq:\/\/parcours\/details\/(\w+)|https?:\/\/[^\s]+',
        caseSensitive: false);

    return RichText(
      text: TextSpan(
        style: TextStyle(color: sentByMe ? Colors.white : Colors.black),
        children: linkifyText(text, linkRegExp, context),
      ),
    );
  }

  List<InlineSpan> linkifyText(
      String text, RegExp pattern, BuildContext context) {
    final List<InlineSpan> spans = [];
    final Iterable<Match> matches = pattern.allMatches(text);
    int start = 0;

    for (final Match match in matches) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }

      final String linkText = match.group(0)!;
      final Uri? uri = Uri.tryParse(linkText);

      if (uri != null && uri.scheme.contains('athleteiq')) {
        spans.add(
          TextSpan(
            text: linkText,
            style: TextStyle(color: Colors.indigo),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchURL(uri.toString(), context),
          ),
        );
      } else {
        spans.add(
          TextSpan(
            text: linkText,
            style: TextStyle(color: Colors.indigo),
            recognizer: TapGestureRecognizer()
              ..onTap = () => _launchURL(linkText, context),
          ),
        );
      }

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start, text.length)));
    }

    return spans;
  }

  void _launchURL(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d\'ouvrir le lien')),
      );
    }
  }
}
