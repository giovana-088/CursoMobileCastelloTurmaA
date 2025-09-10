import 'package:biblioteca_app/controllers/livro_controller.dart';
import 'package:biblioteca_app/models/livro_model.dart';
import 'package:biblioteca_app/models/livros_model.dart';
import 'package:biblioteca_app/views/home_view.dart';
import 'package:flutter/material.dart';

class LivroFormView extends StatefulWidget {
  const LivroFormView({super.key, required Livro livro});

  @override
  State<LivroFormView> createState() => _LivroFormViewState();
}

class _LivroFormViewState extends State<LivroFormView> {
  final _formKey = GlobalKey<FormState>();
  final _controller = LivroController();
  final _tituloField = TextEditingController();
  final _autorField = TextEditingController();

  void _criar() async {
    if (_formKey.currentState!.validate()) {
      final livroNovo = LivroModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        titulo: _tituloField.text.trim(),
        autor: _autorField.text.trim(),
        disponivel: true,
      );
      try {
        await _controller.create(livroNovo);
      } catch (e) {
        // Tratar erro se necessário
      }
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Novo Livro")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloField,
                decoration: InputDecoration(labelText: "Título"),
                validator: (value) =>
                    value!.isEmpty ? "Informe o Título" : null,
              ),
              TextFormField(
                controller: _autorField,
                decoration: InputDecoration(labelText: "Autor"),
                validator: (value) =>
                    value!.isEmpty ? "Informe o Autor" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _criar,
                child: Text("Criar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LivroModel {
  final String id;
  final String titulo;
  final String autor;
  final bool disponivel;

  LivroModel({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.disponivel,
  });
}

class LivroController {
  Future<void> create(LivroModel livroNovo) async {}
}
    