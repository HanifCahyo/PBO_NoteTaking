// ignore_for_file: camel_case_types, non_constant_identifier_names, prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:test_drive/const/colors.dart';
import 'package:test_drive/data/firestore.dart';

import 'package:html_editor_enhanced/html_editor.dart';

class Add_Note_Screen extends StatefulWidget {
  const Add_Note_Screen({super.key});

  @override
  State<Add_Note_Screen> createState() => _Add_Note_ScreenState();
}

class _Add_Note_ScreenState extends State<Add_Note_Screen> {
  final title = TextEditingController();
  // final subtitle = TextEditingController();
  final HtmlEditorController subtitle = HtmlEditorController();

  final FocusNode _focusNode1 = FocusNode();
  // final FocusNode _focusNode2 = FocusNode();

  int indexx = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColors,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            title_widgets(),
            const SizedBox(height: 20),
            subtitleWidget(),
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
            String htmlContent = await subtitle.getText();
            Firestore_Datasource().AddNote(htmlContent, title.text, indexx);
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

  Widget subtitleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Subtitle',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: HtmlEditor(
              controller: subtitle,
              htmlEditorOptions: HtmlEditorOptions(
                hint: "Enter subtitle",
              ),
              otherOptions: OtherOptions(
                height: 200,
              ),
            ),
          ),
        ],
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
