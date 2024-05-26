// ignore_for_file: camel_case_types, must_be_immutable, prefer_final_fields, prefer_const_constructors, duplicate_ignore, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:test_drive/const/colors.dart';
import 'package:test_drive/model/notes_model.dart';
import 'package:test_drive/screen/folder_list.dart';

class Folder_Widget extends StatefulWidget {
  Folder _folder;
  Folder_Widget(this._folder, {super.key});

  @override
  State<Folder_Widget> createState() => _Folder_WidgetState();
}

class _Folder_WidgetState extends State<Folder_Widget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              // Image or Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: customGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons.folder,
                  color: customGreen,
                  size: 30,
                ),
              ),
              const SizedBox(width: 20),

              // Title and Subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget._folder.folderName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        // Icon(
                        //   Icons.more_vert,
                        //   color: Colors.grey.shade600,
                        // ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Spacer(),
                    open_folder(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Open Folder Button
  Widget open_folder() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) =>
                        Folder_Screen_List(widget._folder.folderId)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: customGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            icon: Icon(Icons.folder_open, size: 20),
            label: Text(
              'Open',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
