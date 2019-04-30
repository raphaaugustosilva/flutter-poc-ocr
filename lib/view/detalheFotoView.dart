import 'dart:typed_data';

import 'package:flutter/material.dart';

class DetalheFotoView extends StatelessWidget {
  final Uint8List fotoEmMemoria;
  DetalheFotoView(this.fotoEmMemoria);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes da imagem"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: Center(
            child: Image.memory(
          fotoEmMemoria,
          alignment: Alignment.center,
          fit: BoxFit.scaleDown,
        )),
      ),
    );
  }
}
