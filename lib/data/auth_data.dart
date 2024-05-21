import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_drive/data/firestore.dart';

abstract class AuthenticationDatasource {
  Future<void> register(
      String email, String password, String namaLengkap, String nomorHandphone);
  Future<void> login(String email, String password);
}

class AuthenticationRemote extends AuthenticationDatasource {
  final Firestore_Datasource _firestoreDatasource = Firestore_Datasource();
  @override
  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  }

  @override
  Future<void> register(String email, String password, String namaLengkap,
      String nomorHandphone) async {
    try {
      // Ensure that createUser is awaited
      bool userCreated = await _firestoreDatasource.createUser(
        email,
        namaLengkap,
        nomorHandphone,
      );

      if (userCreated) {
        // ignore: avoid_print
        print('User registered and data stored successfully');
      } else {
        // Handle the failure case if necessary
        throw Exception('Failed to store user data in Firestore');
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error during registration: $e');
      rethrow; // Ensure the error is rethrown to handle it upstream if needed
    }

    // Explicitly return a Future<void>
    return;
  }
}
