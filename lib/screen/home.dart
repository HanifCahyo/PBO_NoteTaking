// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:test_drive/auth/main_page.dart';
import 'package:test_drive/const/colors.dart';
import 'package:test_drive/data/auth_data.dart';
import 'package:test_drive/main.dart';
import 'package:test_drive/screen/add_folder.dart';
import 'package:test_drive/screen/add_note_screen.dart';
import 'package:test_drive/widgets/folder_notes.dart';
import 'package:test_drive/widgets/stream_notes.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  bool show = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      appBar: AppBar(
        title: Text('Home Screen'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await AuthenticationRemote().logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyApp()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: show,
        child: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          backgroundColor: custom_green,
          children: [
            SpeedDialChild(
              child: Icon(Icons.create_new_folder),
              label: 'Add Folder',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Add_Folder_Screen()),
                );
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.note_add),
              label: 'Add Note',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Add_Note_Screen()),
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
              Stream_note(false),
              folder_note(),
              Text(
                'isDone',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Stream_note(true),
            ],
          ),
        ),
      ),
    );
  }
}
