import 'package:flutter/material.dart';
import 'package:flutter_ocr_sage/view/paginaPrincipalView.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR Sage Flutter',
      home: PaginaPrincipalView(),
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color.fromARGB(255, 4, 125, 141)),
      debugShowCheckedModeBanner: false,
    );
  }
}
