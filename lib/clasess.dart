class Note {
  String title;
  String content;
  DateTime _time = DateTime.now();
  String get time => _time.toString();
  set time(String timestr) =>
      _time = DateTime.tryParse(timestr) ?? DateTime.now();
  Note({required this.title, required this.content});
  Note.customTime(this.title, this.content, String temptime) {
    time = temptime;
  }
}
