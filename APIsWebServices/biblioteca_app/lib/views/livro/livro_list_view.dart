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
      _livros = [];
    }
    setState(() {
      _carregando = false;
    });
  }

  Future<void> _adicionarLivroParaUsuario(String usuarioId) async {
    final novoLivro = Livro(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      titulo: 'Novo Livro do Usuário',
      autor: usuarioId,
      disponivel: true,
    );
    await _controller.create(novoLivro);
    _carregarDados();
  }

  Future<void> _atualizarDisponibilidade(Livro livro, bool novoValor) async {
    final atualizado = Livro(
      id: livro.id,
      titulo: livro.titulo,
      autor: livro.autor,
      disponivel: novoValor,
    );
    await _controller.update(atualizado);
    _carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros do Usuário'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              // Exemplo: Adiciona livro para usuário com id "1"
              await _adicionarLivroParaUsuario("1");
            },
            tooltip: 'Adicionar Livro para Usuário',
          ),
        ],
      ),
      body: _livros.isEmpty
          ? const Center(child: Text('Nenhum livro encontrado.'))
          : ListView.builder(
              itemCount: _livros.length,
              itemBuilder: (context, index) {
                final livro = _livros[index];
                return ListTile(
                  title: Text('Título: ${livro.titulo}'),
                  subtitle: Text('Autor/Usuário: ${livro.autor}'),
                  trailing: Switch(
                    value: livro.disponivel,
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    onChanged: (value) async {
                      await _atualizarDisponibilidade(livro, value);
                    },
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LivroFormView(livro: livro),
                      ),
                    );
                    _carregarDados();
                  },
                );
              },
            ),
    );
  }
}