import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:translator/translator.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:path/path.dart';

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
    exportPDF();
    super.initState();
  }

  exportPDF() {}

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
        actions: [
          IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                exportPDF();
              })
        ],
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
