// ignore_for_file: camel_case_types, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_drive/data/firestore.dart';
import 'package:test_drive/widgets/task_widgets_insides_folder.dart';

class Stream_note_insides_folder extends StatelessWidget {
  final String folderId;
  bool done;
  Stream_note_insides_folder(this.folderId, this.done, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore_Datasource().streamNotesInsideFolder(folderId, done),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // ignore: prefer_const_constructors
            return CircularProgressIndicator();
          }
          final noteslist2 =
              Firestore_Datasource().getNotesInsideFolder(snapshot);
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final note = noteslist2[index];
              return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {},
                  child: Task_Widget_insides_folder(note));
            },
            itemCount: noteslist2.length,
          );
        });
  }
}
