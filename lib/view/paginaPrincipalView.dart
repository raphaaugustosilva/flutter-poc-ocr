import 'package:flutter/material.dart';
import 'package:flutter_ocr_sage/view/abaResultados.dart';
import 'package:flutter_ocr_sage/view/abaTirarFoto.dart';

class PaginaPrincipalView extends StatefulWidget {
  @override
  _PaginaPrincipalViewState createState() => _PaginaPrincipalViewState();
}

class _PaginaPrincipalViewState extends State<PaginaPrincipalView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("OCR Sage Flutter"),
            backgroundColor: Theme.of(context).primaryColor,
            centerTitle: true,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.grid_on),
                ),
                Tab(
                  icon: Icon(Icons.list),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              AbaTirarFoto(),
              AbaResultados(),
            ],
          ),
        ),
      ),
    );
  }
}
