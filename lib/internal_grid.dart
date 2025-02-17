import 'package:flutter/material.dart';
import 'package:sudoku_api/src/Puzzle.dart';

class InternalGrid extends StatelessWidget {
  final double boxSize;
  final Puzzle puzzle;
  final int blockIndex;

  const InternalGrid({Key? key, required this.boxSize, required this.puzzle, required this.blockIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(9, (cellIndex) {
        int row = (blockIndex ~/ 3) * 3 + (cellIndex ~/ 3);
        int col = (blockIndex % 3) * 3 + (cellIndex % 3);
        int value = puzzle.board()?.matrix()?[row][col].getValue() ?? 0;

        return Container(
          width: boxSize / 3,
          height: boxSize / 3,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.3),
          ),
          child: Center(
            child: Text(
              value == 0 ? "" : value.toString(),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }),
    );
  }
}
