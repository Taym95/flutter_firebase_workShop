import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/service/firebase_firestore_service.dart';

import 'package:flutter_firebase/model/note.dart';
import 'package:flutter_firebase/ui/note_screen.dart';

class ListViewNote extends StatefulWidget {
  @override
  _ListViewNoteState createState() => _ListViewNoteState();
}

class _ListViewNoteState extends State<ListViewNote> {
  List<Note> items;
  FirebaseFirestoreService db = FirebaseFirestoreService();

  StreamSubscription<QuerySnapshot> noteSub;

  @override
  void initState() {
    super.initState();

    items = [];

    noteSub?.cancel();
    noteSub = db.getNoteList().listen((QuerySnapshot snapshot) {
      final notes = snapshot.documents
          .map((documentSnapshot) => Note.fromMap(documentSnapshot.data))
          .toList();

      setState(() {
        items = notes;
      });
    });
  }

  @override
  void dispose() {
    noteSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Firestore Demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firestore Demo'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) => Column(
                  children: <Widget>[
                    const Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${items[position].title}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      subtitle: Text(
                        '${items[position].description}',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      leading: Column(
                        children: <Widget>[
                          const Padding(padding: EdgeInsets.all(10.0)),
                          CircleAvatar(
                            backgroundColor: Colors.blueAccent,
                            radius: 15.0,
                            child: Text(
                              '${position + 1}',
                              style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => _deleteNote(
                                  context, items[position], position)),
                        ],
                      ),
                      onTap: () => _navigateToNote(context, items[position]),
                    ),
                  ],
                )),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _createNewNote(context),
        ),
      ),
    );

  Future<void> _deleteNote(
      BuildContext context, Note note, int position) async {
    await db.deleteNote(note.id);
    setState(() {
      items.removeAt(position);
    });
  }

  Future<void> _navigateToNote(BuildContext context, Note note) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(note)),
    );
  }

  Future<void> _createNewNote(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteScreen(Note(null, '', ''))),
    );
  }
}
