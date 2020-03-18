import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthAPI {

  //contiene la instancia - todo lo que exite en la conosola de firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();


  //
  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    AuthResult authResult = await _auth.signInWithCredential(
        GoogleAuthProvider.getCredential(idToken: gSA.idToken, accessToken: gSA.accessToken));

    FirebaseUser user = await authResult.user;

    return user;

  }

  void singnOut() async {
    await _auth.signOut().then((onValue) => print("Secion Cerrada"));
    googleSignIn.signOut();
    print("Secionnes Cerradas");
  }
}