import 'package:flutter/material.dart';

class TicTacToe {
  String message;
  List<TTT> gameState = [
    TTT.empty,
    TTT.empty,
    TTT.empty,
    TTT.empty,
    TTT.empty,
    TTT.empty,
    TTT.empty,
    TTT.empty,
    TTT.empty,
  ];
  bool isCross = false;

  playGame(int index, bool isCross) {
    if (this.gameState[index] == TTT.empty) {
      if (isCross) {
        this.gameState[index] = TTT.cross;
      } else {
        this.gameState[index] = TTT.circle;
      }
      this.checkWin();
    }
  }

  IconData getIcon(TTT val) {
    switch (val) {
      case (TTT.empty):
        return null;
        break;
      case (TTT.cross):
        return Icons.close;
        break;
      case (TTT.circle):
        return Icons.check_circle;
        break;
      default:
        return Icons.remove;
    }
  }

  bool checkWin() {
    if ((gameState[0] != TTT.empty) &&
        (gameState[0] == gameState[1]) &&
        (gameState[1] == gameState[2])) {
      // if any user Win update the message state

      message = '${this.gameState[0]} wins';
      return true;
    } else if ((gameState[3] != TTT.empty) &&
        (gameState[3] == gameState[4]) &&
        (gameState[4] == gameState[5])) {
      message = '${this.gameState[3]} wins';
      return true;
    } else if ((gameState[6] != TTT.empty) &&
        (gameState[6] == gameState[7]) &&
        (gameState[7] == gameState[8])) {
      message = '${this.gameState[6]} wins';
      return true;
    } else if ((gameState[0] != TTT.empty) &&
        (gameState[0] == gameState[3]) &&
        (gameState[3] == gameState[6])) {
      message = '${this.gameState[0]} wins';
      return true;
    } else if ((gameState[1] != TTT.empty) &&
        (gameState[1] == gameState[4]) &&
        (gameState[4] == gameState[7])) {
      message = '${this.gameState[1]} wins';
      return true;
    } else if ((gameState[2] != TTT.empty) &&
        (gameState[2] == gameState[5]) &&
        (gameState[5] == gameState[8])) {
      message = '${this.gameState[2]} wins';
      return true;
    } else if ((gameState[0] != TTT.empty) &&
        (gameState[0] == gameState[4]) &&
        (gameState[4] == gameState[8])) {
      message = '${this.gameState[0]} wins';
    } else if ((gameState[2] != TTT.empty) &&
        (gameState[2] == gameState[4]) &&
        (gameState[4] == gameState[6])) {
      message = '${this.gameState[2]} wins';
      return true;
    } else if (!gameState.contains(TTT.empty)) {
      message = 'Game Draw';
      return true;
    } else {
      return false;
    }
    print(message);
  }
}

enum TTT {
  empty,
  cross,
  circle,
}
