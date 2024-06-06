import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class NoteDetailWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  NoteDetailWidget({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final quill.QuillController _controller = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(subtitle)),
      selection: const TextSelection.collapsed(offset: 0),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: quill.QuillEditor.basic(
          configurations: quill.QuillEditorConfigurations(
            controller: _controller,
            // readOnly: false, // Make the editor editable
            autoFocus: false,
            expands: false,
            // focusNode: FocusNode(),
            // scrollController: ScrollController(),
            padding: EdgeInsets.all(10),
            scrollable: true,
            showCursor: true,
            // readOnly: false,
            sharedConfigurations: const quill.QuillSharedConfigurations(
                // locale: Locale('de'),
                ),
          ),
        ),
      ),
    );
  }
}
