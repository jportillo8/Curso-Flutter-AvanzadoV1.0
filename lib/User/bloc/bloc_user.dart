import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzi_trips_app/Place/model/place.dart';
import 'package:platzi_trips_app/Place/repository/firebase_storage_repository.dart';
import 'package:platzi_trips_app/Place/ui/widgets/card_image.dart';
import 'package:platzi_trips_app/User/model/user.dart';
import 'package:platzi_trips_app/User/repository/auth_repository.dart';
import 'package:platzi_trips_app/User/repository/cloud_firestore_api.dart';
import 'package:platzi_trips_app/User/repository/cloud_firestore_repository.dart';
import 'package:platzi_trips_app/User/ui/widgets/profile_place.dart';


class UserBloc implements Bloc {

  final _auth_repository = AuthRepository();

  //Flujo de Datos- Streams
  //Stream - firebase
  Stream <FirebaseUser> streamFirebase = FirebaseAuth.instance
      .onAuthStateChanged;

  Stream<FirebaseUser> get authStatus => streamFirebase;

  //NESECITAMOS UN IDENTIFICADOR DE USUARIO.
  Future<FirebaseUser> get currentUser => FirebaseAuth.instance.currentUser();

  //Casos de uso del obejto uso
  //1. SignIn a a la aplicacion de google

  Future<FirebaseUser> signIn() => _auth_repository.signInFirebase();

  //2. Registrar usuario en base de Datos
  final _cloudFirestoreRepository = CloudFirestoreRepository();

  //A.Esa ventana de Places deberia siempre estar en escucha........
  //Traeme una fotografia de tod lo que exista en la instancia en la base de datos cuya collecion
  //corresponda a los places y ponte en escucha
  Stream<QuerySnapshot> placesListStream = Firestore.instance.collection(CloudFirestoreAPI().PLACES).snapshots();
  Stream<QuerySnapshot> get placesStream => placesListStream;//Este es el que vamos a estar escuchando

  //Obtenniedo los places para el home
 /* List<CardImageWithFabIcon> buildPlaces(List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreRepository.buildPlaces(placesListSnapshot);*/
  List<Place> buildPlaces(List<DocumentSnapshot> placesListSnapshot, User user) => _cloudFirestoreRepository.buildPlaces(placesListSnapshot, user);
  Future likePlace(Place place, String uid) => _cloudFirestoreRepository.likePlace(place,uid);




  //Mapeando Datos
  List<ProfilePlace> builMyPlaces(List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreRepository.builMyPlaces(placesListSnapshot);

  //Metodo para pasar el Id con y el Usuario Respectivo
  Stream<QuerySnapshot> myPlacesStream(String uid) =>
      Firestore.instance.collection(CloudFirestoreAPI().PLACES)
      //Aplicando Filtro--- Nombre del campo ---- es igual al (Identificador)
          .where("userOwner", isEqualTo:
          //Referencia
      Firestore.instance.document("${CloudFirestoreAPI().USERS}/${uid}")).snapshots();

  //3. PONEMOS EL BLOCK EN EL USER EL DE FIREBASE STORAGE API-REPOSITORY
  final _firebaseStorageRepository = FirebaseStorageReposotory();
  Future<StorageUploadTask> uploadFile(String path, File image) => _firebaseStorageRepository.uploadFile(path, image);

  void updateUserData(User user) =>
      _cloudFirestoreRepository.updateUserDataFirestore(user);

  //METODO PARA LA SUBIDA DE DATOS
  Future<void> updatePlaceData(Place place) =>
      _cloudFirestoreRepository.updatePlaceData(place);

  signOut() {
    _auth_repository.signOut();
  }

  @override
  void dispose() {

  }
}