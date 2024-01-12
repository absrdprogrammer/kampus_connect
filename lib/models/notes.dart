class Note {
  int id;
  String title;
  String content;
  DateTime modifiedTime;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.modifiedTime,
  });
}


List<Note> sampleNotes = [
  // Note(
  //   id: 0,
  //   title: 'Like and Subscribe',
  //   content:
  //       'A FREE way to support the channel is to give us a LIKE . It does not cost you but means a lot to us.\nIf you are new here please Subscribe',
  //   modifiedTime: DateTime(2022,1,1,34,5),
  // ),
];