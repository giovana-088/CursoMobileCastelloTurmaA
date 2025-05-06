import 'package:flutter/material.dart';
import 'perfil_page.dart'; // Importando a página de perfil

void main() {
  runApp(MeuPerfilApp());
}

class MeuPerfilApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Perfil Persistente',
      debugShowCheckedModeBanner: false,
      home: PerfilPage(), // A página de perfil será a tela inicial
    );
  }
}