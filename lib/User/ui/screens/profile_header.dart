import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/User/bloc/bloc_user.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/User/ui/widgets/user_info.dart';
import 'package:platzi_trips_app/User/ui/widgets/button_bar.dart';

class ProfileHeader extends StatelessWidget {
  //UserBloc userBloc;
  User user;

  ProfileHeader(@required this.user);

  @override
  Widget build(BuildContext context) {
    //userBloc = BlocProvider.of<UserBloc>(context);

    /*return StreamBuilder(
      //Rastreando el flujo de datos
      stream: userBloc.streamFirebase,
      //Una obtenga los datos le vamos a decir que cosa tengo que ejecutar
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //Aqui la tarea que deseamos que se ejecute --- Verificando el estado de la conexion
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.none:
            return CircularProgressIndicator();
          case ConnectionState.active:
            return showProfileData(snapshot);
          case ConnectionState.done:
            return showProfileData(snapshot);
        }
      },
    );*/

    final title = Text(
      'Profile',
      style: TextStyle(
          fontFamily: 'Lato',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30.0
      ),
    );

    return Container(
      margin: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 50.0
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              title
            ],
          ),
          UserInfo(user),
          ButtonsBar()
        ],
      ),
    );



  }
//Creando la interfaz en un widget -- Valindo que el objeto tenga datos
Widget showProfileData(AsyncSnapshot snapshot) {
  if (!snapshot.hasData || snapshot.hasError) {
    print("no logeado");
    return Container(
      margin: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 50.0
      ),
      child: Column(
        children: <Widget>[
          CircularProgressIndicator(),
          Text("No se puede cargar la informacion has login")
        ],
      ),
    );
  } else {
    print("logeado");
    print(snapshot.data);

    user = User(name: snapshot.data.displayName, email: snapshot.data.email, photoURL: snapshot.data.photoUrl);
    final title = Text(
      'Profile',
      style: TextStyle(
          fontFamily: 'Lato',
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 30.0
      ),
    );

    return Container(
      margin: EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          top: 50.0
      ),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              title
            ],
          ),
          UserInfo(user),
          ButtonsBar()
        ],
      ),
    );
  }
}
}
