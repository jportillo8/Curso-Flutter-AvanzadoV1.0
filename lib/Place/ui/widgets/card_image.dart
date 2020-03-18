import 'dart:io';

import 'package:flutter/material.dart';
import 'package:platzi_trips_app/widgets/floating_action_button_green.dart';

class CardImageWithFabIcon extends StatelessWidget {

  //VARIABLES GENERICAS
  final double height;
  final double width;
  double left = 20.0;
  final String pathImage;
  final VoidCallback onPressedFabIcon;
  final IconData iconData;

  //SOLUCION AL BUG
  final File image;
  bool camera = false;


  CardImageWithFabIcon({
    Key key,
    @required this.pathImage,
    @required this.width,
    @required this.height,
    @required this.image,
    @required this.onPressedFabIcon,
    @required this.iconData,
    this.camera,
    this.left
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    final card = Container(
      height: height,
      width: width,
      margin: EdgeInsets.only(
          left: left

      ),

      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              //SI LA CAMARA ESTA ENCENDIDA ()
              image: camera == true ? FileImage(image) : NetworkImage(pathImage),

          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          shape: BoxShape.rectangle,
          boxShadow: <BoxShadow>[
            BoxShadow (
                color:  Colors.black38,
                blurRadius: 15.0,
                offset: Offset(0.0, 7.0)
            )
          ]

      ),
    );

    return Stack(
      alignment: Alignment(0.9,1.1),
      children: <Widget>[
        card,
        FloatingActionButtonGreen(
          iconData: iconData, onPressed: onPressedFabIcon,)
      ],
    );
  }


}