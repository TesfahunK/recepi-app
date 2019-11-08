import 'package:flutter/material.dart';
import 'package:recepi_app/data/models/ingridient.dart';

class CustomChip extends StatelessWidget {
  /// This is basically a chip but with some tweaks
  /// it can customized based on Constructor and is used
  /// to to Show Ingridients , Equipments and Tags

  final Color color;
  final Color textColor;
  final Ingridient ingridient;
  final bool isEquipment;
  final bool isIngridient;
  final bool isTag;
  final String lableText;
  CustomChip(
      {this.color = Colors.grey,
      this.textColor = Colors.black,
      this.isTag = false,
      this.isEquipment = false,
      this.isIngridient = false,
      this.ingridient,
      this.lableText});
  // : assert((isTag || isEquipment) == true && lableText != null);

  @override
  Widget build(BuildContext context) {
    if (isTag || isEquipment) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Chip(
          backgroundColor: color,
          label: Text(
            lableText,
            style: TextStyle(color: textColor),
          ),
        ),
      );
    } else if (isIngridient) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Chip(
          backgroundColor: color,
          label: Text(
            "${ingridient.name}(${ingridient.amount})",
            style: TextStyle(color: textColor),
          ),
        ),
      );
    }
    return Container();
  }
}
