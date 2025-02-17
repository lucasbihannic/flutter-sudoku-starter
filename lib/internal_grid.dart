import 'package:flutter/material.dart';

class InternalGrid extends StatelessWidget {
  final double boxSize;

  const InternalGrid({Key? key, required this.boxSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(9, (x) {
        return Container(
          width: boxSize / 3,
          height: boxSize / 3,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.3),
          ),
        );
      }),
    );
  }
}
