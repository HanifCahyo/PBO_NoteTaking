import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class Firestore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> createUser(
      String email, String namaLengkap, String nomorHandphone) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'id': _auth.currentUser!.uid,
        'email': email,
        'namaLengkap': namaLengkap.trim(),
        'nomorHandphone': nomorHandphone.trim(),
      });
      return true;
    } catch (e) {
      // ignore: avoid_print
      print('Error creating user in Firestore: $e');
      return false;
    }
  }

  Future<bool> AddNote(String subtitle, String title, int image) async {
    try {
      var uuid = const Uuid().v4();
      DateTime data = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .set({
        'id': uuid,
        'subtitle': subtitle,
        'isDone': false,
        'image': image,
        'title': title,
        'time': data,
      });
      return true;
    } catch (e) {
      return true;
    }
  }
}
