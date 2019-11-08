import 'package:flutter/material.dart';

class DividerCustom extends StatelessWidget {
  /// A custom devider Widget that serves as vertical [Spacer]
  /// with dufferent params

  final double heighT;
  final Color coloR;
  final double verticalMargin;

  DividerCustom(
      {this.heighT = 0.5, this.coloR = Colors.black, this.verticalMargin = 2});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: verticalMargin),
      // width: double.infinity,
      height: heighT,
      color: coloR,
    );
  }
}
