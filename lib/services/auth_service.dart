import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<String?> cadastrarUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredentials = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredentials.user!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "Email já cadastrado";
      }
      return e.message;
    }
    return null;
  }

  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "Usuário não encontrado";
      } else if (e.code == 'wrong-password') {
        return "Senha incorreta";
      } else if (e.code == 'invalid-email') {
        return "Email inválido";
      } else if (e.code == 'user-disabled') {
        return "Usuário desativado";
      }
      return e.message;
    }
    return null;
  }

  Future<String?> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential = await firebaseAuth.signInWithCredential(
        credential,
      );
      if (userCredential.user != null) {
        // User is signed in
        return userCredential.user!.uid;
      }
    }
    // User is not signed in
    return null;
  }

  Future<void> logoutUser() async {
    return await firebaseAuth.signOut();
  }
}
