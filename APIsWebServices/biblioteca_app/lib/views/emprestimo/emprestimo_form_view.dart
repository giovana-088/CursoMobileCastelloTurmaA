import 'package:biblioteca_app/models/emprestimo_model.dart';
import 'package:biblioteca_app/controllers/emprestimo_controller.dart';
import 'package:flutter/material.dart';

class EmprestimoFormView extends StatefulWidget {
  final Emprestimo emprestimo;

  const EmprestimoFormView({super.key, required this.emprestimo});

  @override
  State<EmprestimoFormView> createState() => _EmprestimoFormViewState();
}

class _EmprestimoFormViewState extends State<EmprestimoFormView> {
  late bool _devolvido;
  final _controller = EmprestimoController();
  bool _salvando = false;

  @override
  void initState() {
    super.initState();
    _devolvido = widget.emprestimo.devolvido;
  }

  Future<void> _salvar() async {
    setState(() {
      _salvando = true;
    });
    final atualizado = Emprestimo(
      id: widget.emprestimo.id,
      usuarioId: widget.emprestimo.usuarioId,
      livroId: widget.emprestimo.livroId,
      dataEmprestimo: widget.emprestimo.dataEmprestimo,
      dataDevolucao: widget.emprestimo.dataDevolucao,
      devolvido: _devolvido,
    );
    await _controller.update(atualizado);
    setState(() {
      _salvando = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes do Empréstimo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${widget.emprestimo.id}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Usuário: ${widget.emprestimo.usuarioId}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Livro: ${widget.emprestimo.livroId}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Data do Empréstimo: ${widget.emprestimo.dataEmprestimo}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Data de Devolução: ${widget.emprestimo.dataDevolucao}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Devolvido:', style: TextStyle(fontSize: 18)),
                Switch(
                  value: _devolvido,
                  onChanged: (value) {
                    setState(() {
                      _devolvido = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 24),
            _salvando
                ? Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _salvar,
                    child: Text('Salvar'),
                  ),
          ],
        ),
      ),
    );
  }
}