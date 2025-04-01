import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp()));
}

// criar a Janela Principal
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // lista de imagens iniciais
  List<String> _imagens = [
    "https://images.unsplash.com/photo-1506748686214-e9df14d4d9d0",
    "https://images.unsplash.com/photo-1521747116042-5a810fda9664",
    "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
    "https://images.unsplash.com/photo-1518837695005-2083093ee35b",
    "https://images.unsplash.com/photo-1501594907352-04cda38ebc29",
    "https://images.unsplash.com/photo-1519681393784-d120267933ba",
    "https://images.unsplash.com/photo-1531259683007-016a7b628fc3",
    "https://images.unsplash.com/photo-1506619216599-9d16d0903dfd",
    "https://images.unsplash.com/photo-1494172961521-33799ddd43a5",
    "https://images.unsplash.com/photo-1517245386807-bb43f82c33c4",
  ];

  // Controlador de texto para capturar a URL da nova imagem
  final TextEditingController _controller = TextEditingController();

  // Função para adicionar uma nova imagem
  void _adicionarImagem() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Adicionar Nova Imagem"),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Digite a URL da imagem"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Adicionar"),
              onPressed: () {
                setState(() {
                  // Adiciona a nova URL à lista de imagens, se não for vazia
                  if (_controller.text.isNotEmpty) {
                    _imagens.add(_controller.text);
                  }
                  _controller.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Galeria de Imagens"),
        centerTitle: true,
      ), // barra superior do App
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            // Botão para adicionar uma nova imagem
            ElevatedButton(
              onPressed: _adicionarImagem,
              child: Text("Adicionar Imagem"),
            ),
            // Galeria de imagens em uma grade
            Expanded(
              child: GridView.builder(
                  // construir uma grid a partir de uma lista
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // quantidade de imagens por linha
                    crossAxisSpacing: 8, // espaçamento entre colunas
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _imagens.length,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () => _mostrarImagem(context, _imagens[index]), // Exibe a Imagem em tela cheia ao tocar
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(_imagens[index], fit: BoxFit.cover)),
                      )),
            )
          ],
        ),
      ),
    );
  }

  // função para mostrar a imagem em tela cheia
  void _mostrarImagem(BuildContext context, String imagem) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Image.network(imagem),
      ),
    );
  }
}
