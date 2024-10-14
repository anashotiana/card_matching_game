import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Matching Game',
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Map<String, dynamic>> cards = [];
  Map<String, dynamic>? firstCard;
  Map<String, dynamic>? secondCard;

  @override
  void initState() {
    super.initState();
    initializeCards();
  }

  // Step 1: Initialize the cards with pairs and shuffle them
  void initializeCards() {
    List<String> images = [
      'assets/images/card1.png',
      'assets/images/card2.png',
      'assets/images/card3.png',
      'assets/images/card4.png',
      'assets/images/card5.png',
      'assets/images/card6.png',
      'assets/images/card7.png',
      'assets/images/card8.png',
    ];

    cards = [];

    // Create pairs of cards (each image appears twice)
    for (String image in images) {
      cards.add({'image': image, 'isFlipped': false, 'isMatched': false});
      cards.add({'image': image, 'isFlipped': false, 'isMatched': false});
    }

    // Shuffle the cards to randomize the positions
    cards.shuffle();
  }

  // Step 2: Define the onCardTapped method to handle card flips
  void onCardTapped(Map<String, dynamic> tappedCard) {
    if (tappedCard['isFlipped'] || tappedCard['isMatched']) {
      return;
    }

    setState(() {
      tappedCard['isFlipped'] = true;

      if (firstCard == null) {
        firstCard = tappedCard;
      } else if (secondCard == null) {
        secondCard = tappedCard;
        checkForMatch();
      }
    });
  }

  // Step 3: Check if the two selected cards match
  void checkForMatch() {
    if (firstCard!['image'] == secondCard!['image']) {
      // Cards match
      setState(() {
        firstCard!['isMatched'] = true;
        secondCard!['isMatched'] = true;
        firstCard = null;
        secondCard = null;
        checkForWin();
      });
    } else {
      // Cards don't match, flip them back after a delay
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          firstCard!['isFlipped'] = false;
          secondCard!['isFlipped'] = false;
          firstCard = null;
          secondCard = null;
        });
      });
    }
  }

  // Step 4: Check if all cards are matched (win condition)
  void checkForWin() {
    bool hasWon = cards.every((card) => card['isMatched']);

    if (hasWon) {
      showWinDialog();
    }
  }

  // Step 5: Show a dialog when the player wins
  void showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Congratulations!'),
        content: Text('You have matched all the cards!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Restart the game by reinitializing the cards
              setState(() {
                initializeCards();
              });
            },
            child: Text('Play Again'),
          ),
        ],
      ),
    );
  }

  // Step 6: Build the UI for the game grid
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Matching Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Number of columns (4x4 grid)
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: cards.length, // Total number of cards
          itemBuilder: (context, index) {
            final card = cards[index];
            return GestureDetector(
              onTap: () {
                onCardTapped(card);
              },
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      card['isFlipped'] || card['isMatched']
                          ? card['image'] // Show front if flipped or matched
                          : 'assets/images/back.png', // Show back if not flipped
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
