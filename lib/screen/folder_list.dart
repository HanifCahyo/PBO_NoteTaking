// ignore_for_file: camel_case_types, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:test_drive/const/colors.dart';
import 'package:test_drive/screen/add_note_screen_insides_folder.dart';
import 'package:test_drive/screen/home.dart';
import 'package:test_drive/widgets/stream_note_insides_folder.dart';

class Folder_Screen_List extends StatefulWidget {
  final String folderId;
  const Folder_Screen_List(this.folderId, {super.key});

  @override
  State<Folder_Screen_List> createState() => _Folder_Screen_ListState();
}

class _Folder_Screen_ListState extends State<Folder_Screen_List> {
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      floatingActionButton: Visibility(
        visible: show,
        child: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          backgroundColor: custom_green,
          children: [
            SpeedDialChild(
              child: Icon(Icons.back_hand),
              label: 'Back',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Home_Screen()),
                );
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.note_add),
              label: 'Add Note',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          Add_Note_Screen_Insides_Folder(widget.folderId)),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.direction == ScrollDirection.forward) {
              setState(() {
                show = true;
              });
            }
            if (notification.direction == ScrollDirection.reverse) {
              setState(() {
                show = false;
              });
            }
            return true;
          },
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Stream_note_insides_folder(widget.folderId, false),
              // folder_note(),
              Text(
                'isDone',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Stream_note_insides_folder(widget.folderId, true),
            ],
          ),
        ),
      ),
    );
  }
}
