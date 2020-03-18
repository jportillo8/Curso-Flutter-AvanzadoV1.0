import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageAPI {
  //Esto obtiene la referencia correspondiente a la url
  final StorageReference _storageReference = FirebaseStorage.instance.ref();

  //Este metodo se enfoca a la subida
  Future<StorageUploadTask> uploadFile(String path, File image) async{

    //UNO RECIBE EL PATH Y EL OTRO EL OBJETO REAL
    return _storageReference.child(path).putFile(image); //ESTAMOS MANEJANDO ANIDACION ES DECIR HIJOS

  }
}