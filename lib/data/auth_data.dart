import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AuthenticationDatasource {
  Future<void> register(
      String email, String password, String namaLengkap, String nomorHandphone);
  Future<void> login(String email, String password);
}

class AuthenticationRemote extends AuthenticationDatasource {
  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  }

  @override
  Future<void> register(String email, String password, String namaLengkap,
      String nomorHandphone) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim());
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(userCredential.user?.uid).set({
      'namaLengkap': namaLengkap.trim(),
      'nomorHandphone': nomorHandphone.trim(),
    });
  }
}
