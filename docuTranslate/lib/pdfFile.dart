import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:read_pdf_text/read_pdf_text.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class PdfFile extends StatefulWidget {
  @override
  _PdfFileState createState() => _PdfFileState();
}

class _PdfFileState extends State<PdfFile> {
  String _pdfText = '';
  List<String> _pdfList = [];
  int _pdfLength;

  bool _loading = false;
  bool _paginated = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: Center(
              child: _pdfLength == null
                  ? Text(
                      "No pages yet",
                      style: TextStyle(color: Colors.red),
                    )
                  : Text(
                      "Pages : $_pdfLength",
                    ),
            ),
          ),
        ],
        title: const Text('PDF Plugin example app'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  color: Colors.blueGrey,
                  onPressed: () {
                    // This example uses file picker to get the path
                    FilePicker.getFile(
                      allowedExtensions: ["pdf"],
                      type: FileType.custom,
                    ).then((File file) async {
                      if (file != null) {
                        setState(() {
                          _loading = true;
                        });
                        // Call the function to parse text from pdf
                        getPDFtext(file.path).then((pdfText) {
                          final text = pdfText.replaceAll("\n", " ");
                          setState(() {
                            _pdfText = text;
                            _paginated = false;
                            _loading = false;
                          });
                        });
                      }
                    });
                  },
                  child: Text("Get pdf text"),
                ),
              ),
              Expanded(
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: () {
                    // This example uses file picker to get the path
                    FilePicker.getFile(
                      allowedExtensions: ["pdf"],
                      type: FileType.custom,
                    ).then((File file) async {
                      if (file != null) {
                        setState(() {
                          _loading = true;
                        });
                        // Call the function to parse text from pdf
                        getPDFtextPaginated(file.path).then((pdfList) {
                          List<String> list = List<String>();
                          // Remove new lines
                          pdfList.forEach((element) {
                            list.add(element.replaceAll("\n", " "));
                          });

                          setState(() {
                            _pdfList = list;
                            _paginated = true;
                            _loading = false;
                          });
                        });
                      }
                    });
                  },
                  child: Text("Get pdf text paginated"),
                ),
              ),
              Expanded(
                child: FlatButton(
                  color: Colors.green,
                  onPressed: () {
                    // This example uses file picker to get the path
                    FilePicker.getFile(
                      allowedExtensions: ["pdf"],
                      type: FileType.custom,
                    ).then((File file) async {
                      if (file != null) {
                        setState(() {
                          _loading = true;
                        });
                        // Call the function to parse text from pdf
                        getPDFlength(file.path).then((length) {
                          setState(() {
                            _pdfLength = length;

                            // Reset variables
                            _pdfList = [];
                            _pdfText = " ";
                            _loading = false;
                          });
                        });
                      }
                    });
                  },
                  child: Text("Get document length (pages)"),
                ),
              ),
            ],
          ),
          _loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  // Check if returning text page by page or the whole document as one string
                  child: _paginated
                      ? ListView.builder(
                          itemCount: _pdfList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 10,
                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    _pdfList[index],
                                  ),
                                ),
                              ),
                            );
                          })
                      : SingleChildScrollView(
                          child: Text(_pdfText),
                        ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: Icon(Icons.g_translate, color: Colors.black, size: 30),
      ),
    );
  }

  Future<String> getPDFtext(String path) async {
    String text = "";
    try {
      text = await ReadPdfText.getPDFtext(path);
    } on PlatformException {
      text = 'Failed to get PDF text.';
    }
    return text;
  }

  // Gets all the text from PDF document, returns it in array where each element is a page of the document.
  Future<List<String>> getPDFtextPaginated(String path) async {
    List<String> textList = List<String>();
    try {
      textList = await ReadPdfText.getPDFtextPaginated(path);
    } on PlatformException {}
    return textList;
  }

  // Gets the length of the PDF document.
  Future<int> getPDFlength(String path) async {
    int length = 0;
    try {
      length = await ReadPdfText.getPDFlength(path);
    } on PlatformException {}
    return length;
  }
}
