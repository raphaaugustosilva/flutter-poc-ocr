import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class OCRHelper {
  static Future<Map<String, dynamic>> ocrFoto(File arquivoImagem) async {
    Map<String, dynamic> _textosEncontrados = Map<String, dynamic>();
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(arquivoImagem);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    int i = 0;
    visionText.blocks.forEach((textoEncontrado) {
      i++;
      _textosEncontrados["Chave $i"] = textoEncontrado.text;
    });

    return _textosEncontrados;

    // for (TextBlock bloco in visionText.blocks) {
    //   final Rectangle<int> boundingBox = bloco.boundingBox;
    //   final List<Point<int>> cornerPoints = bloco.cornerPoints;
    //   final String texto = bloco.text;
    //   final List<RecognizedLanguage> linguagens = bloco.recognizedLanguages;

    //   for (TextLine line in bloco.lines) {
    //     print(line.text);

    //   for (TextElement element in line.elements) {
    //     print(element.text);
    //   }
    //}
  }
}
