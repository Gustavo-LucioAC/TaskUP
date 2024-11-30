import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskup/model/notes_model.dart';
import 'package:taskup/screens/add_edit_screen.dart';
import 'package:taskup/screens/view_note_screen.dart';
import 'package:taskup/service/database_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Note> _notes = [];
  final List<Color> _noteColors = [
    Colors.amber,
    Color(0xFF50C878),
    Colors.redAccent,
    Colors.blueAccent,
    Colors.indigo,
    Colors.purpleAccent,
    Colors.pinkAccent,
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final notes = await _databaseHelper.getNotes();
    setState(() {
      _notes = notes;
    });
  }

  String _formatDateTime(String dateTime) {
    final DateTime dt = DateTime.parse(dateTime);
    final now = DateTime.now();

    if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
      return 'Today, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(0, '0')}';
    }

    return '${dt.day}/${dt.month}/${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.hour.toString().padLeft(0, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: Text(
          "My notes",
        ),
      ),
      body: GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16),
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            final note = _notes[index];
            final color = Color(int.parse(note.color));

            return GestureDetector(
              onTap: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewNoteScreen(note: note),
                    ));
                _loadNotes();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text(
                      note.content,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Spacer(),
                    Text(
                      _formatDateTime(note.dateTime),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddEditNoteScreen(),
              ));
          _loadNotes();
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 8, 4, 86),
        foregroundColor: Colors.white,
      ),
    );
  }
}
