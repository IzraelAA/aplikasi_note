import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:apiapk/NoteList.dart';
void main() {
  runApp(notes());
}

class notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    return MaterialApp(
      title: "Note App",color: Colors.blue,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple

        
      ),
      home: NoteList(),
     );
    
  }
}