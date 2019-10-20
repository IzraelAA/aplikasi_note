import 'package:flutter/material.dart';
import 'package:apiapk/DbHelper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:apiapk/Notedata.dart';
import 'package:apiapk/NoteDetail.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DbHelper databaseHp = DbHelper();
  List<Note> noteList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = List<Note>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Note App'),
        backgroundColor: Colors.blue,
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint("cliked");
          navigationdetail(Note('', '', 2), 'New Note');
        },
        tooltip: 'new Note',
        child: Icon(Icons.playlist_add,
      color: Colors.blue,)
      ),
    );
  }

  ListView getNoteListView() {
    Color b = Colors.white;
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int postition) {
        return Card(
          color: Colors.blue,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  getPriorityColor(this.noteList[postition].priority),
              child: getPriorityIcon(this.noteList[postition].priority),
            ),
            title: Text(
              this.noteList[postition].title, style: titleStyle,
            ),
            subtitle: Text(this.noteList[postition].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.white,),
              onTap: (){
                _delete(context, noteList[postition]);
              },
          ),
            onTap: () {
              debugPrint("ListTile tapped");
          navigationdetail(this.noteList[postition], 'Edit Note');
            },
          ),
          );
      },
    );
  } 

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.yellow;

      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;

      default:
        return Icon(Icons.keyboard_arrow_right);
    }
  }

  void navigationdetail(Note note, String title) async {
    bool result =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));

    if (result == true) {
      updateListView();
    }
  }
  void _delete(BuildContext context, Note note) async{
    int result = await databaseHp.deleteNote(note.id);
    if(result != 0){
      _showSnackBar(context, "Hapus");
      updateListView();
    }
  }
  void _showSnackBar(BuildContext context,String massage){
     final snackbar = SnackBar(content: Text(massage),);
     Scaffold.of(context).showSnackBar(snackbar);
  }

  void updateListView() {
    final Future<Database> dbFuture = DbHelper().initalizeDatabase();
    dbFuture.then((database) {
      Future<List<Note>> noteListFuture = DbHelper().getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
