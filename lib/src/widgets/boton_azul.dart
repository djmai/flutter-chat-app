import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const BotonAzul({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(this.text),
      style: TextButton.styleFrom(
        primary: Colors.white,
        backgroundColor: Colors.blueAccent,
        elevation: 5,
        minimumSize: Size(MediaQuery.of(context).size.width * 0.9, 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
