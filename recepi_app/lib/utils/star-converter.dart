import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

IconData getStar(DateTime birthdate) {
  if (birthdate.isAfter(DateTime(birthdate.year, 3, 20)) &&
      birthdate.isBefore(DateTime(birthdate.year, 4, 20))) {
// Aries march 21 apr 19
    return MdiIcons.zodiacAries;
  } else if (birthdate.isAfter(DateTime(birthdate.year, 4, 19)) &&
      birthdate.isBefore(DateTime(birthdate.year, 5, 21))) {
    // Taurus Apr 20 - may 20
    return MdiIcons.zodiacTaurus;
  } else if (birthdate.isAfter(DateTime(birthdate.year, 5, 20)) &&
      birthdate.isBefore(DateTime(birthdate.year, 6, 21))) {
    // Gemini may 21 -jun 20
    return MdiIcons.zodiacGemini;
  } else if (birthdate.isAfter(DateTime(birthdate.year, 6, 21)) &&
      birthdate.isBefore(DateTime(birthdate.year, 7, 23))) {
    // CAncer june 21 -july 22
    return MdiIcons.zodiacCancer;
  } else if (birthdate.isAfter(DateTime(birthdate.year, 7, 22)) &&
      birthdate.isBefore(DateTime(birthdate.year, 8, 23))) {
    // Leo july 23 -aug 22
    return MdiIcons.zodiacLeo;
  } else if (birthdate.isAfter(DateTime(birthdate.year, 8, 22)) &&
      birthdate.isBefore(DateTime(birthdate.year, 9, 23))) {
    // Virgo aug 23 -sep 22
    return MdiIcons.zodiacVirgo;
  } else if (birthdate.isAfter(DateTime(birthdate.year, 9, 22)) &&
      birthdate.isBefore(DateTime(birthdate.year, 10, 23))) {
    // Libra sep 23 -oct 22
    return MdiIcons.zodiacLibra;
  } else if (birthdate.isAfter(DateTime(birthdate.year, 10, 22)) &&
      birthdate.isBefore(DateTime(birthdate.year, 11, 22))) {
    // Scorpio oct 23 -nov 21
    return MdiIcons.zodiacScorpio;
  } else if (birthdate.isAfter(DateTime(birthdate.year, 11, 21)) &&
      birthdate.isBefore(DateTime(birthdate.year, 12, 22))) {
    // sagg nove 22 -dec 21
    return MdiIcons.zodiacSagittarius;
  } else if (birthdate.isAfter(DateTime(birthdate.year, 12, 21)) &&
      birthdate.isBefore(DateTime(birthdate.year, 1, 20))) {
    // cap dec 22 -jan 19
    return MdiIcons.zodiacCapricorn;
  } else if (birthdate.isAfter(DateTime(birthdate.year, 1, 21)) &&
      birthdate.isBefore(DateTime(birthdate.year, 2, 19))) {
    // aqua jan 22 -feb 18
    return MdiIcons.zodiacAquarius;
  } else if (birthdate.isAfter(DateTime(birthdate.year, 2, 18)) &&
      birthdate.isBefore(DateTime(birthdate.year, 3, 19))) {
    // pis feb 19 -mar 18

    return MdiIcons.zodiacPisces;
  }

  return MdiIcons.emoticonFrown;
}
