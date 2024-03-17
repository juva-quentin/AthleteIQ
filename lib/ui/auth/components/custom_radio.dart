import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../model/Gender.dart';

class CustomRadio extends StatelessWidget {
  final Gender _gender;

  const CustomRadio(this._gender, {super.key});

  @override
  Widget build(BuildContext context) {
    // Utilisation de ScreenUtil pour des dimensions flexibles
    return Card(
      color: _gender.isSelected ? const Color(0xFF3B4257) : Colors.white,
      child: Container(
        // Ajustement des dimensions du container
        height: 90.h, // Ajustez cette valeur si nécessaire
        width: 90.w, // Ajustez cette valeur si nécessaire
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              _gender.icon,
              color: _gender.isSelected ? Colors.white : Colors.grey,
              size: 40.sp, // Ajustement de la taille de l'icône
            ),
            SizedBox(height: 10.h), // Ajustement de l'espacement
            Text(
              _gender.name,
              style: TextStyle(
                color: _gender.isSelected ? Colors.white : Colors.grey,
                fontSize: 14.sp, // Ajustement de la taille du texte
              ),
            )
          ],
        ),
      ),
    );
  }
}
