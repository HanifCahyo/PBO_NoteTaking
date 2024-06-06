// ignore_for_file: camel_case_types, non_constant_identifier_names, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_drive/model/notes_model.dart';
import 'package:uuid/uuid.dart';
import 'package:async/async.dart';

class Firestore_Datasource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create User //
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
  Future AddNote(String title, String folderId, String Subtitle) async {
    try {
      var uuid = const Uuid().v4();
      DateTime data = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('folders')
          .doc(folderId)
          .collection('notes')
          .doc(uuid)
          .set({
        'id': uuid,
        'userId': _auth.currentUser!.uid,
        'folderId': folderId,
        'title': title,
        'subtitle': Subtitle,
        'time': '${data.hour}:${data.minute}',
      });
      return true;
    } catch (e) {
      return true;
    }
  }

  Future<void> ensureRootFolderExists() async {
    try {
      var rootDoc = _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('folders')
          .doc('root');

      var docSnapshot = await rootDoc.get();
      if (!docSnapshot.exists) {
        await rootDoc.set({
          'folderName': 'Root',
          'folderId': null, // Set folderId to null for the root folder
        });
      } else if (!docSnapshot.data()!.containsKey('folderId')) {
        await rootDoc.update({
          'folderId':
              null, // Ensure folderId is set to null if it doesn't exist
        });
      }
    } catch (e) {
      print('Error ensuring root folder exists: $e');
    }
  }

  // Add Note //
  Future AddRootNote(String title, String Subtitle) async {
    try {
      var uuid = const Uuid().v4();
      DateTime data = DateTime.now();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('folders')
          .doc('root')
          .collection('notes')
          .doc(uuid)
          .set({
        'id': uuid,
        'userId': _auth.currentUser!.uid,
        'title': title,
        'subtitle': Subtitle,
        'time': '${data.hour}:${data.minute}',
        'folderId': null, // Add folderId with null value
      });
      return true;
    } catch (e) {
      return true;
    }
  }

  // Delete Note //
  Future deleteNote(String Id, String folderId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('folders')
          .doc(folderId)
          .collection('notes')
          .doc(Id)
          .delete();
      return true;
    } catch (e) {
      print('Error deleting note: $e');
      return false;
    }
  }

  // Add Folder //
  Future AddFolder(String folderName, [String? parentId]) async {
    try {
      var uuid = const Uuid().v4();
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('folders')
          .doc(uuid)
          .set({
        'folderId': uuid,
        'parentId': parentId,
        'folderName': folderName,
      });
      return true;
    } catch (e) {
      print('Error adding folder: $e');
      return false;
    }
  }

  // Get Notes //
  Future<List<Note>> getNotes(String folderId) async {
    try {
      var notes = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('folders')
          .doc(folderId)
          .collection('notes')
          .get();
      return notes.docs
          .map((note) => Note(
                note.id,
                note['subtitle'],
                note['title'],
                note['folderId'],
              ))
          .toList();
    } catch (e) {
      print('Error getting notes: $e');
      return [];
    }
  }

  // Stream Notes //
  Stream<QuerySnapshot> streamNotes(String folderId) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('folders')
        .doc(folderId)
        .collection('notes')
        .snapshots();
  }

  // Stream Notes //
  Stream<QuerySnapshot> stream() {
    String uid = _auth.currentUser!.uid;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('folders')
        .snapshots()
        .asyncExpand((foldersSnapshot) async* {
      List<Stream<QuerySnapshot>> notesStreams = [];
      for (var folderDoc in foldersSnapshot.docs) {
        var notesStream = _firestore
            .collection('users')
            .doc(uid)
            .collection('folders')
            .doc(folderDoc.id)
            .collection('notes')
            .snapshots();
        notesStreams.add(notesStream);
      }
      yield* StreamGroup.merge(notesStreams);
    });
  }

  // Stream Folder //
  Stream<QuerySnapshot> streamFolder([String? parentId]) {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('folders')
        .where('parentId', isEqualTo: parentId)
        .snapshots();
  }

  // Stream root Nodes //
  Stream<QuerySnapshot> streamRootNotes() {
    return _firestore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .collection('folders')
        .doc('root')
        .collection('notes')
        .where('folderId', isEqualTo: null)
        .snapshots();
  }

  // Update Note //
  Future<void> updateNote(
      String noteId, String title, String folderId, String subtitle) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('folders')
          .doc(folderId)
          .collection('notes')
          .doc(noteId)
          .update({
        'title': title,
        'subtitle': subtitle,
      });
    } catch (e) {
      print('Error updating note: $e');
    }
  }

  Future<void> updateRootNote(
      String noteId, String title, String subtitle) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('folders')
          .doc('root')
          .collection('notes')
          .doc(noteId)
          .update({
        'title': title,
        'subtitle': subtitle,
      });
    } catch (e) {
      print('Error updating root note: $e');
    }
  }

  Future<void> deleteRootNote(String noteId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('folders')
          .doc('root')
          .collection('notes')
          .doc(noteId)
          .delete();
    } catch (e) {
      print('Error deleting root note: $e');
    }
  }

  Future<void> deleteFolder(String folderId) async {
    try {
      // Get reference to the folder document
      DocumentReference folderRef = _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('folders')
          .doc(folderId);

      // Delete all subfolders and notes recursively
      await _deleteSubFoldersAndNotes(folderRef);

      // Delete the folder document itself
      await folderRef.delete();
    } catch (e) {
      print('Error deleting folder: $e');
    }
  }

  Future<void> _deleteSubFoldersAndNotes(DocumentReference folderRef) async {
    QuerySnapshot subFolders = await folderRef.collection('subFolders').get();
    for (DocumentSnapshot subFolder in subFolders.docs) {
      await _deleteSubFoldersAndNotes(subFolder.reference);
      await subFolder.reference.delete();
    }

    QuerySnapshot notes = await folderRef.collection('notes').get();
    for (DocumentSnapshot note in notes.docs) {
      await note.reference.delete();
    }
  }
}
