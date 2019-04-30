import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ocr_sage/view/feedbackVisualizacaoView..dart';

enum OpcoesOrdenacao { ordenazaoAZ, ordenazaoZA }

class AbaResultados extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("resultados").getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else {
          return ListView(
            children: snapshot.data.documents
                .map((resultado) => _constroiResultado(context, resultado))
                .toList(),
          );
        }
      },
    );
  }

  Widget _constroiResultado(BuildContext context, DocumentSnapshot snapshot) {
    return Card(
      color: Colors.lightBlue[700],
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: BoxDecoration(
                  border: Border(
                      right: BorderSide(width: 1.0, color: Colors.white24))),
              child: Text(
                "${snapshot.data["percentualAcerto"].toString()} %",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            title: Text(snapshot.data["tipoDocumento"],
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(snapshot.data["comentarios"],
                style: TextStyle(color: Colors.white),
                maxLines: 1,
                softWrap: true),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      FeedbackVisualizacaoView(snapshot.data)));
            },
          ),
        ],
      ),
    );
  }
}
