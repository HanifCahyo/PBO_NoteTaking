// ignore_for_file: use_super_parameters, prefer_const_constructors, unnecessary_to_list_in_spreads

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:test_drive/data/firestore.dart';
import 'package:test_drive/screen/hello_world.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:test_drive/widgets/details_widget.dart';

class FolderTreeView extends StatelessWidget {
  final TreeController treeController;
  final Function(Widget) onNodeSelected;

  FolderTreeView({Key? key, required this.onNodeSelected})
      : treeController = TreeController(allNodesExpanded: false),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
            stream: Firestore_Datasource().streamRootNotes(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final notes = snapshot.data!.docs
                  .map((doc) => {
                        'title': doc['title'],
                        'subtitle': doc['subtitle'],
                        'id': doc.id
                      })
                  .toList();

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      onNodeSelected(NoteDetailWidget(
                        title: notes[index]['title'],
                        subtitle: notes[index]['subtitle'],
                      ));
                    },
                    onLongPress: () {
                      _showEditOrDeleteRootNoteDialog(
                          context,
                          notes[index]['id'],
                          notes[index]['title'],
                          notes[index]['subtitle']);
                    },
                    child: ListTile(
                      leading: Icon(Icons.note,
                          color: Colors.blue), // Icon for notes
                      title: Text(notes[index]['title']),
                    ),
                  );
                },
              );
            },
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore_Datasource().streamFolder(null), // Root folders
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs;

              return TreeView(
                treeController: treeController,
                nodes: _buildNodes(context, docs),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.note_add),
                  onPressed: () => _showAddRootNotesDialog(context),
                ),
                IconButton(
                  icon: Icon(Icons.create_new_folder),
                  onPressed: () => _showAddRootFolderDialog(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<TreeNode> _buildNodes(BuildContext context, List<DocumentSnapshot> docs,
      [String? parentId]) {
    final folders = docs.where((doc) => doc['parentId'] == parentId).toList();

    return folders.map((folderDoc) {
      final folderId = folderDoc.id;
      final folderName = folderDoc['folderName'];
      return TreeNode(
        content: GestureDetector(
          onTap: () => onNodeSelected(HelloWorld()),
          onLongPress: () => _showDeleteFolderDialog(context, folderId),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.folder, color: Colors.yellow), // Icon for folders
              SizedBox(width: 8),
              Flexible(
                child: Text(folderName),
              ),
              IconButton(
                icon: Icon(Icons.note_add),
                onPressed: () => _showAddNoteDialog(context, folderId),
              ),
              IconButton(
                icon: Icon(Icons.create_new_folder),
                onPressed: () => _showAddSubFolderDialog(context, folderId),
              ),
            ],
          ),
        ),
        children: [
          ..._buildNodes(context, docs, folderId),
          TreeNode(
            content: StreamBuilder<QuerySnapshot>(
              stream: Firestore_Datasource().streamNotes(folderId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                final notes = snapshot.data!.docs
                    .map((doc) => {
                          'title': doc['title'],
                          'subtitle': doc['subtitle'],
                          'id': doc.id
                        })
                    .toList();
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...notes.map((note) {
                      return GestureDetector(
                        onTap: () {
                          onNodeSelected(NoteDetailWidget(
                            title: note['title'],
                            subtitle: note['subtitle'],
                          ));
                        },
                        onLongPress: () {
                          _showEditOrDeleteNoteDialog(context, note['id'],
                              folderId, note['title'], note['subtitle']);
                        },
                        child: Row(
                          children: [
                            Icon(Icons.note,
                                color: Colors.blue), // Icon for notes
                            SizedBox(width: 8),
                            Text(note['title']),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ],
      );
    }).toList();
  }

  List<TreeNode> _buildSubNodes(String folderId, List<DocumentSnapshot> docs) {
    return [
      TreeNode(
        content: StreamBuilder<QuerySnapshot>(
          stream: Firestore_Datasource().streamNotes(folderId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            final notes =
                snapshot.data!.docs.map((doc) => doc['title']).toList();
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...notes.map((note) {
                  return GestureDetector(
                    onTap: () {
                      onNodeSelected(HelloWorld());
                    },
                    onLongPress: () {
                      _deleteNote(
                          context,
                          snapshot.data!.docs[notes.indexOf(note)].id,
                          folderId);
                    },
                    child: Text(note),
                  );
                }).toList(),
              ],
            );
          },
        ),
      ),
    ];
  }

  void _showAddRootFolderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String folderName = '';
        return AlertDialog(
          title: Text('Add New Folder'),
          content: TextField(
            onChanged: (value) {
              folderName = value;
            },
            decoration: InputDecoration(hintText: "Folder Name"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                Firestore_Datasource().AddFolder(folderName);
                Navigator.of(context).pop();
              },
            ),
            // Tambahkan tombol untuk menghapus folder
          ],
        );
      },
    );
  }

  void _showAddRootNotesDialog(BuildContext context) {
    final quill.QuillController subtitle = quill.QuillController.basic();
    String noteTitle = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    noteTitle = value;
                  },
                  decoration: InputDecoration(hintText: "Note Title"),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 200, // Adjust the height as per your needs
                  child: Column(
                    children: [
                      quill.QuillToolbar.simple(
                        configurations: quill.QuillSimpleToolbarConfigurations(
                          controller: subtitle,
                          sharedConfigurations:
                              const quill.QuillSharedConfigurations(
                            locale: Locale('en'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: quill.QuillEditor.basic(
                          configurations: quill.QuillEditorConfigurations(
                            controller: subtitle,
                            // readOnly: false, // Make the editor editable
                            autoFocus: false,
                            expands: false,
                            // focusNode: FocusNode(),
                            // scrollController: ScrollController(),
                            padding: EdgeInsets.all(10),
                            scrollable: true,
                            showCursor: true,
                            // readOnly: false,
                            sharedConfigurations:
                                const quill.QuillSharedConfigurations(
                                    // locale: Locale('de'),
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                String subtitleContent =
                    await jsonEncode(subtitle.document.toDelta());
                if (noteTitle.isNotEmpty && subtitleContent.isNotEmpty) {
                  Firestore_Datasource()
                      .AddRootNote(noteTitle, subtitleContent);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddNoteDialog(BuildContext context, String folderId) {
    final quill.QuillController subtitle = quill.QuillController.basic();
    String noteTitle = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    noteTitle = value;
                  },
                  decoration: InputDecoration(hintText: "Note Title"),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 200, // Adjust the height as per your needs
                  child: Column(
                    children: [
                      quill.QuillToolbar.simple(
                        configurations: quill.QuillSimpleToolbarConfigurations(
                          controller: subtitle,
                          sharedConfigurations:
                              const quill.QuillSharedConfigurations(
                            locale: Locale('en'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: quill.QuillEditor.basic(
                          configurations: quill.QuillEditorConfigurations(
                            controller: subtitle,
                            // readOnly: false, // Make the editor editable
                            autoFocus: false,
                            expands: false,
                            // focusNode: FocusNode(),
                            // scrollController: ScrollController(),
                            padding: EdgeInsets.all(10),
                            scrollable: true,
                            showCursor: true,
                            // readOnly: false,
                            sharedConfigurations:
                                const quill.QuillSharedConfigurations(
                                    // locale: Locale('de'),
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () async {
                String subtitleContent =
                    await jsonEncode(subtitle.document.toDelta());
                if (noteTitle.isNotEmpty && subtitleContent.isNotEmpty) {
                  Firestore_Datasource()
                      .AddNote(noteTitle, folderId, subtitleContent);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteNote(BuildContext context, String Id, String folderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Firestore_Datasource().deleteNote(Id, folderId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

// Fungsi untuk menghapus folder
  void _deleteFolder(BuildContext context, String folderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Folder'),
          content: Text('Are you sure you want to delete this folder?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Firestore_Datasource().deleteFolder(folderId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddSubFolderDialog(BuildContext context, String parentId) {
    showDialog(
      context: context,
      builder: (context) {
        String folderName = '';
        return AlertDialog(
          title: Text('Add New Sub Folder'),
          content: TextField(
            onChanged: (value) {
              folderName = value;
            },
            decoration: InputDecoration(hintText: "Folder Name"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                Firestore_Datasource().AddFolder(folderName, parentId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditOrDeleteNoteDialog(BuildContext context, String noteId,
      String folderId, String currentTitle, String currentSubtitle) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit or Delete Note'),
          content: Text('What do you want to do with this note?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Edit'),
              onPressed: () {
                Navigator.of(context).pop();
                _showEditNoteDialog(
                    context, noteId, folderId, currentTitle, currentSubtitle);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Firestore_Datasource().deleteNote(noteId, folderId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditNoteDialog(BuildContext context, String noteId, String folderId,
      String currentTitle, String currentSubtitle) {
    final quill.QuillController subtitleController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(currentSubtitle)),
      selection: const TextSelection.collapsed(offset: 0),
    );
    String noteTitle = currentTitle;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    noteTitle = value;
                  },
                  controller: TextEditingController(text: currentTitle),
                  decoration: InputDecoration(hintText: "Note Title"),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 200, // Adjust the height as per your needs
                  child: Column(
                    children: [
                      quill.QuillToolbar.simple(
                        configurations: quill.QuillSimpleToolbarConfigurations(
                          controller: subtitleController,
                          sharedConfigurations:
                              const quill.QuillSharedConfigurations(
                            locale: Locale('en'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: quill.QuillEditor.basic(
                          configurations: quill.QuillEditorConfigurations(
                            controller: subtitleController,
                            autoFocus: false,
                            expands: false,
                            padding: EdgeInsets.all(10),
                            scrollable: true,
                            showCursor: true,
                            sharedConfigurations:
                                const quill.QuillSharedConfigurations(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                String updatedSubtitle =
                    await jsonEncode(subtitleController.document.toDelta());
                if (noteTitle.isNotEmpty && updatedSubtitle.isNotEmpty) {
                  Firestore_Datasource()
                      .updateNote(noteId, noteTitle, folderId, updatedSubtitle);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditOrDeleteRootNoteDialog(BuildContext context, String noteId,
      String currentTitle, String currentSubtitle) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit or Delete Note'),
          content: Text('What do you want to do with this note?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Edit'),
              onPressed: () {
                Navigator.of(context).pop();
                _showEditRootNoteDialog(
                    context, noteId, currentTitle, currentSubtitle);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Firestore_Datasource().deleteRootNote(noteId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditRootNoteDialog(BuildContext context, String noteId,
      String currentTitle, String currentSubtitle) {
    final quill.QuillController subtitleController = quill.QuillController(
      document: quill.Document.fromJson(jsonDecode(currentSubtitle)),
      selection: const TextSelection.collapsed(offset: 0),
    );
    String noteTitle = currentTitle;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    noteTitle = value;
                  },
                  controller: TextEditingController(text: currentTitle),
                  decoration: InputDecoration(hintText: "Note Title"),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 200, // Adjust the height as per your needs
                  child: Column(
                    children: [
                      quill.QuillToolbar.simple(
                        configurations: quill.QuillSimpleToolbarConfigurations(
                          controller: subtitleController,
                          sharedConfigurations:
                              const quill.QuillSharedConfigurations(
                            locale: Locale('en'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: quill.QuillEditor.basic(
                          configurations: quill.QuillEditorConfigurations(
                            controller: subtitleController,
                            autoFocus: false,
                            expands: false,
                            padding: EdgeInsets.all(10),
                            scrollable: true,
                            showCursor: true,
                            sharedConfigurations:
                                const quill.QuillSharedConfigurations(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                String updatedSubtitle =
                    await jsonEncode(subtitleController.document.toDelta());
                if (noteTitle.isNotEmpty && updatedSubtitle.isNotEmpty) {
                  Firestore_Datasource()
                      .updateRootNote(noteId, noteTitle, updatedSubtitle);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteFolderDialog(BuildContext context, String folderId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Folder'),
          content: Text(
              'Are you sure you want to delete this folder? All notes and subfolders inside will also be deleted.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Firestore_Datasource().deleteFolder(folderId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
