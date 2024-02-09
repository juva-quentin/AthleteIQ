import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CaracteristiqueWidget extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;
  final String unit;

  const CaracteristiqueWidget({
    super.key,
    required this.iconData,
    required this.label,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.04.sw, vertical: 0.01.sh),
      child: Row(
        children: [
          Icon(iconData, size: 0.08.sw),
          SizedBox(width: 0.03.sw),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 16.0.sp)),
              SizedBox(height: 0.008.sh),
              Text('$value $unit', style: TextStyle(fontSize: 20.0.sp)),
            ],
          ),
        ],
      ),
    );
  }
}
