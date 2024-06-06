// ignore_for_file: prefer_const_constructors, camel_case_types, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:test_drive/auth/main_page.dart';
import 'package:test_drive/const/colors.dart';
import 'package:test_drive/data/auth_data.dart';
import 'package:test_drive/screen/hello_world.dart';
import 'package:test_drive/widgets/tree_view.dart';

class Home_Screen extends StatefulWidget {
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  bool show = true;
  Widget selectedContent = HelloWorld(); // Default content

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
                MaterialPageRoute(builder: (context) => Main_Page()),
              );
            },
          ),
        ],
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
          child: Row(
            children: [
              // Sidebar TreeView
              Container(
                width: 300, // Set a fixed width for the sidebar
                color: Colors.grey.shade200,

                child: FolderTreeView(
                  onNodeSelected: (Widget content) {
                    setState(() {
                      selectedContent = content;
                    });
                  },
                ),
              ),
              // Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: selectedContent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
