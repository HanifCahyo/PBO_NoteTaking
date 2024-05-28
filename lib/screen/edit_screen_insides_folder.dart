// ignore_for_file: camel_case_types, non_constant_identifier_names, annotate_overrides, prefer_const_constructors, sized_box_for_whitespace, duplicate_ignore, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:test_drive/const/colors.dart';
import 'package:test_drive/data/firestore.dart';
import 'package:test_drive/model/notes_model.dart';

import 'package:html_editor_enhanced/html_editor.dart';

class Edit_Screen_Insides_Folder extends StatefulWidget {
  final NoteInsideFolder note;
  const Edit_Screen_Insides_Folder(this.note, {super.key});

  @override
  State<Edit_Screen_Insides_Folder> createState() =>
      _Edit_Screen_Insides_FolderState();
}

class _Edit_Screen_Insides_FolderState
    extends State<Edit_Screen_Insides_Folder> {
  TextEditingController? title;
  // TextEditingController? subtitle;
  HtmlEditorController subtitleController = HtmlEditorController();

  final FocusNode _focusNode1 = FocusNode();
  // final FocusNode _focusNode2 = FocusNode();

  int indexx = 0;
  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.note.title);
    // subtitle = TextEditingController(text: widget.note.subtitle);
    subtitleController.setText(widget.note.subtitle);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title_widgets(),
            const SizedBox(height: 20),
            subtitle_widgets(),
            const SizedBox(height: 20),
            imagess(),
            const SizedBox(height: 20),
            Button()
          ],
        ),
      ),
    );
  }

  Widget Button() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: custom_green,
            minimumSize: Size(170, 48),
          ),
          onPressed: () async {
            String subtitleHtml = await subtitleController.getText();
            Firestore_Datasource().Update_Note_Inside_Folder(
                widget.note.id, indexx, title!.text, subtitleHtml);
            Navigator.pop(context);
          },
          child: Text('add task'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: Size(170, 48),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }

  Container imagess() {
    return Container(
      height: 180,
      child: ListView.builder(
        itemCount: 6,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // ignore: sized_box_for_whitespace
          return GestureDetector(
            onTap: () {
              setState(() {
                indexx = index;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 2,
                    color: indexx == index ? custom_green : Colors.grey,
                  )),
              width: 140,
              margin: EdgeInsets.all(8),
              child: Column(
                children: [
                  Image.asset('images/$index.png'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget subtitle_widgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: HtmlEditor(
          controller: subtitleController,
          htmlEditorOptions: HtmlEditorOptions(
            hint: "Enter your subtitle here...",
            initialText: widget.note.subtitle,
          ),
          otherOptions: OtherOptions(
            height: 200,
          ),
        ),
      ),
    );
  }

  Widget title_widgets() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          controller: title,
          focusNode: _focusNode1,
          style: const TextStyle(fontSize: 18, color: Colors.black),
          decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              hintText: "title",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xffc5c5c5),
                  width: 2.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: custom_green,
                  width: 2.0,
                ),
              )),
        ),
      ),
    );
  }
}
