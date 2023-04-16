import 'package:flutter/cupertino.dart';

class CaracteristiqueWidget extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;
  final String unit;

  const CaracteristiqueWidget({
    Key? key,
    required this.iconData,
    required this.label,
    required this.value,
    required this.unit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width*.04, vertical: height*.01),
      child: Row(
        children: [
          Icon(iconData, size: width*.08),
          SizedBox(width: width*.03),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 16.0)),
              SizedBox(height: height*.008),
              Text('$value $unit', style: TextStyle(fontSize: 20.0)),
            ],
          ),
        ],
      ),
    );
  }
}