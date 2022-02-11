import 'package:flutter/material.dart';
import 'package:socket_flutter/src/model/message.dart';
import 'package:flip_card/flip_card.dart';

class TextBubble extends StatelessWidget {
  const TextBubble({Key? key, required this.message}) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: FlipCard(
        flipOnTouch: message.translated != null,
        front: BubbleSelf(
          text: message.text,
          bubbleColor: message.isCurrent ? Colors.green : Colors.grey[200],
          textColor: message.isCurrent ? Colors.white : Colors.grey[800],
          bottomLeft: message.isCurrent ? 12 : 0,
          bottomRight: message.isCurrent ? 0 : 12,
        ),
        back: BubbleSelf(
          text: message.translated ?? "",
          bubbleColor: message.isCurrent ? Colors.green : Colors.grey[200],
          textColor: message.isCurrent ? Colors.black : Colors.grey[800],
          bottomLeft: message.isCurrent ? 12 : 0,
          bottomRight: message.isCurrent ? 0 : 12,
        ),
        direction: FlipDirection.HORIZONTAL,
        onFlip: () {},
        onFlipDone: (isFront) {},
      ),
    );
  }
}

class BubbleSelf extends StatelessWidget {
  const BubbleSelf({
    Key? key,
    required this.text,
    this.bubbleColor,
    this.textColor,
    required this.bottomLeft,
    required this.bottomRight,
  }) : super(key: key);

  final String text;
  final Color? bubbleColor;
  final Color? textColor;
  final double bottomLeft;
  final double bottomRight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.6,
      ),
      decoration: BoxDecoration(
        color: bubbleColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(bottomLeft),
          bottomRight: Radius.circular(bottomRight),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
