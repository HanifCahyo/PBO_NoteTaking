import 'package:flutter/material.dart';
import 'package:test_drive/const/colors.dart';
import 'package:test_drive/model/notes_model.dart';
import 'package:test_drive/screen/edit_screen.dart';
import 'package:intl/intl.dart';

class Task_Widget extends StatefulWidget {
  Note _note;
  Task_Widget(this._note, {super.key});

  @override
  State<Task_Widget> createState() => _Task_WidgetState();
}

bool isDone = false;

class _Task_WidgetState extends State<Task_Widget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 7,
              spreadRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              //image
              Images(),
              const SizedBox(
                width: 25,
              ),
              //ttitle and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget._note.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Checkbox(
                            value: isDone,
                            onChanged: (value) {
                              setState(() {
                                isDone = !isDone;
                              });
                            })
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget._note.subtitle,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400),
                    ),
                    // ignore: prefer_const_constructors
                    Spacer(),
                    edit_time()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget edit_time() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 28,
            decoration: BoxDecoration(
              color: custom_green,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Image.asset(
                    'images/icon_time.png',
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    widget._note.time,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Edit_Screen(),
              ));
            },
            child: Container(
              width: 90,
              height: 28,
              decoration: BoxDecoration(
                color: Color(0xffe2f6f1),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: Row(
                  children: [
                    Image.asset(
                      'images/icon_edit.png',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'edit',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget Images() {
    return Container(
      height: 130,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("images/${widget._note.image}.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
