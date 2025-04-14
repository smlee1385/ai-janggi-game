import 'package:flutter/material.dart';

void main() => runApp(JanggiApp());

class JanggiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI 장기왕',
      home: JanggiBoard(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class JanggiBoard extends StatefulWidget {
  @override
  _JanggiBoardState createState() => _JanggiBoardState();
}

class _JanggiBoardState extends State<JanggiBoard> {
  final int rows = 10;
  final int cols = 9;

  List<List<String>> board = List.generate(10, (i) => List.generate(9, (j) => ''));
  bool isUserTurn = true;
  Point? selected;

  @override
  void initState() {
    super.initState();
    _setupBoard();
  }

  void _setupBoard() {
    board[9][0] = '차'; board[9][1] = '마'; board[9][2] = '상'; board[9][3] = '사'; board[9][4] = '장';
    board[9][5] = '사'; board[9][6] = '상'; board[9][7] = '마'; board[9][8] = '차';
    board[7][1] = '포'; board[7][7] = '포';
    board[6][0] = '병'; board[6][2] = '병'; board[6][4] = '병'; board[6][6] = '병'; board[6][8] = '병';

    board[0][0] = '차'; board[0][1] = '마'; board[0][2] = '상'; board[0][3] = '사'; board[0][4] = '장';
    board[0][5] = '사'; board[0][6] = '상'; board[0][7] = '마'; board[0][8] = '차';
    board[2][1] = '포'; board[2][7] = '포';
    board[3][0] = '병'; board[3][2] = '병'; board[3][4] = '병'; board[3][6] = '병'; board[3][8] = '병';
  }

  Widget _buildCell(int row, int col) {
    bool isSelected = selected?.x == row && selected?.y == col;
    return GestureDetector(
      onTap: () => _handleTap(row, col),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: isSelected ? Colors.yellow[200] : Colors.transparent,
        ),
        child: Center(
          child: Text(
            board[row][col],
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }

  void _handleTap(int row, int col) {
    if (!isUserTurn) return;

    if (selected == null && board[row][col] != '') {
      setState(() {
        selected = Point(row, col);
      });
    } else if (selected != null) {
      int fromRow = selected!.x;
      int fromCol = selected!.y;

      setState(() {
        board[row][col] = board[fromRow][fromCol];
        board[fromRow][fromCol] = '';
        selected = null;
        isUserTurn = false;
      });

      Future.delayed(Duration(milliseconds: 500), _aiTurn);
    }
  }

  void _aiTurn() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        if (board[i][j] != '') {
          for (int x = 0; x < rows; x++) {
            for (int y = 0; y < cols; y++) {
              if (board[x][y] == '') {
                setState(() {
                  board[x][y] = board[i][j];
                  board[i][j] = '';
                  isUserTurn = true;
                });
                return;
              }
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AI 장기왕')),
      body: AspectRatio(
        aspectRatio: cols / rows,
        child: GridView.builder(
          itemCount: rows * cols,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
          ),
          itemBuilder: (context, index) {
            int row = index ~/ cols;
            int col = index % cols;
            return _buildCell(row, col);
          },
        ),
      ),
    );
  }
}

class Point {
  final int x;
  final int y;
  Point(this.x, this.y);
}