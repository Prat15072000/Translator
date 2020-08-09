import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as Io;
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool upload = false;
  String text = '';

  extractImage() async {
    // pick the image

    final imagefile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 670,
      maxHeight: 970,
    );
    // prepare the image
    setState(() {
      upload = true;
    });
    var bytes = Io.File(imagefile.path.toString()).readAsBytesSync();
    String img64 = base64Encode(bytes);
    print(img64.toString());

    //send the data to the api

    var url = 'https://api.ocr.space/parse/image';
    var payload = {"base64Image": "data:image/jpg;base64, ${img64.toString()}"};
    var header = {'apikey': 'a3b35e995988957'};
    var post = await http.post(url, body: payload, headers: header);

    //get result
    var result = jsonDecode(post.body);
    setState(() {
      upload = false;
      print(result['ParsedResult'][0]['ParsedText']);
    });
  }

  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Document Translator'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  extractImage();
                },
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
                      height: h / 7,
                      width: w / 1,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.purpleAccent,
                      ),
                      child: Center(
                        child: Text(
                          'Upload Image',
                          style: TextStyle(fontSize: 30.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              upload == false ? Container() : CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  children: [
                    Text('Text is:'),
                    SizedBox(
                      height: 10,
                    ),
                    Text(text),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
