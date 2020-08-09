import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class TextFile extends StatefulWidget {
  @override
  _TextFileState createState() => _TextFileState();
}

class _TextFileState extends State<TextFile> {
  String data = '';
  getFileData() async {
    String responseText;
    responseText = await rootBundle.loadString('files/cart.txt');
    setState(() {
      data = responseText;
    });
  }

  @override
  void initState() {
    getFileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Extract'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(data),
          ),
        ),
      ),
    );
  }
}
