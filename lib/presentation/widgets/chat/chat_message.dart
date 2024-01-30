import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  final String text;
  final String uuid;
  final AnimationController animationController;

  const ChatMessage({
    super.key, 
    required this.text,
    required this.uuid, required this.animationController
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animationController, 
          curve: Curves.elasticIn
        ),
        child: Container(
          child: uuid == '123' 
            ? _myMessage()
            : _notMyMessage(),
        ),
      ),
    );
  }

  Widget _myMessage() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          right: 5, 
          left: 50,
          bottom: 5
        ),
        decoration: const BoxDecoration(
          color: Color(0xff4D9EF6),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            topRight: Radius.circular(1),
          )
        ),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 15),),
      ),
    );
  }

  Widget _notMyMessage() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(
          left: 5, 
          right: 50,
          bottom: 5
        ),
        decoration: const BoxDecoration(
          color: Color(0xffE4E5E8),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topLeft: Radius.circular(1),
            topRight: Radius.circular(20),
          )
        ),
        child: Text(text, style: const TextStyle( fontSize: 15)),
      ),
    );
  }
}