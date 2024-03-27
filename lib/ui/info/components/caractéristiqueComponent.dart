import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Icon(iconData, size: 24.sp, color: Theme.of(context).primaryColor),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          ),
          Text(value + " ", style: TextStyle(fontSize: 16.sp)),
          Text(unit, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        ],
      ),
    );
  }
}
