import 'package:flutter/material.dart';
import 'package:sudoku_api/src/Puzzle.dart';
import 'package:sudoku_api/src/models/PuzzleOptions.dart';
import 'internal_grid.dart';

class Game extends StatefulWidget {
  const Game({super.key, required this.title});

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  Puzzle? puzzle;

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
      body: puzzle == null
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
                      child: InternalGrid(boxSize: boxSize, puzzle: puzzle!, blockIndex: x), 
                    );
                  }),
                ),
              ),
            ),
    );
  }
}