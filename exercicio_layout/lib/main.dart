import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp(), debugShowCheckedModeBanner: false));
}

//Construir a Janela
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tela de Perfil"),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Imagem de perfil
            CircleAvatar(
              radius: 70,
              backgroundImage: NetworkImage(
                "https://www.example.com/imagem_de_perfil.jpg",
              ),
            ),
            SizedBox(height: 20), // Espaço entre a imagem e o nome
            // Nome do usuário
            Text(
              "Giovana",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 35, 150),
              ),
            ),
            SizedBox(height: 10), // Espaço entre o nome e a descrição
            // Descrição do usuário
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "~.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ),
            SizedBox(height: 20), // Espaço entre a descrição e o botão
            // Estrelas de avaliação
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 30),  // Estrela 1
                Icon(Icons.star, color: Colors.amber, size: 30),  // Estrela 2
                Icon(Icons.star, color: Colors.amber, size: 30),  // Estrela 3
                Icon(Icons.star_border, color: Colors.grey, size: 30), // Estrela 4
                Icon(Icons.star_border, color: Colors.grey, size: 30), // Estrela 5
              ],
            ),
            SizedBox(height: 20), // Espaço entre as estrelas e o botão
            // Botão de contato
            ElevatedButton(
              onPressed: () {
                print("Botão de Contato Pressionado");
              },
              child: Text("Entrar em Contato"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal, // Cor do botão
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

