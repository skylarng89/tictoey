import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tic-Tac-Toe Game Logic Tests', () {
    test('Empty board has no winner', () {
      final board = List<String?>.filled(9, null);
      final winner = checkWinner(board);
      expect(winner, isNull);
    });

    test('X wins horizontally (top row)', () {
      final board = ['X', 'X', 'X', null, null, null, null, null, null];
      final winner = checkWinner(board);
      expect(winner, equals('X'));
    });

    test('O wins horizontally (middle row)', () {
      final board = [null, null, null, 'O', 'O', 'O', null, null, null];
      final winner = checkWinner(board);
      expect(winner, equals('O'));
    });

    test('X wins vertically (left column)', () {
      final board = ['X', null, null, 'X', null, null, 'X', null, null];
      final winner = checkWinner(board);
      expect(winner, equals('X'));
    });

    test('O wins vertically (right column)', () {
      final board = [null, null, 'O', null, null, 'O', null, null, 'O'];
      final winner = checkWinner(board);
      expect(winner, equals('O'));
    });

    test('X wins diagonally (top-left to bottom-right)', () {
      final board = ['X', null, null, null, 'X', null, null, null, 'X'];
      final winner = checkWinner(board);
      expect(winner, equals('X'));
    });

    test('O wins diagonally (top-right to bottom-left)', () {
      final board = [null, null, 'O', null, 'O', null, 'O', null, null];
      final winner = checkWinner(board);
      expect(winner, equals('O'));
    });

    test('Full board with no winner is a draw', () {
      final board = ['X', 'O', 'X', 'X', 'O', 'O', 'O', 'X', 'X'];
      final winner = checkWinner(board);
      expect(winner, isNull);
      expect(isDraw(board), isTrue);
    });

    test('Board with empty spaces is not a draw', () {
      final board = ['X', 'O', 'X', null, 'O', 'O', 'O', 'X', 'X'];
      expect(isDraw(board), isFalse);
    });

    test('Game can detect valid moves', () {
      final board = ['X', null, null, null, null, null, null, null, null];
      expect(isValidMove(board, 0), isFalse); // X already there
      expect(isValidMove(board, 1), isTrue);  // Empty space
      expect(isValidMove(board, 8), isTrue);  // Empty space
      expect(isValidMove(board, -1), isFalse); // Invalid index
      expect(isValidMove(board, 9), isFalse);  // Invalid index
    });
  });
}

// Helper functions that mirror the game logic in main.dart
String? checkWinner(List<String?> board) {
  const winPatterns = [
    [0, 1, 2], [3, 4, 5], [6, 7, 8], // Rows
    [0, 3, 6], [1, 4, 7], [2, 5, 8], // Columns
    [0, 4, 8], [2, 4, 6], // Diagonals
  ];

  for (var pattern in winPatterns) {
    if (board[pattern[0]] != null &&
        board[pattern[0]] == board[pattern[1]] &&
        board[pattern[0]] == board[pattern[2]]) {
      return board[pattern[0]]!;
    }
  }
  return null;
}

bool isDraw(List<String?> board) {
  return !board.contains(null) && checkWinner(board) == null;
}

bool isValidMove(List<String?> board, int index) {
  return index >= 0 && index < 9 && board[index] == null;
}
