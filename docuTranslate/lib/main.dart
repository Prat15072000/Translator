import 'package:docuTranslate/imageFile.dart';
import 'package:flutter/material.dart';
import 'package:docuTranslate/textFile.dart';
import 'package:docuTranslate/pdfFile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TextFile(),
    );
  }
}
