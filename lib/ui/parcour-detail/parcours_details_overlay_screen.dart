import 'package:flutter/material.dart';

class ParcourDetailsOverlay extends StatelessWidget {
  final String parcourId;
  final String title;
  final String ownerName;
  final VoidCallback onViewDetails;

  const ParcourDetailsOverlay({
    Key? key,
    required this.parcourId,
    required this.title,
    required this.ownerName,
    required this.onViewDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text("Par : $ownerName", style: TextStyle(fontWeight: FontWeight.w500)),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.visibility, color: Colors.white),
                label: Text('Voir les détails', style: TextStyle(color: Colors.white)),
                onPressed: onViewDetails,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
