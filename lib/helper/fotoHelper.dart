import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

enum ObterFotoEnum { tirarFoto, galeria }

class FotoHelper {
  static Future<File> selecionarFoto(ObterFotoEnum obterFotoEnum) async {
    File arquivoImagem;

    if (obterFotoEnum == ObterFotoEnum.tirarFoto)
      arquivoImagem = await ImagePicker.pickImage(source: ImageSource.camera);
    else
      arquivoImagem = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (arquivoImagem == null) return null;

    return arquivoImagem;
  }
}
