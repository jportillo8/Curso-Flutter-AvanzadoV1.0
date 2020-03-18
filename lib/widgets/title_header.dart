import 'package:flutter/material.dart';

class TitleHeader extends StatelessWidget {
  final String title;

  const TitleHeader({Key key, this.title});

  @override
  Widget build(BuildContext context) {

    //PREPARAREMOS EL TITULO APREBA DE DESBORDE CON FLEXIBLE
    return Text(
      title,
      style: TextStyle(
          color: Colors.white,
          fontSize: 30.0,
          fontFamily: "Lato",
          fontWeight: FontWeight.bold),
    );
  }
}
