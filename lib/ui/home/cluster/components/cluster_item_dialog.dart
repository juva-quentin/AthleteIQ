import 'package:flutter/material.dart';
import '../parcours_cluster_item.dart';

class ClusterItemsDialog extends StatelessWidget {
  final Set<ParcoursClusterItem> clusterItems;
  final Function(String parcourId) onSelectParcour;

  const ClusterItemsDialog({
    super.key,
    required this.clusterItems,
    required this.onSelectParcour,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Liste des parcours',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 10),
                    shrinkWrap: true,
                    itemCount: clusterItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = clusterItems.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        child: ListTile(
                          title: Text(item.title),
                          subtitle: Text(item.snippet),
                          onTap: () {
                            Navigator.of(context).pop();
                            onSelectParcour(item.id);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
