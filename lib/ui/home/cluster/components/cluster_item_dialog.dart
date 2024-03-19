import 'package:flutter/material.dart';

import '../parcours_cluster_item.dart';

class ClusterItemsDialog extends StatelessWidget {
  final Set<ParcoursClusterItem> clusterItems;
  final Function(String parcourId) onSelectParcour;

  const ClusterItemsDialog({
    Key? key,
    required this.clusterItems,
    required this.onSelectParcour,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Liste des parcours'),
      content: Container(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: clusterItems.length,
          itemBuilder: (BuildContext context, int index) {
            final item = clusterItems.elementAt(index);
            return ListTile(
              title: Text(item.title),
              subtitle: Text(item.snippet),
              onTap: () {
                Navigator.of(context).pop(); // Fermeture de la boîte de dialogue
                onSelectParcour(item.id); // Appel du callback avec l'ID du parcours sélectionné
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          child: Text('Fermer'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
