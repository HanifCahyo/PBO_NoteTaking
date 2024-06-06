class Note {
  String id;
  String subtitle;
  String title;
  String folderId;
  Note(this.id, this.subtitle, this.title, this.folderId);
}

class Folder {
  String folderId;
  String folderName;
  String parentId;
  Folder(this.folderId, this.folderName, this.parentId);
}
