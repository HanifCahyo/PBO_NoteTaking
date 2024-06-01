// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_drive/model/notes_model.dart';
import 'package:uuid/uuid.dart';

class Firestore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future createUser(
      String email, String namaLengkap, String nomorHandphone) async {
    try {
      await _firestore.collection('users').doc(_auth.currentUser!.uid).set({
        'id': _auth.currentUser!.uid,
        'email': email,
        'namaLengkap': namaLengkap,
        'nomorHandphone': nomorHandphone,
      });
      return true;
    } catch (e) {
      print('Error creating user in Firestore: $e');
      return false;
    }
  }

  // Add Note //
  Future AddNote(String subtitle, String title, int image) async {
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
        'image': image,
        'title': title,
        'time': '${data.hour}:${data.minute}',
      });
      return true;
    } catch (e) {
      return true;
    }
  }

  // Delete Folder //

  Future DeleteFolder(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('folders')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Get Notes //

  List getNotes(AsyncSnapshot snapshot) {
    try {
      final notesList = snapshot.data.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Note(
          data['id'],
          data['subtitle'],
          data['time'],
          data['image'],
          data['title'],
        );
      }).toList();
      return notesList;
    } catch (e) {
      print('Error adding note to folder: $e');
      return [];
    }
  }

  // Stream Notes //

  Stream<QuerySnapshot> stream() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notes')
        .snapshots();
  }

  // Stream Folder //
  Stream<QuerySnapshot> streamFolder() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('folders')
        .snapshots();
  }

  Future Update_Note(
      String uuid, int image, String title, String subtitle) async {
    try {
      DateTime data = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .update({
        'time': '${data.hour}:${data.minute}',
        'subtitle': subtitle,
        'image': image,
        'title': title,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future Delete_Note(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notes')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future AddFolder(String folderName) async {
    try {
      var uuid = const Uuid().v4();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('folders')
          .doc(uuid)
          .set({
        'folderId': uuid,
        'folderName': folderName,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  List getFolders(AsyncSnapshot snapshot) {
    try {
      final foldersList = snapshot.data.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Folder(data['folderId'], data['folderName']);
      }).toList();
      return foldersList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future AddNoteToFolder(
      String folderId, String subtitle, String title, int image) async {
    try {
      var uuid = const Uuid().v4();
      DateTime data = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notesFolder')
          .doc(uuid)
          .set({
        'id': uuid,
        'folderIdNote': folderId,
        'subtitle': subtitle,
        'image': image,
        'title': title,
        'time': '${data.hour}:${data.minute}',
      });
      return true;
    } catch (e) {
      print('Error adding note to folder: $e');
      return false;
    }
  }

  Future Delete_Note_Inside_Folder(String uuid) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notesFolder')
          .doc(uuid)
          .delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future Update_Note_Inside_Folder(
      String uuid, int image, String title, String subtitle) async {
    try {
      DateTime data = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('notesFolder')
          .doc(uuid)
          .update({
        'time': '${data.hour}:${data.minute}',
        'subtitle': subtitle,
        'image': image,
        'title': title,
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  List getNotesInsideFolder(AsyncSnapshot snapshot) {
    try {
      final notesList2 = snapshot.data.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return NoteInsideFolder(data['id'], data['folderIdNote'],
            data['subtitle'], data['time'], data['image'], data['title']);
      }).toList();
      return notesList2;
    } catch (e) {
      print('Error adding note to folder: $e');
      return [];
    }
  }

  Stream<QuerySnapshot> streamNotesInsideFolder(String folderId) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('notesFolder')
        .where('folderIdNote', isEqualTo: folderId)
        .snapshots();
  }
}
