import 'package:flutter/material.dart';
import 'package:apiapk/DbHelper.dart';
import 'package:intl/intl.dart';
import 'package:apiapk/Notedata.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;

  NoteDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  
  Note note;
  DbHelper helper = DbHelper();
  List<Note> noteList;
  int count = 0;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionControler = TextEditingController();

  static var _priorities = ['High', 'Low'];

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle title = Theme.of(context).textTheme.subhead;
    titleController.text = note.title;
    descriptionControler.text = note.description;
 

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
    
     child: Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                  items: _priorities.map((String dropDwonStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDwonStringItem,
                      child: Text(dropDwonStringItem),
                    );
                  }).toList(),
                  style: title,
                  value: getPriorityAsString(note.priority),
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      debugPrint('user selected $valueSelectedByUser');
                      updatePriorityAsInt(valueSelectedByUser);
                    });
                  }),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: titleController,
                style: title,
                onChanged: (value) {
                  debugPrint('Changed');
                  updateTitle();
                },
                decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: title,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
//Third Element
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextField(
                controller: descriptionControler,
                style: title,
                onChanged: (value) {
                  debugPrint('Changed');
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: title,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Simpan',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("SAVE");
                          _save();
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 5.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      color: Theme.of(context).primaryColorLight,
                      child: Text(
                        'Hapus',
                        textScaleFactor: 1.5,
                      ),
                      onPressed: () {
                        setState(() {
                          debugPrint("Delete");
                          _delete();
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }

  void updatePriorityAsint(String value) {
    switch (value) {
      case 'Hight':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int valeu) {
    String priority;
    switch (valeu) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void _save() async {
    moveToLastScreen();
    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {result = await helper.insertNote(note);
    }
    if (result != 0) {
      _showAlert ('Status','Sukses');
    }else{
      _showAlert ('Status','Gagal');
    }
  }
  void _showAlert(String title,String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) =>alertDialog
    );
  }
  void moveToLastScreen(){
    Navigator.pop(context,true);
  }

  void _delete()async{
    moveToLastScreen();
    if (note.id==null) {
      _showAlert('Status', 'delete');
      return;
    }
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlert('Status', 'Deleted');
    }else{
      _showAlert('Status', 'Failed Deleted');
    }
  }
  void updatePriorityAsInt(String value) {
    switch  (value){
      case 'High':
      note.priority =1;
      break;
      case 'Low':
      note.priority = 2;
      break;
    }
  }
  void updateTitle(){
    note.title = titleController.text;
  }
  void updateDescription(){
    note.description = descriptionControler.text;
  }
}
