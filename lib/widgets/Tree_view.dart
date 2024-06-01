import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:test_drive/widgets/folder_notes.dart';
import 'package:test_drive/widgets/stream_notes.dart';

class FolderTreeView extends StatelessWidget {
  final TreeController treeController;
  final Function(Widget) onNodeSelected;

  FolderTreeView({Key? key, required this.onNodeSelected})
      : treeController = TreeController(allNodesExpanded: false),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TreeView(
      treeController: treeController,
      nodes: _buildNodes(context),
    );
  }

  List<TreeNode> _buildNodes(BuildContext context) {
    return [
      TreeNode(
        content: GestureDetector(
          onTap: () => onNodeSelected(Stream_note(
            false,
          )),
          child: Text('Folder 1'),
        ),
        children: [
          TreeNode(
            content: GestureDetector(
              onTap: () => onNodeSelected(Stream_note(
                false,
              )),
              child: Text('Subfolder 1.1'),
            ),
          ),
          TreeNode(
            content: GestureDetector(
              onTap: () => onNodeSelected(Stream_note(
                false,
              )),
              child: Text('Subfolder 1.2'),
            ),
            children: [
              TreeNode(
                content: GestureDetector(
                  onTap: () => onNodeSelected(Stream_note(
                    false,
                  )),
                  child: Text('Subfolder 1.2.1'),
                ),
              ),
            ],
          ),
        ],
      ),
      TreeNode(
        content: GestureDetector(
          onTap: () => onNodeSelected(Stream_note(
            false,
          )),
          child: Text('Folder 2'),
        ),
        children: [
          TreeNode(
            content: GestureDetector(
              onTap: () => onNodeSelected(Stream_note(
                false,
              )),
              child: Text('Subfolder 2.1'),
            ),
          ),
          TreeNode(
            content: GestureDetector(
              onTap: () => onNodeSelected(Stream_note(
                false,
              )),
              child: Text('Subfolder 2.2'),
            ),
          ),
        ],
      ),
    ];
  }
}
