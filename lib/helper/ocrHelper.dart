import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

enum OrdemLeituraDadosEnum {cimaParaBaixo, baixoParaCima, esquerdaParaDireita, diretaParaEsquerda}

class OCRHelper {
  static Future<Map<String, dynamic>> ocrFoto(File arquivoImagem, OrdemLeituraDadosEnum ordemLeituraDados) async {
    Map<String, dynamic> _textosEncontrados = Map<String, dynamic>();
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(arquivoImagem);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();
    final VisionText visionText = await textRecognizer.processImage(visionImage);

    //Ordena a posição dos resultados "de cima para baixo"
    List<TextBlock> resultadosOrdenadosPorLinha = List.from(visionText.blocks);
    
    if (ordemLeituraDados == OrdemLeituraDadosEnum.cimaParaBaixo)
      resultadosOrdenadosPorLinha.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));
    else if (ordemLeituraDados == OrdemLeituraDadosEnum.baixoParaCima)
      resultadosOrdenadosPorLinha.sort((a, b) => b.boundingBox.top.compareTo(a.boundingBox.top));
    else if (ordemLeituraDados == OrdemLeituraDadosEnum.esquerdaParaDireita)
      resultadosOrdenadosPorLinha.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
    else if (ordemLeituraDados == OrdemLeituraDadosEnum.diretaParaEsquerda)
      resultadosOrdenadosPorLinha.sort((a, b) => b.boundingBox.left.compareTo(a.boundingBox.left));

    
    int i = 0;
    resultadosOrdenadosPorLinha.forEach((textoEncontrado) {
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
