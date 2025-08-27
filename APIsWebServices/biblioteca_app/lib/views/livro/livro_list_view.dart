import 'package:biblioteca_app/controllers/livros_controller.dart';
import 'package:biblioteca_app/models/livros_model.dart';
import 'package:biblioteca_app/views/livro/livro_form_view.dart';
import 'package:flutter/material.dart';

class LivroListView extends StatefulWidget {
  const LivroListView({super.key});

  @override
  State<LivroListView> createState() => _LivroListViewState();
}

class _LivroListViewState extends State<LivroListView> {
  final _controller = LivrosController();
  List<Livro> _livros = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _carregando = true;
    });
    try {
      _livros = await _controller.fetchAll();
    } catch (e) {
      // Tratar erro
      _livros = [];
    }
    setState(() {
      _carregando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_livros.isEmpty) {
      return const Center(child: Text('Nenhum livro encontrado.'));
    }
    return ListView.builder(
      itemCount: _livros.length,
      itemBuilder: (context, index) {
        final livro = _livros[index];
        return ListTile(
          title: Text(livro.titulo),
          subtitle: Text(livro.autor),
          trailing: Icon(
            livro.disponivel ? Icons.check_circle : Icons.cancel,
            color: livro.disponivel ? Colors.green : Colors.red,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LivroFormView(livro: livro),
              ),
            ).then((_) => _carregarDados());
          },
        );
      },
    );
  }
}