import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/Place/ui/widgets/card_image.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/User/ui/widgets/title_input_location.dart';
import 'package:platzi_trips_app/widgets/button_purple.dart';
import 'package:platzi_trips_app/widgets/gradient_back.dart';
import 'package:platzi_trips_app/widgets/text_input.dart';
import 'package:platzi_trips_app/widgets/title_header.dart';

class AddPlaceScreen extends StatefulWidget {
//Preparado para implementar una imagen
  File image;
  bool camera = false;

  AddPlaceScreen({Key key, this.image, this.camera});

  @override
  State createState() {
    return _AddPlaceScreen();
  }
}

//Añadiendo boton
class _AddPlaceScreen extends State<AddPlaceScreen> {
  @override
  Widget build(BuildContext context) {
    //CONTROLADOR DEL TITTULO Y DE LA DESCRIPCION
    final _controllerTitlePlace = TextEditingController();
    final _controllerDescriptionPlace = TextEditingController();

    //PARA LA SUBIDA DE DATOS
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GradientBack(height: 300.0),
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 25.0, left: 5.0),
                child: SizedBox(
                  height: 45.0,
                  width: 45.0,
                  child: IconButton(
                      icon: Icon(Icons.keyboard_arrow_left,
                          color: Colors.white, size: 45.0),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              Flexible(
                  child: Container(
                padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 10.0),
                child: TitleHeader(title: "Add a new Place"),
              ))
            ],
          ),
          //INSERTANDO EL TEXTFIELD Y TAMBIEN DANDO UN SAFE AREA
          Container(
            margin: EdgeInsets.only(top: 120.0, bottom: 20.0),
            child: ListView(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: CardImageWithFabIcon(
                    //PASANDO LA IMAGEN CAPTURADA POR LA CAMARA
                    pathImage: widget.image.path,
                    image: widget.image,
                    camera: widget.camera,
                    iconData: Icons.camera_alt,
                    width: 250.0,
                    height: 250.0,
                    onPressedFabIcon: () {},
                    left: 0,
                  ),
                ), //FOTO
                Container(
                  //TEXTFIELD TITLE
                  margin: EdgeInsets.only(bottom: 20.0, top: 20.0),
                  child: TextInput(
                    controller: _controllerTitlePlace,
                    inputType: null,
                    hintText: "Title",
                    maxLines: 1,
                  ),
                ),
                TextInput(
                  //DESCRIPTION
                  hintText: "Description",
                  inputType: TextInputType.multiline,
                  maxLines: 4,
                  controller: _controllerDescriptionPlace,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextInputLocation(
                      iconData: Icons.location_on,
                      controller: null,
                      hintText: "Add Location"),
                ),
                Container(
                  width: 70.0,
                  child: ButtonPurple(
                    buttonText: "Add Place",
                    onPressed: () {
                      //ID del usuario que esta logeado
                      userBloc.currentUser.then((FirebaseUser user) {
                        //LA VALIDACION PARA LA SUBIDA
                        if (user != null) {
                          String uid =
                              user.uid; // AHORA YA TENEMOS NUESTRO USER ID
                          String path =
                              "${uid}/${DateTime.now().toString()}.jpg"; //CONSTRUYENDO EL PATH DE FIREBASESTORAGE
                          //CON LA FECHA ACTUAL
                          //1. Firebase Storage
                          //url-
                          userBloc
                              .uploadFile(path, widget.image) // SUBE LA IMAGEN
                              .then((StorageUploadTask storageUploadTask) {
                            //ESTE OBJETO CONTIENE LA IMAGEN YA SUBIDA
                            storageUploadTask.onComplete
                                .then((StorageTaskSnapshot snapshot) {
                              //CUANDO ESTE COMPLETO DEVUELVEME LO QUE EXISTE EN EL FIRESTORE
                              snapshot.ref.getDownloadURL().then((urlImages) {
                                //OBTENIENDO POR FIN LA URL
                                print(
                                    "URLIMAGE ${urlImages}"); //SE EJECUTARA O DEVOLVERA EL METODO DEFINIDO

                                //2. Cloud Firestore
                                //Place - title, description, url, userOwner, likes
                                userBloc.updatePlaceData(Place(
                                  //VOY OBTENIENDO EL TEXTO DE LO QUE ESCRIBA GRACIAS AL CONTROLLER
                                  name: _controllerTitlePlace.text,
                                  description: _controllerDescriptionPlace.text,
                                  urlImage: urlImages,
                                  likes: 0,
                                  //AÑADIENDO EL PARAMETRO OBTENIDO

                                  //AL ESTAR USANDO UN FUTURO PUEDO USAR EL METODO WHEN...
                                  //CUANDO LO ANTERIOR TERMINE DE CARGARSE ENTONCES...
                                )).whenComplete(() {
                                  //MOSTRAMOS QUE TERMINO
                                  print("TERMINO");
                                  //Y DESTRUIMOS LA VENTANA
                                  Navigator.pop(context);
                                });
                              });
                            });
                          });


                        }
                      });
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
