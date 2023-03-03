import 'package:flutter/material.dart';

import 'clasess.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Note app made by Kryvytskiy Bohdan'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Note> noteList = [];

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).

          children: <Widget>[
            const Text(
              'Your Notes:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: noteList.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ListTile(
                    onLongPress: () => setState(() => noteList.removeAt(index)),
                    onTap: () => showDialog(
                      context: context,
                      builder: (context) => DialogWindow(
                        title: noteList[index].title,
                        content: noteList[index].content,
                        lable: 'Edit your note',
                        onSubmit: (String title, String content, String date,
                            String color) {
                          Function notechanger = changer(noteList[index]);
                          notechanger(title, content, date, color);
                          setState(() {});
                        },
                      ),
                    ),
                    tileColor: noteList[index].noteColor,
                    leading: Text(
                      noteList[index].title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    title: Column(
                      children: [
                        Text(noteList[index].content),
                        Text("date: ${noteList[index].time}"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => DialogWindow(
            lable: 'Add your note',
            onSubmit:
                (String title, String content, String date, String color) {
              try {
                noteList.add(
                  Note.add(
                    title,
                    content,
                    noteList,
                    date,
                    color.toLowerCase(),
                  ),
                );
              } catch (e) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Error'),
                    content: Text(e.toString()),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Close'),
                      )
                    ],
                  ),
                );
              }
              setState(() {});
            },
          ),
        ),
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DialogWindow extends StatefulWidget {
  final String lable;
  final String title;
  final String content;
  final Function onSubmit;

  const DialogWindow({
    Key? key,
    this.lable = '',
    this.title = '',
    this.content = '',
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<DialogWindow> createState() => _DialogWindowState();
}

class _DialogWindowState extends State<DialogWindow> {
  late TextEditingController titleController;
  late TextEditingController contentController;
  late TextEditingController dateController;
  late TextEditingController colorController;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.title);
    contentController = TextEditingController(text: widget.content);
    dateController = TextEditingController();
    colorController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.lable),
      content: Column(
        children: [
          AppTextField(
            controller: titleController,
            label: 'Title',
          ),
          AppTextField(
            controller: contentController,
            label: 'Content',
          ),
          AppTextField(
            controller: dateController,
            label: 'Date',
          ),
          AppTextField(
            controller: colorController,
            label: 'Color',
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            widget.onSubmit(titleController.text, contentController.text,
                dateController.text, colorController.text);
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    dateController.dispose();
    colorController.dispose();
    super.dispose();
  }
}

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const AppTextField(
      {super.key, required this.controller, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
