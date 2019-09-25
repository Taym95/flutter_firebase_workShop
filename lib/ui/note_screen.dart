import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/note.dart';
import 'package:flutter_firebase/service/firebase_firestore_service.dart';

class NoteScreen extends StatefulWidget {
  final Note note;
  const NoteScreen(this.note);

  @override
  State<StatefulWidget> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  FirebaseFirestoreService db = FirebaseFirestoreService();

  TextEditingController _titleController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(text: widget.note.title);
    _descriptionController =
        TextEditingController(text: widget.note.description);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Note')),
        body: Container(
          margin: const EdgeInsets.all(15.0),
          alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              const Padding(padding: EdgeInsets.all(5.0)),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              const Padding(padding: EdgeInsets.all(5.0)),
              RaisedButton(
                child: (widget.note.id != null)
                    ? const Text('Update')
                    : const Text('Add'),
                onPressed: () {
                  if (widget.note.id != null) {
                    db
                        .updateNote(Note(widget.note.id, _titleController.text,
                            _descriptionController.text))
                        .then((_) {
                      Navigator.pop(context);
                    });
                  } else {
                    db
                        .createNote(
                            _titleController.text, _descriptionController.text)
                        .then((_) {
                      Navigator.pop(context);
                    });
                  }
                },
              ),
            ],
          ),
        ),
      );
}
