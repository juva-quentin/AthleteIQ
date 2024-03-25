import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Pour le presse-papier
import 'package:url_launcher/url_launcher.dart'; // Pour ouvrir les liens

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final String date;
  final bool sentByMe;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.date,
    required this.sentByMe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.6, // Limitation de la largeur
        ),
        child: GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: message));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Message copié')),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: sentByMe ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sender,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: sentByMe ? Colors.white : Colors.black),
                ),
                SizedBox(height: 4),
                _buildMessageText(context, message),
                SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(
                      fontSize: 12,
                      color: sentByMe ? Colors.white70 : Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ),
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
