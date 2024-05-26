// ignore_for_file: camel_case_types, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test_drive/data/firestore.dart';
import 'package:test_drive/widgets/folder_widgets.dart';

class folder_note extends StatelessWidget {
  const folder_note({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore_Datasource().streamFolder(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // ignore: prefer_const_constructors
            return CircularProgressIndicator();
          }
          final foldersList = Firestore_Datasource().getFolders(snapshot);
          return ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final folder = foldersList[index];
              return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    Firestore_Datasource().DeleteFolder(folder.id);
                  },
                  child: Folder_Widget(folder));
            },
            itemCount: foldersList.length,
          );
        });
  }
}
