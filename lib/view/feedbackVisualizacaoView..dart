import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FeedbackVisualizacaoView extends StatefulWidget {
  @override
  _FeedbackVisualizacaoViewState createState() =>
      _FeedbackVisualizacaoViewState();

  final Map<String, dynamic> resultadosFeedback;
  FeedbackVisualizacaoView(this.resultadosFeedback);
}

class _FeedbackVisualizacaoViewState extends State<FeedbackVisualizacaoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resultado Feedback"),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            SizedBox(height: 8),
            Row(children: <Widget>[
              Text("Data: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(_converterParaDataFormatada(
                  widget.resultadosFeedback["dataHora"])),
            ]),
            SizedBox(height: 20),
            Row(children: <Widget>[
              Text("Tipo de documento: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.resultadosFeedback["tipoDocumento"]),
            ]),
            SizedBox(height: 20),
            Row(children: <Widget>[
              Text("Comentários: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  widget.resultadosFeedback["comentarios"],
                  softWrap: true,
                ),
              ),
            ]),
            SizedBox(height: 20),
            Row(children: <Widget>[
              Text("Nome: ", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(widget.resultadosFeedback["nome"]),
            ]),
            SizedBox(height: 20),
            Row(children: <Widget>[
              Text("Percentual de acerto: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                  "${widget.resultadosFeedback["percentualAcerto"].toString()} %"),
            ]),
            SizedBox(height: 20),
            Row(children: <Widget>[
              Text("Resultados OCR: ",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Expanded(
                  child: Text(
                      widget.resultadosFeedback["resultadosOCR"].toString())),
            ]),
          ],
        ),
      ),
    );
  }

  String _converterParaDataFormatada(var data) {
    String dataFormatada = "";
    try {
      dataFormatada = DateFormat("dd/MM/yyyy hh:mm").format(data.toDate());
    } catch (ex) {
      try {
        dataFormatada = DateFormat("dd/MM/yyyy hh:mm").format(data);
      } catch (e) {
        dataFormatada = data.toString();
      }
    }

    return dataFormatada;
  }
}
