import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  final String imagePath;
  final bool isFlipped;
  final VoidCallback onTap;

  CardTile({
    required this.imagePath,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              isFlipped ? imagePath : 'assets/images/back.png',
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
