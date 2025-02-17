import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'internal_grid.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class Game extends StatefulWidget {
  const Game({super.key, required this.title});

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  Puzzle? puzzle;
  int? selectedRow;
  int? selectedCol;

  @override
  void initState() {
    super.initState();
    generateSudoku();
  }

  Future<void> generateSudoku() async {
    PuzzleOptions options = PuzzleOptions(patternName: "winter");
    puzzle = Puzzle(options);
    await puzzle!.generate();
    setState(() {});
  }

  void selectCell(int row, int col) {
    setState(() {
      selectedRow = row;
      selectedCol = col;
    });
  }

  void setValue(int value) {
    if (puzzle != null && selectedRow != null && selectedCol != null) {
      var cell = puzzle!.board()!.cellAt(Position(row: selectedRow!, column: selectedCol!));
      var correctValue = puzzle!.solvedBoard()?.matrix()?[selectedRow!][selectedCol!].getValue();

      if (!(cell.prefill() ?? false)) {
        if (value == correctValue) {
          cell.setValue(value);
          setState(() {});
          checkVictory();
        } else {
          showErrorMessage(value, correctValue ?? 0);
        }
      }
    }
  }

  void showErrorMessage(int enteredValue, int correctValue) {
    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: "Erreur !",
        message: "La valeur $enteredValue est incorrecte. La valeur attendue est $correctValue.",
        contentType: ContentType.failure,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void checkVictory() {
    bool isComplete = true;
    
    for (int row = 0; row < 9; row++) {
      for (int col = 0; col < 9; col++) {
        int userValue = puzzle!.board()!.matrix()![row][col].getValue() ?? -1;
        int correctValue = puzzle!.solvedBoard()!.matrix()![row][col].getValue() ?? -1;
        
        if (userValue != correctValue) {
          isComplete = false;
          break;
        }
      }
    }
  if (isComplete) {
    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushNamed(context, '/end');
    });
  }
}

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var boxSize = (maxSize / 3).ceil().toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          puzzle == null
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SizedBox(
                    height: boxSize * 3,
                    width: boxSize * 3,
                    child: GridView.count(
                      crossAxisCount: 3,
                      children: List.generate(9, (x) {
                        return Container(
                          width: boxSize,
                          height: boxSize,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blueAccent),
                          ),
                          child: InternalGrid(
                            boxSize: boxSize,
                            puzzle: puzzle!,
                            blockIndex: x,
                            selectedRow: selectedRow,
                            selectedCol: selectedCol,
                            onCellTap: selectCell,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
          const SizedBox(height: 20),
          Column(
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(5, (index) {
                  int value = index + 1;
                  return ElevatedButton(
                    onPressed: () => setValue(value),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(value.toString(), style: const TextStyle(fontSize: 20)),
                  );
                }),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(4, (index) {
                  int value = index + 6;
                  return ElevatedButton(
                    onPressed: () => setValue(value),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    child: Text(value.toString(), style: const TextStyle(fontSize: 20)),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
