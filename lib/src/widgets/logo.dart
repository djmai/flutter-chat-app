import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String texto;
  final String img;

  const Logo({
    Key? key,
    required this.texto,
    required this.img,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150,
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            Image(
              image: AssetImage(this.img),
            ),
            SizedBox(height: 20),
            Text(this.texto, style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
