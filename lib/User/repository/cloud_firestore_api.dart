import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/Place/ui/widgets/card_image.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/User/ui/widgets/profile_place.dart';

class CloudFirestoreAPI {
  final String USERS = "users";
  final String PLACES = "places";

  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //La primera vez se va registrar
  void updateUserData(User user) async {
    //La colleciones
    DocumentReference ref = _db.collection(USERS).document(user.uid);
    return await ref.setData({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'photoURL': user.photoURL,
      'myPlaces': user.myPlaces,
      'myFavoritePlaces': user.myFavoritePlaces,
      //Devuelve la fecha de ese momento
      'lastSingnIn': DateTime.now()
    }, merge: true);
  }

  // FUTURO PARA PODER CONTROLAR EL ESATADO DE LA SUBIDA
  Future <void> updatePlaceData(Place place) async {
    //COMO NO HAY IDENTIFICADOR FIRESTORE PUEDE DARNOS UNO
    CollectionReference refPlaces = _db.collection(PLACES);

    //CONSULTANDO AL USUARIO LOGEADO
    await _auth.currentUser().then((FirebaseUser user){
      // AWAIT es para ejecutar en segundo plano // add PERMITE GENERAR UN IDENTIFICADOR UNICO Y AUTOINCREMENTADO
      refPlaces.add({
           'name': place.name,
           'description': place.description,
           'likes' : place.likes,
        'urlImage': place.urlImage,
           // TIPO DE DATO REFERENCIA, LA RUTA A SEGUIR DEL USUARIO EN ESPECIFICO
           //USER-IDENTIFICADOR DEL USUARIO
           'userOwner': _db.document("${USERS}/${user.uid}" ),//Reference
         }).then((DocumentReference dr){//ESTE COLBACK NOS REGRESA EL OBJETO REF
           dr.get().then((DocumentSnapshot snapshot){//PARA PODER CAPTURAR EL SNAPSHOT

             //snapshot.documentID;//ID Place REFERENCIA ARRAY?
             DocumentReference refUsers = _db.collection(USERS).document(user.uid); //Data del Usuario Especifico
             refUsers.updateData({//Almacenando los Datos que Queremos
               'myPlaces' : FieldValue.arrayUnion([
                 _db.document("${PLACES}/${snapshot.documentID}")
               ]) // Push al array
             });

           });


      });
    });

  }

  //Nuevo metodo que devolvera una lista de objetos
List<ProfilePlace> builMyPlaces(List<DocumentSnapshot> placesListSnapshot){
    //Procesando la data que acabamos de obtener
  List<ProfilePlace> profilePlaces = List<ProfilePlace>();
  placesListSnapshot.forEach((p){
    //Rellenando la lista
    profilePlaces.add(ProfilePlace(
      Place(
          name: p.data['name'],
          description: p.data['description'],
          urlImage: p.data['urlImage'],
        likes: p.data['likes']
      )
    ));
    
  });

  return profilePlaces;
}
//Nuevo metodo que me construira el Home
List<Place> buildPlaces(List<DocumentSnapshot> placesListSnapshot, User user){

    List<Place> places = List<Place>();

    //Lista que estamos esperando devolver
   // List<CardImageWithFabIcon> placesCard = List<CardImageWithFabIcon>();
    //Vamos a recorer la lista Obteniedo cada elemento
    placesListSnapshot.forEach((p)  {
      Place place = Place(id: p.documentID, name: p.data["name"], description: p.data["description"],
          urlImage: p.data["urlImage"],likes: p.data["likes"]
      );
      List usersLikedRefs =  p.data["usersLiked"];
      place.liked = false;
      usersLikedRefs?.forEach((drUL){
        if(user.uid == drUL.documentID){
          place.liked = true;
        }
      });
      places.add(place);
    });
    return places;
}


//Funcion para poder dar like en tiempo real
Future likePlace(Place place, String uid) async {
    await _db.collection(PLACES).document(place.id).get()
        .then((DocumentSnapshot ds){
          int likes = ds.data["likes"];

          _db.collection(PLACES).document(place.id)
          .updateData({
            'likes': place.liked?likes+1:likes-1,
            'usersLiked': place.liked?
                FieldValue.arrayUnion([_db.document("${USERS}/${uid}")]):
                FieldValue.arrayRemove([_db.document("${USERS}/${uid}")])

          });

    });
}
}

