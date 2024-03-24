import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ParcourOverlayWidget extends StatelessWidget {
  final String title;
  final String ownerName;
  final VoidCallback onViewDetails;

  const ParcourOverlayWidget({
    super.key,
    required this.title,
    required this.ownerName,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 150.h,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Créé par : $ownerName", style: const TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.visibility, color: Colors.white),
              label: const Text('Voir les détails', style: TextStyle(color: Colors.white)),
              onPressed: onViewDetails,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
