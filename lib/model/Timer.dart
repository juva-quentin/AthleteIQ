import 'package:cloud_firestore/cloud_firestore.dart';

class CustomTimer {
  int hours;
  int minutes;
  int seconds;

//<editor-fold desc="Data Methods">
  CustomTimer({
    required this.hours,
    required this.minutes,
    required this.seconds,
  });


  CustomTimer copyWith({
    int? hours,
    int? minutes,
    int? seconds,
  }) {
    return CustomTimer(
      hours: hours ?? this.hours,
      minutes: minutes ?? this.minutes,
      seconds: seconds ?? this.seconds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hours': this.hours,
      'minutes': this.minutes,
      'seconds': this.seconds,
    };
  }

  factory CustomTimer.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> map = doc.data() as Map<String, dynamic>;
    return CustomTimer(
      hours: map['hours'] ?? 0,
      minutes: map['minutes'] ?? 0,
      seconds: map['seconds'] ?? 0,
    );
  }

  factory CustomTimer.empty() => CustomTimer(
    hours: 0,
    minutes: 0,
    seconds: 0,
  );

}