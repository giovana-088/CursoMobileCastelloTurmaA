import 'package:flutter/material.dart';
import 'perfil_page.dart'; // Importando a página de perfil

void main() {  //onde roda minha aplicação
  runApp(const MyApp());  //Widget Principal (Elementos Visuais) - raiz do meu aplicativo 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: UserDataPage(), 
    );
  }
}