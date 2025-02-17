import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

class InternalGrid extends StatelessWidget {
  final double boxSize;
  final Puzzle puzzle;
  final int blockIndex;
  final int? selectedRow;
  final int? selectedCol;
  final Function(int, int) onCellTap;

  const InternalGrid({
    Key? key,
    required this.boxSize,
    required this.puzzle,
    required this.blockIndex,
    required this.selectedRow,
    required this.selectedCol,
    required this.onCellTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(9, (cellIndex) {
        int row = (blockIndex ~/ 3) * 3 + (cellIndex ~/ 3);
        int col = (blockIndex % 3) * 3 + (cellIndex % 3);
        var cell = puzzle.board()?.matrix()?[row][col];
        var solvedCell = puzzle.solvedBoard()?.matrix()?[row][col];

        int value = cell?.getValue() ?? 0;
        int expectedValue = solvedCell?.getValue() ?? 0;

        bool isSelected = (selectedRow == row && selectedCol == col);
        bool isPrefilled = cell?.prefill() ?? false;
        bool isEmpty = (value == 0);

        return InkWell(
          onTap: () => onCellTap(row, col),
          child: Container(
            width: boxSize / 3,
            height: boxSize / 3,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.3),
              color: isSelected ? Colors.blueAccent.shade100.withAlpha(100) : Colors.transparent,
            ),
            child: Center(
              child: Text(
                isEmpty ? expectedValue.toString() : value.toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isEmpty ? Colors.black12 : (isPrefilled ? Colors.black : Colors.blue),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
