import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ocr_sage/view/detalheFotoView.dart';

class FeedbackView extends StatefulWidget {
  @override
  _FeedbackViewState createState() => _FeedbackViewState();

  final Uint8List _fotoEmMemoria;
  final Map<String, dynamic> _textosEncontrados;
  FeedbackView(this._fotoEmMemoria, this._textosEncontrados);
}

class _FeedbackViewState extends State<FeedbackView> {
  var _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _controladorComentarios = TextEditingController();
  final _controladorNome = TextEditingController();

  double _percentualAcerto = 0;

  String _tipoDocumentoSelecionado;
  String _tipoDocumentoErro;

  bool _enviandoResultado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Salvar resultado"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            SizedBox(height: 8),
            _constroiMiniaturaClicavelFoto(),
            SizedBox(height: 20),
            _constroiTiposDocumento(),
            _tipoDocumentoErro == null
                ? SizedBox.shrink()
                : Text(
                    _tipoDocumentoErro ?? "",
                    style: TextStyle(color: Colors.red[800], fontSize: 12),
                  ),
            SizedBox(height: 6),
            TextFormField(
              controller: _controladorComentarios,
              decoration: InputDecoration(hintText: "Comentários"),
              maxLines: 4,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _controladorNome,
              decoration: InputDecoration(hintText: "Nome"),
            ),
            SizedBox(height: 36),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Percentual de acerto"),
                  Slider(
                      value: _percentualAcerto,
                      min: 0,
                      max: 100,
                      onChanged: (valor) {
                        setState(() {
                          _percentualAcerto = valor;
                        });
                      }),
                  Center(
                      child:
                          Text("${(_percentualAcerto).toStringAsFixed(0)} %"))
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              "Obs: A imagem NÃO será enviada, apenas os resultados.",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 44,
              child: RaisedButton(
                child: Text("Enviar", style: TextStyle(fontSize: 18)),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  if (_validarForm()) {
                    Map<String, dynamic> resultados = {
                      "dataHora": DateTime.now(),
                      "tipoDocumento": _tipoDocumentoSelecionado,
                      "comentarios": _controladorComentarios?.text ?? "",
                      "nome": _controladorNome?.text ?? "",
                      "percentualAcerto": _percentualAcerto.round(),
                      "resultadosOCR": widget._textosEncontrados,
                    };

                    if (await _enviarResultados(resultados)) {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: Text("Resultado enviado com sucesso!"),
                          backgroundColor: Theme.of(context).primaryColor,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    } else {
                      _scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content:
                              Text("Ocorreu um erro ao enviar o resultado"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }

                    await Future.delayed(Duration(milliseconds: 500));

                    Future.delayed(Duration(milliseconds: 300)).then((_) {
                      Navigator.of(context).pop();
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
                child: _enviandoResultado
                    ? CircularProgressIndicator()
                    : SizedBox.shrink())
          ],
        ),
      ),
    );
  }

  Widget _constroiMiniaturaClicavelFoto() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetalheFotoView(widget._fotoEmMemoria)));
      },
      child: Container(
        alignment: Alignment.center,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          radius: 40,
          backgroundImage: MemoryImage(
            widget._fotoEmMemoria ?? "",
          ),
        ),
      ),
    );
  }

  Widget _constroiTiposDocumento() {
    return FutureBuilder<DocumentSnapshot>(
      future: Firestore.instance
          .collection("tiposDocumento")
          .document("tiposDocumento")
          .get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else {
          List<String> listaTiposDocumentos =
              List.from(snapshot.data["documentos"]);

          return DropdownButton<String>(
            hint: Text("Selecione o tipo de documento *", maxLines: 1),
            isDense: true,
            isExpanded: true,
            value: _tipoDocumentoSelecionado,
            onChanged: (String tipoDocumentoSelecionado) {
              setState(() {
                _tipoDocumentoSelecionado = tipoDocumentoSelecionado;
                _tipoDocumentoErro = null;
              });
            },
            items: listaTiposDocumentos
                .map<DropdownMenuItem<String>>((String documento) {
              return DropdownMenuItem<String>(
                value: documento,
                child: Text(
                  documento ?? "",
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: true,
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  bool _validarForm() {
    bool _validado = _formKey.currentState.validate();

    if (_tipoDocumentoSelecionado == null ||
        _tipoDocumentoSelecionado.isEmpty) {
      setState(() {
        _tipoDocumentoErro = "Por favor, selecione o tipo de documento!";
        _validado = false;
      });
    }
    return _validado;
  }

  Future<bool> _enviarResultados(Map<String, dynamic> resultados) async {
    bool resultado = false;

    setState(() {
      _enviandoResultado = true;
    });

    try {
      await Firestore.instance
          .collection("resultados")
          .document()
          .setData((resultados));
      resultado = true;
    } catch (ex) {
      resultado = false;
    }

    setState(() {
      _enviandoResultado = false;
    });

    return resultado;
  }
}
