# POC de OCR desenvolvida com Flutter

 POC mobile utilizando Flutter para testar OCR (Optical character recognition, ou Reconhecimento ótico de caracteres).

 O projeto tem o propósito de fornecer ao usuário a possibilidade de tirar uma foto (ou escolher da galeria), aplicar o OCR e salvar os resultados em nuvem (utilizando o Firestore do Firebase), afim de verificarmos a eficiência dos resultados obtidos.

 O provedor de OCR utilizado foi do Firebase (Google Cloud Vision).


# Desenvolvimento
 É possível utilizar o Android Studio ou VS Code para desenvolvimento com o Flutter, e é possível desenvolver tanto em Windows quanto em MAC


# Passos iniciais
 - Instalar o [Flutter](https://flutter.dev/docs/get-started/install)
 - Instalar o [Android Studio](https://developer.android.com/studio/?hl=pt-br)
 - Opcional: Instalar o [VS Code](https://code.visualstudio.com/download)
 - Instalar o plugin Dart para Android Studio ou VS Code (qual for a plataforma escolhida)
 - Instalar o plugin Flutter para Android Studio ou VS Code (qual for a plataforma escolhida)
 
 
# Plugins utilizados
 - image_picker: ^0.4.12+1 => Utilizado para acessar o recurso de tirar foto / escolher foto da galeria
 - firebase_ml_vision: ^0.7.0 => Utilizado para implementar o OCR do Firebase 
 - firebase_storage: ^1.0.4 => Utilizado para acessar o Firestore do Firebase
 - cloud_firestore: ^0.8.2+3 => Utilizado para acessar o Firestore do Firebase
 - intl: ^0.15.8 => Utilizado para formatação de datas

# LINKS
 - [Escreva seu primeiro aplicativo em Flutter](https://flutter.io/docs/get-started/codelab)
 - [Documentação Flutter online](https://flutter.io/docs)
 - [Configuração para implementar OCR do Firebase](https://firebase.google.com/docs/ml-kit/recognize-text)
