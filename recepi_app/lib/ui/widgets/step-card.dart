import 'package:flutter/material.dart';
import 'package:recepi_app/data/models/step.dart';

class StepCard extends StatelessWidget {
  /// This is a Widget that shows a single step
  /// it accepts [index] which is basically a number to
  /// identify the stage of a process, and a [step] that holds
  /// header and description of the process

  final int index;
  final RecepiStep step;

  StepCard({this.step, this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: EdgeInsets.only(top: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 2,
                offset: Offset(1, 1))
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: Text(
              "$index. ${step.header}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text("${step.description}", overflow: TextOverflow.visible),
          )
        ],
      ),
    );
  }
}
