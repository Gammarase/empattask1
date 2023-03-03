import 'package:flutter/material.dart';

mixin Colorize {
  var colorMap = {
    'grey': Colors.grey,
    'red': Colors.red,
    'yellow': Colors.amberAccent,
    'blue': Colors.blue,
    'purple': Colors.deepPurple,
    'green': Colors.green,
    'pink': Colors.pink,
    'orange': Colors.orange,
  };

  Color? noteColor;

  void initColor([String strColor = 'grey']) {
    noteColor ??= colorMap[strColor] ?? Colors.grey;
  }

  void setColor([String strColor = 'grey']) {
    noteColor = colorMap[strColor] ?? Colors.grey;
  }
}

class Note with Colorize {
  String title;
  String content;
  DateTime _time = DateTime.now();

  String get time => _time.toString();

  set time(String timestr) =>
      _time = DateTime.tryParse(timestr) ?? DateTime.now();

  Note({
    required this.title,
    required this.content,
  })  : assert(title != ''),
        assert(content != '') {
    initColor();
  }

  factory Note.add(String title, String content, List<Note> list,
      [String temptime = '', String tempColor = '']) {
    for (var note in list) {
      if (note.title == title) {
        throw Exception('Note must be unique');
      }
    }
    return temptime == '' && tempColor == ''
        ? Note(title: title, content: content)
        : Note.customNote(title, content, temptime, tempColor);
  }

  Note.customNote(this.title, this.content, String temptime, String tempColor) {
    initColor(tempColor);
    time = temptime;
  }
}

Function changer(Note note) {
  return (String title, String content, String date, String color) {
    note.title = title;
    note.content = content;
    date != '' ? note.time = date : null;
    color != '' ? note.setColor(color) : null;
  };
}
