import 'package:flutter/material.dart';

enum Categories {
  araba("Araba", Icon(Icons.directions_car_rounded)),
  telefon("Telefon", Icon(Icons.phone_android_rounded)),
  evEsyalari("Ev Eşyaları", Icon(Icons.chair_rounded)),
  elektronik("Elektronik", Icon(Icons.computer_rounded)),
  motosiklet("Motosiklet", Icon(Icons.motorcycle_rounded)),
  spor("Spor", Icon(Icons.sports_baseball_rounded)),
  hobi("Hobi", Icon(Icons.gamepad_rounded)),
  giyim("Giyim", Icon(Icons.dry_cleaning_rounded));

  final String label;
  final Icon icon;
  const Categories(this.label, this.icon);
}
