import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:translator/translator.dart';
import 'dart:async';

class TextFile extends StatefulWidget {
  @override
  _TextFileState createState() => _TextFileState();
}

class _TextFileState extends State<TextFile> {
  String data = "";
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
    textTranslate();
    super.initState();
  }

  GoogleTranslator translator = GoogleTranslator();

  //translate function
  //String out;
  textTranslate() {
    translator.translate(data, to: "es").then((output) {
      setState(() {
        data = output.text;
      });
    });
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          textTranslate();
        },
        child: Icon(Icons.g_translate, color: Colors.black, size: 30),
      ),
    );
  }
}
