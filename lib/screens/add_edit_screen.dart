import 'package:flutter/material.dart';
import 'package:taskup/model/notes_model.dart';
import 'package:taskup/screens/home_screen.dart';
import 'package:taskup/service/database_helper.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  const AddEditNoteScreen({this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Color _selectedColor = Colors.amber;
  final List<Color> _colors = [
    Colors.amber,
    Color.fromARGB(255, 5, 133, 48),
    const Color.fromARGB(255, 0, 97, 132),
    const Color.fromARGB(255, 0, 94, 255),
    Colors.indigo,
    const Color.fromARGB(255, 100, 3, 117),
    const Color.fromARGB(255, 151, 6, 55),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(widget.note == null ? 'Add Note' : "Edit Note"),
      ), //appBar
      body: Form(
        key: _formKey,
        child: Column(children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Title",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ), //OUTLINEINPUTBORDE
                ), // INPUTDECORATION
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a tittle";
                  }
                  return null;
                },
              ), // TextFoRmField
              SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: "Content",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ), //OUTLINEINPUTBORDE
                ), // INPUTDECORATION
                maxLines: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a Content";
                  }
                  return null;
                },
              ), // TextFoRmField
              Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _colors.map(
                      (color) {
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = color),
                          child: Container(
                            height: 40,
                            width: 40,
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor == color
                                    ? Colors.black45
                                    : Colors.transparent,
                                width: 2,
                              ), //Borderall
                            ), //boxDecoration
                          ), //Container
                        ); // GestureDetector
                      },
                    ).toList(),
                  ), //Row
                ), //SingleChildScrollVieww
              ), //padding
              InkWell(
                onTap: () {
                  _saveNote();
                  Navigator.pop(context);
                },
                child: Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Color(0xFF50C878),
                        borderRadius:
                            BorderRadius.circular(10)), //BoxDecoration
                    child: Center(
                      child: Text(
                        "Save Note",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ), //textStyle
                      ), // Text
                    ) //center
                    ), //Container
              ), //Inwell
            ]), //column
          ), //Padding
        ]), //column
      ), //Form
    ); //Scaffold
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate()) {
      final note = Note(
        id: widget.note?.id,
        title: _titleController.text,
        content: _contentController.text,
        color: _selectedColor.value.toString(),
        dateTime: DateTime.now().toString(),
      ); //note
      if (widget.note == null) {
        await _databaseHelper.insertNote(note);
      } else {
        await _databaseHelper.updateNote(note);
      }
    }
  }
}
