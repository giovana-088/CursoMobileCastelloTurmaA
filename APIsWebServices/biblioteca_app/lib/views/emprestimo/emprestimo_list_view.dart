import 'package:biblioteca_app/controllers/emprestimo_controller.dart';
import 'package:biblioteca_app/models/emprestimo_model.dart';
import 'package:biblioteca_app/views/emprestimo/emprestimo_form_view.dart';
import 'package:flutter/material.dart';

class EmprestimoListView extends StatefulWidget {
  const EmprestimoListView({super.key});

  @override
  State<EmprestimoListView> createState() => _EmprestimoListViewState();
}

class _EmprestimoListViewState extends State<EmprestimoListView> {
  final _controller = EmprestimoController();
  List<Emprestimo> _emprestimos = [];
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
      _emprestimos = await _controller.fetchAll();
    } catch (e) {
      _emprestimos = [];
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
    if (_emprestimos.isEmpty) {
      return const Center(child: Text('Nenhum empréstimo encontrado.'));
    }
    return ListView.builder(
      itemCount: _emprestimos.length,
      itemBuilder: (context, index) {
        final emprestimo = _emprestimos[index];
        return ListTile(
          title: Text('Usuário: ${emprestimo.usuarioId}'),
          subtitle: Text('Livro: ${emprestimo.livroId}\nDevolução: ${emprestimo.dataDevolucao}'),
          trailing: Icon(
            emprestimo.devolvido ? Icons.check_circle : Icons.schedule,
            color: emprestimo.devolvido ? Colors.green : Colors.orange,
          ),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EmprestimoFormView(emprestimo: emprestimo),
              ),
            );
            _carregarDados();
          },
        );
      },
    );
  }
}