import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_ocr_sage/helper/fotoHelper.dart';
import 'package:flutter_ocr_sage/helper/ocrHelper.dart';
import 'package:flutter_ocr_sage/view/detalheFotoView.dart';
import 'package:flutter_ocr_sage/view/feedbackView.dart';

class AbaTirarFoto extends StatefulWidget {
  @override
  _AbaTirarFotoState createState() => _AbaTirarFotoState();
}

class _AbaTirarFotoState extends State<AbaTirarFoto> {
  Uint8List fotoEmMemoria;
  File _arquivoImagem;
  Map<String, dynamic> _textosEncontrados;
  bool _carregandoAnalise = false;

  static const String _ordemLeituraDadosCimaBaixo = "De cima para baixo";
  static const String _ordemLeituraDadosBaixoCima = "De baixo para cima";
  static const String _ordemLeituraDadosEsquerdaDireita =
      "Da esquerda para a direita";
  static const String _ordemLeituraDadosDireitaEsquerda =
      "Da direita para a esquerda";
  String _ordemLeituraDadosSelecionada = _ordemLeituraDadosCimaBaixo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 10),
                fotoEmMemoria == null
                    ? Text("")
                    : GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DetalheFotoView(fotoEmMemoria)));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.transparent,
                            radius: 40,
                            backgroundImage: MemoryImage(
                              fotoEmMemoria ?? "",
                            ),
                          ),
                        ),
                      ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        await _tirarFotoEAplicarOCR(ObterFotoEnum.tirarFoto);
                      },
                      child: Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.blue[500],
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        await _tirarFotoEAplicarOCR(ObterFotoEnum.galeria);
                      },
                      child: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.blue[500],
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Ordem de leitura dos dados",
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  hint: Text("Ordem de leitura de dados:",
                      maxLines: 1, style: TextStyle(fontSize: 12)),
                  isDense: true,
                  isExpanded: true,
                  value: _ordemLeituraDadosSelecionada,
                  onChanged: (String ordemLeituraDadosSelecionada) {
                    setState(() {
                      _ordemLeituraDadosSelecionada =
                          ordemLeituraDadosSelecionada;
                    });

                    _aplicarOCR();
                  },
                  items: <String>{
                    _ordemLeituraDadosCimaBaixo,
                    _ordemLeituraDadosBaixoCima,
                    _ordemLeituraDadosEsquerdaDireita,
                    _ordemLeituraDadosDireitaEsquerda
                  }
                      .map<DropdownMenuItem<String>>(
                          (String ordemLeituraDados) {
                    return DropdownMenuItem<String>(
                      value: ordemLeituraDados,
                      child: Text(ordemLeituraDados ?? "",
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          softWrap: true,
                          style: TextStyle(fontSize: 12)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Card(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // children:
                //     _constroiResultadoAnalise(resultados: _textosEncontrados),
                children: <Widget>[
                  Text(
                    "Resultados da análise:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  _carregandoAnalise
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          children: _constroiResultadoAnalise(
                              resultados: _textosEncontrados),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton:
          fotoEmMemoria != null ? _constroiBotaoFeedback() : null,
    );
  }

  Widget _constroiBotaoFeedback() {
    return FloatingActionButton(
      child: Icon(
        Icons.send,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                FeedbackView(fotoEmMemoria, _textosEncontrados)));
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  List<Widget> _constroiResultadoAnalise({Map<String, dynamic> resultados}) {
    List<Widget> widgetResultados = List<Widget>();

    if (resultados != null && resultados.length > 0) {
      resultados.forEach((titulo, resultado) {
        widgetResultados
            .add(_constroiElementoResultadoAnalise(titulo, resultado));
      });
    }
    return widgetResultados;
  }

  Widget _constroiElementoResultadoAnalise(String titulo, String resultado) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 15),
      child: Row(
        children: <Widget>[
          Text(titulo, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 5),
          Expanded(child: Text(resultado)),
        ],
      ),
    );
  }

  OrdemLeituraDadosEnum _recuperaOrdemLeituraDadosEnum() {
    switch (_ordemLeituraDadosSelecionada) {
      case _ordemLeituraDadosCimaBaixo:
        return OrdemLeituraDadosEnum.cimaParaBaixo;
        break;

      case _ordemLeituraDadosBaixoCima:
        return OrdemLeituraDadosEnum.baixoParaCima;
        break;

      case _ordemLeituraDadosEsquerdaDireita:
        return OrdemLeituraDadosEnum.esquerdaParaDireita;
        break;

      case _ordemLeituraDadosDireitaEsquerda:
        return OrdemLeituraDadosEnum.diretaParaEsquerda;
        break;

      default:
        return OrdemLeituraDadosEnum.cimaParaBaixo;
        break;
    }
  }

  Future _tirarFotoEAplicarOCR(ObterFotoEnum obterFotoEnum) async {
    _arquivoImagem = await FotoHelper.selecionarFoto(obterFotoEnum);
    setState(() {
      fotoEmMemoria = _arquivoImagem.readAsBytesSync();
    });

    _aplicarOCR();
  }

  Future _aplicarOCR() async {
    if (_arquivoImagem == null) return;

    OrdemLeituraDadosEnum ordemLeituraDadosEnum =
        _recuperaOrdemLeituraDadosEnum();
        
    setState(() {
      _carregandoAnalise = true;
    });

    var resultadoOCR =
        await OCRHelper.ocrFoto(_arquivoImagem, ordemLeituraDadosEnum);

    setState(() {
      _textosEncontrados = resultadoOCR;
      _carregandoAnalise = false;
    });
  }
}
