class Note {
  String id;
  String subtitle;
  String title;
  String time;
  int image;
  bool isDone;
  Note(this.id, this.subtitle, this.time, this.image, this.title, this.isDone);
}

class Folder {
  String folderId;
  String folderName;
  Folder(this.folderId, this.folderName);
}

class NoteInsideFolder {
  String id;
  String folderId;
  String subtitle;
  String title;
  String time;
  int image;
  bool isDone;
  NoteInsideFolder(this.id, this.folderId, this.subtitle, this.time, this.image,
      this.title, this.isDone);
}
